import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:tiki/parse/PostsModel.dart';

class SavedModel extends ParseObject implements ParseCloneable {
  static final String keyTableName = "Saved";

  SavedModel() : super(keyTableName);
  SavedModel.clone() : this();

  @override
  SavedModel clone(Map<String, dynamic> map) =>
      SavedModel.clone()..fromJson(map);

  static String keyCreatedAt = "createdAt";
  static String keyObjectId = "objectId";

  static String keyAuthor = "author";
  static String keyPostId = "postId";
  static String keyPost = "post";

  String? get getAuthorId => get<String>(keyAuthor);
  set setAuthorId(String author) => set<String>(keyAuthor, author);

  PostsModel? get getPost => get<PostsModel>(keyPost);
  set setPost(PostsModel post) => set<PostsModel>(keyPost, post);

  String? get getPostId => get<String>(keyPostId);
  set setPostId(String postId) => set<String>(keyPostId, postId);
}
