import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../../parse/MusicModel.dart';
import '../../../../../parse/PostsModel.dart';
import '../../../../../parse/UserModel.dart';
import '../../feed/videoutils/video.dart';

class AudioViewModel extends GetxController {
  late MusicModel? musicModel;

  final AudioPlayer player = AudioPlayer();

  var isPlaying = false.obs;
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;

  AudioViewModel(this.musicModel);

  @override
  void onInit() {
    super.onInit();
    _initAudio();
  }

  void _initAudio() async {
    await player.setUrl(musicModel!.getAudioFile!.url!);

    player.durationStream.listen((d) {
      if (d != null) duration.value = d;
    });

    player.positionStream.listen((p) {
      position.value = p;
    });

    player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });

    // Listen for completion
    player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        isPlaying.value = false;
        position.value = Duration.zero;
        player.seek(Duration.zero);
        player.pause(); // just to be safe
      }
    });
  }

  void playPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  void seekTo(double milliseconds) {
    player.seek(Duration(milliseconds: milliseconds.toInt()));
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Future<List<VideoInfo>> fetchReels(
      UserModel currentUser, PostsModel? postModel) async {
    List<VideoInfo> reels = [];

    QueryBuilder<UserModel> bannedUsersQuery =
        QueryBuilder(UserModel.forQuery());
    bannedUsersQuery.whereValueExists(UserModel.keyUserStatus, true);
    bannedUsersQuery.whereEqualTo(UserModel.keyUserStatus, true);

    QueryBuilder<PostsModel> queryBuilder =
        QueryBuilder<PostsModel>(PostsModel());
    queryBuilder.whereValueExists(PostsModel.keyVideo, true);
    queryBuilder.whereNotEqualTo(PostsModel.keyObjectId, postModel!.objectId!);
    queryBuilder.whereEqualTo(PostsModel.keySelectedMusic, musicModel!);
    queryBuilder.orderByDescending(PostsModel.keyCreatedAt);
    queryBuilder.whereNotContainedIn(
        PostsModel.keyAuthor, currentUser.getBlockedUsers!);
    queryBuilder.whereDoesNotMatchQuery(PostsModel.keyAuthor, bannedUsersQuery);

    queryBuilder.includeObject([
      PostsModel.keyAuthor,
      PostsModel.keyAuthorName,
      PostsModel.keyLastLikeAuthor,
      PostsModel.keyLastDiamondAuthor,
      PostsModel.keySelectedMusic
    ]);

    ParseResponse apiResponse = await queryBuilder.query();
    if (apiResponse.success && apiResponse.results != null) {
      for (PostsModel postsModel in apiResponse.results!) {
        final videoUrl = postsModel.getVideo?.url;
        if (videoUrl == null) continue;

        VideoInfo videoInfo = VideoInfo(
          postModel: postsModel,
          currentUser: currentUser,
          url: videoUrl,
        );

        reels.add(videoInfo);
      }
    }

    return reels;
  }
}
