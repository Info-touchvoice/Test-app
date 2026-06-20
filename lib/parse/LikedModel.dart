import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:tiki/parse/PostsModel.dart';

class LikedModel extends ParseObject implements ParseCloneable {
  static final String keyTableName = "Likes";

  LikedModel() : super(keyTableName);
  LikedModel.clone() : this();

  @override
  LikedModel clone(Map<String, dynamic> map) =>
      LikedModel.clone()..fromJson(map);

  static String keyCreatedAt = "createdAt";
  static String keyObjectId = "objectId";

  static String keyAuthorId = "authorId";
  static String keyPost = "post";

  String? get getAuthor => get<String>(keyAuthorId);
  set setAuthor(String author) => set<String>(keyAuthorId, author);

  PostsModel? get getPost => get<PostsModel>(keyPost);
  set setPost(PostsModel post) => set<PostsModel>(keyPost, post);
}
