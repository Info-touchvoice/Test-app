import 'package:get/get.dart';
import 'package:tiki/services/room_action_records_store.dart';
import 'package:tiki/view/screens/live/zegocloud/zim_zego_sdk/internal/sdk/basic/zego_sdk_user.dart';
import 'package:tiki/view_model/live_controller.dart';
import 'package:tiki/view_model/userViewModel.dart';

class RoomActionRecordsLogger {
  static Future<void> logKickOutMic(ZegoSDKUser target) async {
    await _log(RoomActionRecordType.kickOutMic, target);
  }

  static Future<void> logKickOutRoom(ZegoSDKUser target) async {
    await _log(RoomActionRecordType.kickOutRoom, target);
  }

  static Future<void> _log(
    RoomActionRecordType type,
    ZegoSDKUser target,
  ) async {
    if (!Get.isRegistered<LiveViewModel>()) return;
    final live = Get.find<LiveViewModel>().liveStreamingModel;
    final roomId = live.objectId;
    if (roomId == null || roomId.isEmpty) return;

    final actor = Get.find<UserViewModel>().currentUser;
    final actorName = actor.getFullName ?? actor.getUsername ?? 'Host';
    final actorAvatar = actor.getAvatar?.url;

    await RoomActionRecordsStore.log(
      roomId: roomId,
      type: type,
      targetUserId: target.userID,
      targetUserName: target.userName ?? 'User',
      targetAvatarUrl: target.avatarUrlNotifier.value,
      actorUserId: actor.getUid.toString(),
      actorUserName: actorName,
      actorAvatarUrl: actorAvatar,
    );
  }
}
