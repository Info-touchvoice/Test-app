import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum RoomActionRecordType {
  kickOutMic,
  kickOutRoom,
}

class RoomActionRecord {
  final String id;
  final RoomActionRecordType type;
  final String targetUserId;
  final String targetUserName;
  final String? targetAvatarUrl;
  final String actorUserId;
  final String actorUserName;
  final String? actorAvatarUrl;
  final int timestampMs;

  const RoomActionRecord({
    required this.id,
    required this.type,
    required this.targetUserId,
    required this.targetUserName,
    this.targetAvatarUrl,
    required this.actorUserId,
    required this.actorUserName,
    this.actorAvatarUrl,
    required this.timestampMs,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'targetUserId': targetUserId,
        'targetUserName': targetUserName,
        'targetAvatarUrl': targetAvatarUrl,
        'actorUserId': actorUserId,
        'actorUserName': actorUserName,
        'actorAvatarUrl': actorAvatarUrl,
        'timestampMs': timestampMs,
      };

  factory RoomActionRecord.fromJson(Map<String, dynamic> json) {
    return RoomActionRecord(
      id: json['id'] as String,
      type: RoomActionRecordType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => RoomActionRecordType.kickOutMic,
      ),
      targetUserId: json['targetUserId'] as String? ?? '',
      targetUserName: json['targetUserName'] as String? ?? 'User',
      targetAvatarUrl: json['targetAvatarUrl'] as String?,
      actorUserId: json['actorUserId'] as String? ?? '',
      actorUserName: json['actorUserName'] as String? ?? 'Host',
      actorAvatarUrl: json['actorAvatarUrl'] as String?,
      timestampMs: json['timestampMs'] as int? ?? 0,
    );
  }
}

class RoomActionRecordsStore {
  static const _prefix = 'room_action_records_';
  static const _maxRecords = 200;

  static String _key(String roomId) => '$_prefix$roomId';

  static Future<List<RoomActionRecord>> load(
    String roomId,
    RoomActionRecordType type,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(roomId));
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = (jsonDecode(raw) as List)
          .map((e) => RoomActionRecord.fromJson(e as Map<String, dynamic>))
          .where((r) => r.type == type)
          .toList();
      list.sort((a, b) => b.timestampMs.compareTo(a.timestampMs));
      return list;
    } catch (_) {
      return [];
    }
  }

  static Future<void> log({
    required String roomId,
    required RoomActionRecordType type,
    required String targetUserId,
    required String targetUserName,
    String? targetAvatarUrl,
    required String actorUserId,
    required String actorUserName,
    String? actorAvatarUrl,
  }) async {
    if (roomId.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final records = <RoomActionRecord>[];
    final raw = prefs.getString(_key(roomId));
    if (raw != null && raw.isNotEmpty) {
      try {
        records.addAll(
          (jsonDecode(raw) as List)
              .map((e) => RoomActionRecord.fromJson(e as Map<String, dynamic>)),
        );
      } catch (_) {}
    }

    records.insert(
      0,
      RoomActionRecord(
        id: '${DateTime.now().millisecondsSinceEpoch}_$targetUserId',
        type: type,
        targetUserId: targetUserId,
        targetUserName: targetUserName,
        targetAvatarUrl: targetAvatarUrl,
        actorUserId: actorUserId,
        actorUserName: actorUserName,
        actorAvatarUrl: actorAvatarUrl,
        timestampMs: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    if (records.length > _maxRecords) {
      records.removeRange(_maxRecords, records.length);
    }

    await prefs.setString(
      _key(roomId),
      jsonEncode(records.map((r) => r.toJson()).toList()),
    );
  }
}
