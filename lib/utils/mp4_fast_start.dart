import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Minimal MP4 "faststart" fixer in pure Dart.
///
/// Many MP4s produced by mobile cameras store the `moov` box at the end.
/// Some players (notably ExoPlayer over HTTP) may need the moov box before
/// sample data to start playback quickly.
///
/// This function:
/// - Parses top-level MP4 boxes
/// - Moves `moov` directly after `ftyp`
/// - Rewrites `stco`/`co64` chunk offsets by the exact delta applied to `mdat`
///
/// Notes:
/// - Works for common non-fragmented MP4 files (ftyp + mdat + moov).
/// - If file is already faststart or parsing fails, it returns the original file.
class Mp4FastStart {
  static Future<File> ensureFastStart(File input, {Directory? tempDir}) async {
    try {
      if (!await input.exists()) return input;
      final len = await input.length();
      if (len <= 0) return input;
      if (!input.path.toLowerCase().endsWith('.mp4')) return input;

      final raf = await input.open(mode: FileMode.read);
      try {
        final boxes = await _readTopLevelBoxes(raf, len);
        final ftyp = boxes.firstWhere((b) => b.type == 'ftyp', orElse: () => _Box.none());
        final moov = boxes.firstWhere((b) => b.type == 'moov', orElse: () => _Box.none());
        final mdat = boxes.firstWhere((b) => b.type == 'mdat', orElse: () => _Box.none());

        if (!ftyp.isValid || !moov.isValid || !mdat.isValid) return input;

        // Already faststart? (moov before mdat)
        if (moov.offset < mdat.offset) return input;

        // Read and patch moov box
        final moovBytes = await _readRange(raf, moov.offset, moov.size);

        // Compute where mdat will move to in the output.
        // Output layout: [ftyp][moov][all other boxes except ftyp+moov, in original order]
        final newMdatOffset = ftyp.size + moov.size + _sumSizes(
          boxes.where((b) => b.isValid && b.type != 'ftyp' && b.type != 'moov' && b.offset < mdat.offset),
        );
        final delta = newMdatOffset - mdat.offset;

        final patchedMoov = Uint8List.fromList(moovBytes);
        _patchChunkOffsets(patchedMoov, delta);

        final outDir = tempDir ?? (await Directory.systemTemp.createTemp('mp4_faststart_'));
        final outFile = File('${outDir.path}${Platform.pathSeparator}faststart_${DateTime.now().millisecondsSinceEpoch}.mp4');
        final out = await outFile.open(mode: FileMode.write);
        try {
          // Write ftyp
          await _copyRange(raf, out, ftyp.offset, ftyp.size);
          // Write patched moov
          await out.writeFrom(patchedMoov);
          // Write remaining boxes (skip original ftyp and moov)
          for (final b in boxes) {
            if (!b.isValid) continue;
            if (b.type == 'ftyp' || b.type == 'moov') continue;
            await _copyRange(raf, out, b.offset, b.size);
          }
        } finally {
          await out.close();
        }

        // Sanity check
        if (await outFile.exists() && await outFile.length() > 0) return outFile;
      } finally {
        await raf.close();
      }
    } catch (_) {
      // fall back
    }
    return input;
  }

  static int _sumSizes(Iterable<_Box> boxes) => boxes.fold<int>(0, (acc, b) => acc + b.size);

  static Future<List<_Box>> _readTopLevelBoxes(RandomAccessFile raf, int fileLen) async {
    final boxes = <_Box>[];
    int offset = 0;
    while (offset + 8 <= fileLen) {
      await raf.setPosition(offset);
      final header = await raf.read(8);
      if (header.length < 8) break;

      final size32 = _u32(header, 0);
      final type = ascii.decode(header.sublist(4, 8));

      int size = size32;
      int headerSize = 8;
      if (size32 == 1) {
        // extended size
        final ext = await raf.read(8);
        if (ext.length < 8) break;
        size = _u64(ext, 0);
        headerSize = 16;
      } else if (size32 == 0) {
        // extends to EOF
        size = fileLen - offset;
      }

      if (size < headerSize || offset + size > fileLen) break;
      boxes.add(_Box(type: type, offset: offset, size: size));
      offset += size;
    }
    return boxes;
  }

