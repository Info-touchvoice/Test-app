import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki/helpers/quick_actions.dart';
import 'package:tiki/parse/LiveStreamingModel.dart';

class GroupHistoryEntry {
  final String objectId;
  final String name;
  final String image;
  final String country;
  final String flag;
  final int achievementCount;
  final int visitedAt;

  const GroupHistoryEntry({
    required this.objectId,
    required this.name,
    required this.image,
    required this.country,
    required this.flag,
    required this.achievementCount,
    required this.visitedAt,
  });

  Map<String, dynamic> toJson() => {
        'objectId': objectId,
        'name': name,
        'image': image,
        'country': country,
        'flag': flag,
        'achievementCount': achievementCount,
        'visitedAt': visitedAt,
      };

  factory GroupHistoryEntry.fromJson(Map<String, dynamic> json) {
    return GroupHistoryEntry(
      objectId: json['objectId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      country: json['country'] as String? ?? '',
      flag: json['flag'] as String? ?? '',
      achievementCount: json['achievementCount'] as int? ?? 0,
      visitedAt: json['visitedAt'] as int? ?? 0,
    );
  }

  static GroupHistoryEntry fromLiveModel(LiveStreamingModel liveModel) {
    const fallbackImage =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi-9Q5sx5ZaCLtCieoMMf_PITwvg9SYnwALQ&s';
    final author = liveModel.getAuthor;

    return GroupHistoryEntry(
      objectId: liveModel.objectId ?? '',
      name: author?.getFullName ?? liveModel.getTitle ?? 'Group',
      image: liveModel.getImage?.url ?? fallbackImage,
      country: author != null
          ? '${QuickActions.getCountryCode(author)} '
          : (liveModel.getTitle ?? ''),
      flag: author != null ? QuickActions.getCountryFlag(author) : '',
      achievementCount: author?.getCoins ?? liveModel.getViewsCount ?? 0,
      visitedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }
}

class GroupHistoryService {
  static const _recentKey = 'touchvoice_group_recent';
  static const _joinedKey = 'touchvoice_group_joined';
  static const _maxRecent = 30;

  static Future<void> recordVisit(LiveStreamingModel liveModel) async {
    if (liveModel.objectId == null || liveModel.objectId!.isEmpty) return;

    final entry = GroupHistoryEntry.fromLiveModel(liveModel);
    final prefs = await SharedPreferences.getInstance();

    final recent = await _readList(prefs, _recentKey);
    recent.removeWhere((e) => e.objectId == entry.objectId);
    recent.insert(0, entry);
    if (recent.length > _maxRecent) {
      recent.removeRange(_maxRecent, recent.length);
    }
    await _writeList(prefs, _recentKey, recent);

    final joined = await _readList(prefs, _joinedKey);
    if (!joined.any((e) => e.objectId == entry.objectId)) {
      joined.insert(0, entry);
      await _writeList(prefs, _joinedKey, joined);
    }
  }

  static Future<List<GroupHistoryEntry>> getRecent() async {
    final prefs = await SharedPreferences.getInstance();
    return _readList(prefs, _recentKey);
  }

  static Future<List<GroupHistoryEntry>> getJoined() async {
    final prefs = await SharedPreferences.getInstance();
    return _readList(prefs, _joinedKey);
  }

  static Future<List<GroupHistoryEntry>> _readList(
      SharedPreferences prefs, String key) async {
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => GroupHistoryEntry.fromJson(e as Map<String, dynamic>))
          .where((e) => e.objectId.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _writeList(
      SharedPreferences prefs, String key, List<GroupHistoryEntry> entries) {
    final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
    return prefs.setString(key, encoded);
  }
}
