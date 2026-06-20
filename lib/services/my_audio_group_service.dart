import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:tiki/parse/LiveStreamingModel.dart';
import 'package:tiki/view_model/userViewModel.dart';

class MyAudioGroupService {
  static const String defaultRoomWelcome = 'Welcome to TouchVoice!';

  static Future<LiveStreamingModel?> findOwnedRoom() async {
    final uid = Get.find<UserViewModel>().currentUser.getUid;
    if (uid == null) return null;

    final query = QueryBuilder<LiveStreamingModel>(LiveStreamingModel())
      ..whereEqualTo(LiveStreamingModel.keyAuthorUid, uid)
      ..whereEqualTo(
          LiveStreamingModel.keyStreamingType, LiveStreamingModel.keyTypeAudioLive)
      ..includeObject([LiveStreamingModel.keyAuthor])
      ..orderByDescending('updatedAt')
      ..setLimit(1);

    final response = await query.query();
    if (response.success &&
        response.results != null &&
        response.results!.isNotEmpty) {
      return response.results!.first as LiveStreamingModel;
    }
    return null;
  }

  static Future<LiveStreamingModel?> findActiveRoom() async {
    final owned = await findOwnedRoom();
    if (owned != null && owned.getStreaming == true) return owned;
    return null;
  }
}