  static Future<Uint8List> _readRange(RandomAccessFile raf, int offset, int length) async {
    await raf.setPosition(offset);
    final bytes = await raf.read(length);
    return Uint8List.fromList(bytes);
  }

  static Future<void> _copyRange(RandomAccessFile inRaf, RandomAccessFile outRaf, int offset, int length) async {
    const chunk = 1024 * 1024;
    int remaining = length;
    int pos = offset;
    while (remaining > 0) {
      final toRead = remaining > chunk ? chunk : remaining;
      await inRaf.setPosition(pos);
      final data = await inRaf.read(toRead);
      if (data.isEmpty) break;
      await outRaf.writeFrom(data);
      pos += data.length;
      remaining -= data.length;
    }
  }

  static int _u32(Uint8List b, int o) =>
      (b[o] << 24) | (b[o + 1] << 16) | (b[o + 2] << 8) | (b[o + 3]);

  static int _u64(Uint8List b, int o) {
    final hi = _u32(b, o);
    final lo = _u32(b, o + 4);
    return (hi << 32) | lo;
  }

  static void _w32(Uint8List b, int o, int v) {
    b[o] = (v >> 24) & 0xFF;
    b[o + 1] = (v >> 16) & 0xFF;
    b[o + 2] = (v >> 8) & 0xFF;
    b[o + 3] = v & 0xFF;
  }

  static void _w64(Uint8List b, int o, int v) {
    final hi = (v >> 32) & 0xFFFFFFFF;
    final lo = v & 0xFFFFFFFF;
    _w32(b, o, hi);
    _w32(b, o + 4, lo);
  }

  static const Set<String> _containers = {
    'moov', 'trak', 'mdia', 'minf', 'stbl', 'edts', 'dinf', 'udta', 'meta', 'ilst', 'mvex',
  };

  static void _patchChunkOffsets(Uint8List moovBox, int delta) {
    // Skip size+type (8 bytes, or 16 for extended - but moovBox includes them; we just parse generically)
    _walkBoxes(moovBox, 0, moovBox.length, delta);
  }

  static void _walkBoxes(Uint8List data, int start, int end, int delta) {
    int off = start;
    while (off + 8 <= end) {
      final size32 = _u32(data, off);
      final type = ascii.decode(data.sublist(off + 4, off + 8));

      int size = size32;
      int header = 8;
      if (size32 == 1) {
        if (off + 16 > end) return;
        size = _u64(data, off + 8);
        header = 16;
      } else if (size32 == 0) {
        size = end - off;
      }
      if (size < header || off + size > end) return;

      final boxStart = off;
      final boxEnd = off + size;
      final payloadStart = off + header;

      if (type == 'stco') {
        // version+flags (4) + entry_count (4) + entries
        if (payloadStart + 8 <= boxEnd) {
          final entryCount = _u32(data, payloadStart + 4);
          int p = payloadStart + 8;
          for (int i = 0; i < entryCount && p + 4 <= boxEnd; i++) {
            final old = _u32(data, p);
            _w32(data, p, old + delta);
            p += 4;
          }
        }
      } else if (type == 'co64') {
        if (payloadStart + 8 <= boxEnd) {
          final entryCount = _u32(data, payloadStart + 4);
          int p = payloadStart + 8;
          for (int i = 0; i < entryCount && p + 8 <= boxEnd; i++) {
            final old = _u64(data, p);
            _w64(data, p, old + delta);
            p += 8;
          }
        }
      } else if (_containers.contains(type)) {
        // Special case: 'meta' has 4 bytes version/flags before children
        int childStart = payloadStart;
        if (type == 'meta' && childStart + 4 <= boxEnd) childStart += 4;
        _walkBoxes(data, childStart, boxEnd, delta);
      }

      off = boxStart + size;
    }
  }
}

class _Box {
  final String type;
  final int offset;
  final int size;
  const _Box({required this.type, required this.offset, required this.size});
  bool get isValid => type.isNotEmpty && size > 0;
  static _Box none() => const _Box(type: '', offset: -1, size: 0);
}

