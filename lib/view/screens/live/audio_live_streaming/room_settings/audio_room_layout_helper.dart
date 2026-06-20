import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../zegocloud/zim_zego_sdk/internal/business/audioRoom/layout_config.dart';

/// Total mic seats in the room (1–20), including the host on seat 1 by default.
class AudioRoomLayoutHelper {
  static const int minCoHostSeats = 1;
  static const int maxCoHostSeats = 20;
  static const int zegoMaxColumns = 4;
  static const int compactUiThreshold = 12;
  static const int standardUiColumns = 4;

  static int clampCoHostCount(int count) {
    if (count < minCoHostSeats) return minCoHostSeats;
    if (count > maxCoHostSeats) return maxCoHostSeats;
    return count;
  }

  static List<ZegoLiveAudioRoomLayoutRowConfig> buildRowConfigs(int totalSeats) {
    final count = clampCoHostCount(totalSeats);
    final configs = <ZegoLiveAudioRoomLayoutRowConfig>[];
    var remaining = count;
    while (remaining > 0) {
      final rowCount =
          remaining >= zegoMaxColumns ? zegoMaxColumns : remaining;
      configs.add(ZegoLiveAudioRoomLayoutRowConfig(count: rowCount));
      remaining -= rowCount;
    }
    return configs;
  }

  /// 5 columns × 4 rows for 13–20 seats; 4 columns otherwise.
  static int uiColumnsFor(int totalSeats) {
    final count = clampCoHostCount(totalSeats);
    return count > compactUiThreshold ? 5 : 4;
  }

  static int uiRowCount(int totalSeats) {
    final count = clampCoHostCount(totalSeats);
    final columns = uiColumnsFor(count);
    return (count / columns).ceil();
  }

  static AudioSeatGridMetrics gridMetricsFor({
    required int seatCount,
    required double maxWidth,
    required double maxHeight,
  }) {
    final count = clampCoHostCount(seatCount);
    final compact = count > compactUiThreshold;
    final columns = uiColumnsFor(count);
    final rows = uiRowCount(count);

    final crossSpacing = 10.w;
    final mainSpacing = compact ? 6.h : 8.h;
    final topPadding = compact ? 20.h : 16.h;
    final labelGap = 3.h;
    final textExtra = 4.h;

    // Same circle diameter as 4/8/10-seat rooms.
    final refCellWidth =
        (maxWidth - (standardUiColumns - 1) * crossSpacing) / standardUiColumns;
    var iconSize = refCellWidth * 0.76;
    var nameFontSize = 10.sp;

    final cellWidth = (maxWidth - (columns - 1) * crossSpacing) / columns;

    double measureContentHeight() {
      final rowH = iconSize + labelGap + nameFontSize + textExtra;
      return rows * rowH + (rows - 1) * mainSpacing;
    }

    var contentHeight = measureContentHeight();
    var totalHeight = topPadding + contentHeight;

    if (maxHeight > 0 && totalHeight > maxHeight) {
      final scale = maxHeight / totalHeight;
      iconSize *= scale;
      nameFontSize *= scale;
      contentHeight = measureContentHeight();
      totalHeight = topPadding + contentHeight;
    }

    final rowHeight = iconSize + labelGap + nameFontSize + textExtra;

    return AudioSeatGridMetrics(
      columns: columns,
      rows: rows,
      iconSize: iconSize,
      mainSpacing: mainSpacing,
      crossSpacing: crossSpacing,
      nameFontSize: nameFontSize,
      compact: compact,
      labelGap: labelGap,
      topPadding: topPadding,
      rowHeight: rowHeight,
      contentHeight: contentHeight,
      totalGridHeight: totalHeight,
      cellWidth: cellWidth,
    );
  }
}

class AudioSeatGridMetrics {
  final int columns;
  final int rows;
  final double iconSize;
  final double mainSpacing;
  final double crossSpacing;
  final double nameFontSize;
  final bool compact;
  final double labelGap;
  final double topPadding;
  final double rowHeight;
  final double contentHeight;
  final double totalGridHeight;
  final double cellWidth;

  const AudioSeatGridMetrics({
    required this.columns,
    required this.rows,
    required this.iconSize,
    required this.mainSpacing,
    required this.crossSpacing,
    required this.nameFontSize,
    required this.compact,
    required this.labelGap,
    required this.topPadding,
    required this.rowHeight,
    required this.contentHeight,
    required this.totalGridHeight,
    required this.cellWidth,
  });
}
