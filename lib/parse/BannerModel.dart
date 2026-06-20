import 'package:parse_server_sdk/parse_server_sdk.dart';

class BannerModel extends ParseObject implements ParseCloneable {
  static final String keyTableName = "Banner";

  BannerModel() : super(keyTableName);
  BannerModel.clone() : this();

  @override
  BannerModel clone(Map<String, dynamic> map) => BannerModel.clone()..fromJson(map);

  static String keyCreatedAt = "createdAt";
  static String keyObjectId = "objectId";

  static String keyImage = "image";
  static String keyIsActive = "isActive";

  ParseFileBase? get getImage => get<ParseFileBase>(keyImage);
  set setImage(ParseFileBase file) => set<ParseFileBase>(keyImage, file);

  bool get isActive => get<bool>(keyIsActive) ?? false;
  set setIsActive(bool v) => set<bool>(keyIsActive, v);
}

