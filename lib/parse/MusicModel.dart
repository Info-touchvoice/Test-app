import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

// Audio audioModelFromJson(String str) =>
//     Audio.fromJson(json.decode(str));
//
// String musicModelToJson(Audio data) => json.encode(data.toJson());

class Audio {
  final String audioName;
  final String? singerName;
  final String audioURL;
  final String thumbnailURL;

  Audio({
    required this.audioName,
    required this.audioURL,
    this.singerName,
    required this.thumbnailURL,
  });

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      audioName: json['audioName'],
      audioURL: json['audioURL'],
      singerName: json['singerName'],
      thumbnailURL: json['thumbnailURL'],
    );
  }
}

class MusicModel extends ParseObject implements ParseCloneable {
  // NOTE: In Back4App this app stores songs in the "Song" class (not "Music").
  // We keep the class name MusicModel to minimize refactors across the app,
  // but it now maps to the Parse class "Song".
  static final String keyTableName = "Song";

  MusicModel() : super(keyTableName);
  MusicModel.clone() : this();

  @override
  MusicModel clone(Map<String, dynamic> map) =>
      MusicModel.clone()..fromJson(map);

  static String keyCreatedAt = "createdAt";
  static String keyObjectId = "objectId";

  // Back4App schema (Song):
  // - songLink: File
  // - songTitle: String
  // - singerName: String
  // - songImage: File
  // - songTime: String
  static String keyAudioFile = "songLink";
  static String keyAudioName = "songTitle";
  static String keySingerName = "singerName";
  static String keyThumbnail = "songImage";
  static String keyTime = "songTime";

  String? get getAudioName => get<String>(keyAudioName);
  set setAAudioName(String audioName) => set<String>(keyAudioName, audioName);

  ParseFileBase? get getAudioFile => get<ParseFileBase>(keyAudioFile);
  set setText(ParseFileBase audioFile) =>
      set<ParseFileBase>(keyAudioFile, audioFile);

  ParseFileBase? get getThumbnail => get<ParseFileBase>(keyThumbnail);
  set setThumbnail(ParseFileBase thumbnail) =>
      set<ParseFileBase>(keyThumbnail, thumbnail);

  String? get getSingerName => get<String>(keySingerName);
  set setSingerName(String name) => set<String>(keySingerName, name);

  String? get getTime => get<String>(keyTime);
  set setTime(String time) => set<String>(keyTime, time);
}
