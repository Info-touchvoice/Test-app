import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:tiki/parse/SavedModel.dart';
import 'package:tiki/view_model/userViewModel.dart';

import '../parse/LikedModel.dart';
import '../parse/PostsModel.dart';
import '../parse/UserModel.dart';
import '../utils/constants/status.dart';
import '../view/screens/reels/feed/videoutils/api.dart';
import '../view/screens/reels/feed/videoutils/video.dart';

class CommunityController<V extends VideoInfo> extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxInt currentPage = 0.obs;
  List<VideoInfo> videosList = [];
  List<VideoInfo> followerVideosList = [];
  late QueryBuilder<PostsModel> queryBuilder;
  late final VideoNewFeedApi<V> api;
  Status status = Status.Loading;
  Status allReelsStatus = Status.Loading;
  Status likedReelsStatus = Status.Loading;
  Status savedReelsStatus = Status.Loading;
  LiveQuery liveQuery = LiveQuery();
  Subscription? subscription;

  List<VideoInfo> userReels = [];
  List<VideoInfo> likedReels = [];
  List<VideoInfo> savedReels = [];

  bool showFollowingReels = false;

  int allReelsIndex = 0;
  int likeReelsIndex = 2;
  int savedReelsIndex = 1;

  int selectedIndex = 0;

  set selectIndex(int value) {
    selectedIndex = value;
    update();
  }

  set selectReelsTypeFollowing(bool value) {
    showFollowingReels = value;
    update();
  }

  bool get isReelTypeFollowing => showFollowingReels;

  Future<FileInfo?> checkedCacheFor(String url) async {
    final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
    return value;
  }

  Future cachedForUrl(String url) async {
    await DefaultCacheManager().getSingleFile(url).then((value) {
      return value;
    });
  }

  Future<void> getListVideo({bool? exclusive}) async {
    loadFeedsVideo(
      Get.find<UserViewModel>().currentUser,
    );
  }

  Future<void> loadFeedsVideo(UserModel currentUser,
      {bool updateBuild = true}) async {
    status = Status.Loading;

    // Fetch both feeds in parallel to reduce initial loading time.
    final results = await Future.wait<List<VideoInfo>>([
      fetchPublicVideos(currentUser),
      fetchFollowerVideos(currentUser),
    ]);
    final publicVideos = results[0];
    final followerVideos = results[1];

    videosList = publicVideos;
    followerVideosList = followerVideos;

    status = Status.Completed;
    update();
  }

  Future<List<VideoInfo>> fetchPublicVideos(UserModel currentUser) async {
    List<VideoInfo> publicVideos = [];

    QueryBuilder<UserModel> bannedUsersQuery =
        QueryBuilder(UserModel.forQuery());
    bannedUsersQuery.whereValueExists(UserModel.keyUserStatus, true);
    bannedUsersQuery.whereEqualTo(UserModel.keyUserStatus, true);

    QueryBuilder<PostsModel> queryBuilder =
        QueryBuilder<PostsModel>(PostsModel());
    queryBuilder.whereValueExists(PostsModel.keyVideo, true);
    queryBuilder.orderByDescending(PostsModel.keyCreatedAt);
    queryBuilder.whereNotContainedIn(
        PostsModel.keyAuthor, currentUser.getBlockedUsers!);
    queryBuilder.whereDoesNotMatchQuery(PostsModel.keyAuthor, bannedUsersQuery);

    // Only include essential relations for faster initial load
    queryBuilder.includeObject([
      PostsModel.keyAuthor,
    ]);

    // Smaller initial limit for faster first-frame display
    queryBuilder.setLimit(15);

    ParseResponse apiResponse = await queryBuilder.query();
    if (apiResponse.success && apiResponse.results != null) {
      // Build VideoInfo list immediately WITHOUT blocking on cache checks.
      // Cache prefetching will happen in background when user scrolls.
      for (PostsModel postsModel in apiResponse.results!) {
        final videoUrl = postsModel.getVideo?.url;
        if (videoUrl == null) continue;
        
        VideoInfo videoInfo = VideoInfo(
          postModel: postsModel,
          currentUser: currentUser,
          url: videoUrl,
          file: null, // Don't block on cache; video player handles caching internally
        );

        publicVideos.add(videoInfo);
      }
    }

    return publicVideos;
  }

  Future<List<VideoInfo>> fetchFollowerVideos(UserModel currentUser) async {
    List<VideoInfo> followerVideos = [];

    if (currentUser.getFollowing == null || currentUser.getFollowing!.isEmpty) {
      return followerVideos;
    }

    QueryBuilder<PostsModel> queryBuilder =
        QueryBuilder<PostsModel>(PostsModel());
    queryBuilder.whereValueExists(PostsModel.keyVideo, true);
    queryBuilder.orderByDescending(PostsModel.keyCreatedAt);
    queryBuilder.whereContainedIn(
        PostsModel.keyAuthor, currentUser.getFollowing!);
    queryBuilder.whereNotContainedIn(
        PostsModel.keyAuthor, currentUser.getBlockedUsers!);

    // Only include essential relations for faster initial load
    queryBuilder.includeObject([
      PostsModel.keyAuthor,
    ]);

    // Smaller initial limit for faster first-frame display
    queryBuilder.setLimit(15);

    ParseResponse apiResponse = await queryBuilder.query();
    if (apiResponse.success && apiResponse.results != null) {
      // Build VideoInfo list immediately WITHOUT blocking on cache checks.
      for (PostsModel postsModel in apiResponse.results!) {
        final videoUrl = postsModel.getVideo?.url;
        if (videoUrl == null) continue;
        
        VideoInfo videoInfo = VideoInfo(
          postModel: postsModel,
          currentUser: currentUser,
          url: videoUrl,
          file: null,
        );

        followerVideos.add(videoInfo);
      }
    }

    return followerVideos;
  }

  Future<List<VideoInfo>> fetchUserReels(UserModel user, bool? isExclusive,
      {bool? isVideo, int? skip = 0, bool updateBuild = true}) async {
    List<VideoInfo> videos = [];

    QueryBuilder<PostsModel> queryBuilder =
        QueryBuilder<PostsModel>(PostsModel());

    queryBuilder.whereValueExists(PostsModel.keyVideo, true);

    queryBuilder.orderByDescending(PostsModel.keyCreatedAt);

    queryBuilder.whereEqualTo(PostsModel.keyAuthorId, user.objectId);

    queryBuilder.includeObject([
      PostsModel.keyAuthor,
      PostsModel.keyAuthorName,
      PostsModel.keyLastLikeAuthor,
      PostsModel.keyLastDiamondAuthor
    ]);

    ParseResponse apiResponse = await queryBuilder.query();
    if (apiResponse.success) {
      if (apiResponse.results != null) {
        for (PostsModel postsModel in apiResponse.results!) {
          VideoInfo videoInfo = VideoInfo(
            postModel: postsModel,
            currentUser: Get.find<UserViewModel>().currentUser,
            url: postsModel.getVideo!.url,
          );
          videos.add(videoInfo);
        }

        return videos;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<void> fetchCurrentUserAllReels(UserModel user) async {
    List<VideoInfo> videos = [];

    QueryBuilder<PostsModel> queryBuilder =
        QueryBuilder<PostsModel>(PostsModel());

    queryBuilder.whereValueExists(PostsModel.keyVideo, true);

    queryBuilder.orderByDescending(PostsModel.keyCreatedAt);

    queryBuilder.whereEqualTo(PostsModel.keyAuthorId, user.objectId);

    queryBuilder.includeObject([
      PostsModel.keyAuthor,
      PostsModel.keyAuthorName,
      PostsModel.keyLastLikeAuthor,
      PostsModel.keyLastDiamondAuthor
    ]);

    ParseResponse apiResponse = await queryBuilder.query();
    if (apiResponse.success) {
      if (apiResponse.results != null) {
        for (PostsModel postsModel in apiResponse.results!) {
          VideoInfo videoInfo = VideoInfo(
            postModel: postsModel,
            currentUser: Get.find<UserViewModel>().currentUser,
            url: postsModel.getVideo!.url,
          );
          videos.add(videoInfo);
        }

        allReelsStatus = Status.Completed;
        userReels = videos;
        update();
      } else {
        allReelsStatus = Status.Completed;
        userReels = [];
        update();
      }
    } else {
      allReelsStatus = Status.Error;
      update();
    }
  }

  Future<void> fetchLikedReels(UserModel user) async {
    List<VideoInfo> videos = [];

    QueryBuilder<LikedModel> queryBuilder =
        QueryBuilder<LikedModel>(LikedModel());

    queryBuilder.whereEqualTo(LikedModel.keyAuthorId, user.objectId);

    queryBuilder.includeObject([
      LikedModel.keyPost,
    ]);

    ParseResponse apiResponse = await queryBuilder.query();
    if (apiResponse.success) {
      if (apiResponse.results != null) {
        for (LikedModel likedModel in apiResponse.results!) {
          VideoInfo videoInfo = VideoInfo(
            postModel: likedModel.getPost,
            currentUser: Get.find<UserViewModel>().currentUser,
            url: likedModel.getPost!.getVideo!.url,
          );
          videos.add(videoInfo);
        }

        likedReelsStatus = Status.Completed;
        likedReels = videos;
        update();
      } else {
        likedReelsStatus = Status.Completed;
        likedReels = [];
        update();
      }
    } else {
      likedReelsStatus = Status.Error;
      update();
    }
  }

  Future<void> fetchSavedReels(UserModel user) async {
    List<VideoInfo> videos = [];

    QueryBuilder<SavedModel> queryBuilder =
        QueryBuilder<SavedModel>(SavedModel());

    queryBuilder.whereEqualTo(SavedModel.keyAuthor, user.objectId);

    queryBuilder.includeObject([
      SavedModel.keyPost,
    ]);

    ParseResponse apiResponse = await queryBuilder.query();
    if (apiResponse.success) {
      if (apiResponse.results != null) {
        for (SavedModel savedModel in apiResponse.results!) {
          VideoInfo videoInfo = VideoInfo(
            postModel: savedModel.getPost,
            currentUser: Get.find<UserViewModel>().currentUser,
            url: savedModel.getPost!.getVideo!.url,
          );
          videos.add(videoInfo);
        }

        savedReelsStatus = Status.Completed;
        savedReels = videos;
        update();
      } else {
        savedReelsStatus = Status.Completed;
        savedReels = [];
        update();
      }
    } else {
      savedReelsStatus = Status.Error;
      update();
    }
  }

  bool isPostSaved(String postId) {
    return savedReels.any((video) =>
        video.postModel != null && video.postModel!.objectId == postId);
  }

  Future<void> toggleSavedStatusAndUpdateList({
    required String postId,
    required String authorId,
    required PostsModel post,
  }) async {
    bool alreadySaved = isPostSaved(postId);

    if (alreadySaved) {
      // Delete from Parse
      final query = QueryBuilder<SavedModel>(SavedModel())
        ..whereEqualTo(SavedModel.keyAuthor, authorId)
        ..whereEqualTo(SavedModel.keyPostId, postId);

      final response = await query.query();
      if (response.success &&
          response.results != null &&
          response.results!.isNotEmpty) {
        final savedObject = response.results!.first as SavedModel;
        final deleteResponse = await savedObject.delete();

        if (deleteResponse.success) {
          // Remove from savedReelsList
          savedReels.removeWhere((video) =>
              video.postModel != null && video.postModel!.objectId == postId);
          update();
        }
      }
    } else {
      // Save to Parse
      final savedObject = SavedModel()
        ..setAuthorId = authorId
        ..setPostId = postId
        ..setPost = post;

      final saveResponse = await savedObject.save();

      if (saveResponse.success) {
        // Add to savedReelsList
        VideoInfo videoInfo = VideoInfo(
          postModel: post,
          currentUser: Get.find<UserViewModel>().currentUser,
          url: post.getVideo?.url,
        );
        savedReels.add(videoInfo);
        update();
      }
    }
  }

  @override
  Future<void> onInit() async {
    getListVideo();
    super.onInit();
  }
}
