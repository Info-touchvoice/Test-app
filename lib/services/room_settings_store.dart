import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki/parse/LiveStreamingModel.dart';

class RoomSettingsData {
  String roomIntroduction;
  String autoWelcome;
  int micCount;
  int diceCount;
  int membershipFee;
  bool touristsOnMic;
  bool touristsSendText;
  bool touristsSendPictures;
  String? activePresetTheme;
  String? activeCustomThemeUrl;
  List<String> myThemeUrls;

  RoomSettingsData({
    this.roomIntroduction = '',
    this.autoWelcome = '',
    this.micCount = 20,
    this.diceCount = 5,
    this.membershipFee = 0,
    this.touristsOnMic = true,
    this.touristsSendText = true,
    this.touristsSendPictures = true,
    this.activePresetTheme,
    this.activeCustomThemeUrl,
    this.myThemeUrls = const [],
  });

  Map<String, dynamic> toJson() => {
        'roomIntroduction': roomIntroduction,
        'autoWelcome': autoWelcome,
        'micCount': micCount,
        'diceCount': diceCount,
        'membershipFee': membershipFee,
        'touristsOnMic': touristsOnMic,
        'touristsSendText': touristsSendText,
        'touristsSendPictures': touristsSendPictures,
        'activePresetTheme': activePresetTheme,
        'activeCustomThemeUrl': activeCustomThemeUrl,
        'myThemeUrls': myThemeUrls,
      };

  factory RoomSettingsData.fromJson(Map<String, dynamic> json) {
    return RoomSettingsData(
      roomIntroduction: json['roomIntroduction'] as String? ?? '',
      autoWelcome: json['autoWelcome'] as String? ?? '',
      micCount: json['micCount'] as int? ?? 20,
      diceCount: json['diceCount'] as int? ?? 5,
      membershipFee: json['membershipFee'] as int? ?? 0,
      touristsOnMic: json['touristsOnMic'] as bool? ?? true,
      touristsSendText: json['touristsSendText'] as bool? ?? true,
      touristsSendPictures: json['touristsSendPictures'] as bool? ?? true,
      activePresetTheme: json['activePresetTheme'] as String?,
      activeCustomThemeUrl: json['activeCustomThemeUrl'] as String?,
      myThemeUrls: (json['myThemeUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  static RoomSettingsData fromLive(LiveStreamingModel live, {String defaultIntro = ''}) {
    final intro = live.getGoalTile?.trim().isNotEmpty == true
        ? live.getGoalTile!.trim()
        : defaultIntro;
    final welcome = live.getStickerTitle?.trim() ?? '';
    final coHost = live.getCoHostAuthorAvailable;

    return RoomSettingsData(
      roomIntroduction: intro,
      autoWelcome: welcome,
      micCount: live.getAudioSeats ?? 8,
      touristsOnMic: coHost ?? true,
    );
  }
}

class RoomSettingsStore {
  static String _key(String roomId) => 'touchvoice_room_settings_$roomId';

  static Future<RoomSettingsData> load(
    String? roomId,
    LiveStreamingModel live, {
    required String defaultIntro,
  }) async {
    final merged = RoomSettingsData.fromLive(live, defaultIntro: defaultIntro);
    if (roomId == null || roomId.isEmpty) return merged;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(roomId));
    if (raw == null || raw.isEmpty) return merged;

    try {
      final saved = RoomSettingsData.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      return RoomSettingsData(
        roomIntroduction: saved.roomIntroduction.isNotEmpty
            ? saved.roomIntroduction
            : merged.roomIntroduction,
        autoWelcome:
            saved.autoWelcome.isNotEmpty ? saved.autoWelcome : merged.autoWelcome,
        micCount: saved.micCount,
        diceCount: saved.diceCount,
        membershipFee: saved.membershipFee,
        touristsOnMic: saved.touristsOnMic,
        touristsSendText: saved.touristsSendText,
        touristsSendPictures: saved.touristsSendPictures,
        activePresetTheme: saved.activePresetTheme,
        activeCustomThemeUrl: saved.activeCustomThemeUrl,
        myThemeUrls: saved.myThemeUrls,
      );
    } catch (_) {
      return merged;
    }
  }

  static Future<void> save(String? roomId, RoomSettingsData data) async {
    if (roomId == null || roomId.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(roomId), jsonEncode(data.toJson()));
  }

  static String _lockedSeatsKey(String roomId) =>
      'touchvoice_locked_seats_$roomId';

  static Future<Set<int>> loadLockedSeats(String? roomId) async {
    if (roomId == null || roomId.isEmpty) return {};
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_lockedSeatsKey(roomId));
    if (raw == null) return {};
    return raw.map((e) => int.tryParse(e) ?? -1).where((i) => i >= 0).toSet();
  }

  static Future<void> saveLockedSeats(String? roomId, Set<int> seats) async {
    if (roomId == null || roomId.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _lockedSeatsKey(roomId),
      seats.map((e) => e.toString()).toList(),
    );
  }
}
