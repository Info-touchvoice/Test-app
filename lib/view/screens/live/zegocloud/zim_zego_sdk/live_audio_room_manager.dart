import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiki/services/room_settings_store.dart';
import 'package:tiki/view_model/live_controller.dart';
import '../../../../../main.dart';
import '../../audio_live_streaming/room_settings/audio_room_layout_helper.dart';
import 'internal/business/audioRoom/live_audio_room_seat.dart';
import 'internal/business/audioRoom/layout_config.dart';
import 'internal/business/audioRoom/room_seat_service.dart';
import 'internal/business/business_define.dart';
import 'zego_sdk_manager.dart';

class ZegoLiveAudioRoomManager {
  ZegoLiveAudioRoomManager._internal();

  static final ZegoLiveAudioRoomManager instance =
      ZegoLiveAudioRoomManager._internal();

  static const String roomKey = 'audioRoom';

  Map<String, dynamic> roomExtraInfoDict = {};
  List<StreamSubscription<dynamic>> subscriptions = [];

  ValueNotifier<bool> isLockSeat = ValueNotifier(false);
  ValueNotifier<Set<int>> lockedSeatIndices = ValueNotifier({});
  ValueNotifier<ZegoSDKUser?> hostUserNoti = ValueNotifier(null);
  ValueNotifier<ZegoLiveRole> roleNoti = ValueNotifier(ZegoLiveRole.audience);

  RoomSeatService? roomSeatService;

  ZegoLiveAudioRoomLayoutConfig? get layoutConfig {
    return roomSeatService?.layoutConfig;
  }

  int get hostSeatIndex {
    return roomSeatService?.hostSeatIndex ?? 0;
  }

  List<ZegoLiveAudioRoomSeat> get seatList {
    return roomSeatService?.seatList ?? [];
  }

  get currentUserRoleNoti => null;

  void initWithConfig(ZegoLiveAudioRoomLayoutConfig config, ZegoLiveRole role) {
    roomSeatService = RoomSeatService();
    roleNoti.value = role;
    final expressService = ZEGOSDKManager.instance.expressService;
    final zimService = ZEGOSDKManager.instance.zimService;
    subscriptions.addAll([
      expressService.roomExtraInfoUpdateCtrl.stream
          .listen(onRoomExtraInfoUpdate),
      expressService.roomUserListUpdateStreamCtrl.stream
          .listen(onRoomUserListUpdate),
      // zimService.onRoomCommandReceivedEventStreamCtrl.stream
      //     .listen(onRoomCommandReceived)
    ]);
    roomSeatService?.initWithConfig(config, role);
  }

  void unInit() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
    roomSeatService?.unInit();
  }

  bool isSeatLocked() {
    return isLockSeat.value;
  }

  bool isSeatIndexLocked(int seatIndex) {
    return lockedSeatIndices.value.contains(seatIndex);
  }

  bool get isInRoom => ZEGOSDKManager.instance.isInRoom;

  String? _parseRoomId() {
    try {
      return Get.find<LiveViewModel>().liveStreamingModel.objectId;
    } catch (_) {
      return null;
    }
  }

  Future<void> loadLocalLockedSeats() async {
    final locked = await RoomSettingsStore.loadLockedSeats(_parseRoomId());
    lockedSeatIndices.value = locked;
    if (locked.isNotEmpty) {
      roomExtraInfoDict['locked_seats'] = locked.toList();
    }
  }

  Future<ZegoRoomSetRoomExtraInfoResult> toggleSeatLock(int seatIndex) async {
    final locked = Set<int>.from(lockedSeatIndices.value);
    if (locked.contains(seatIndex)) {
      locked.remove(seatIndex);
    } else {
      locked.add(seatIndex);
    }
    lockedSeatIndices.value = Set<int>.from(locked);
    roomExtraInfoDict['locked_seats'] = locked.toList();
    await RoomSettingsStore.saveLockedSeats(_parseRoomId(), locked);

    if (!isInRoom) {
      return ZegoRoomSetRoomExtraInfoResult(0);
    }

    final dataJson = jsonEncode(roomExtraInfoDict);
    return ZEGOSDKManager.instance.expressService
        .setRoomExtraInfo(roomKey, dataJson);
  }

  Future<void> closeMicForSeat({
    required ZegoSDKUser? occupant,
    required String currentUserId,
  }) async {
    void muteLocal(ZegoSDKUser user) {
      ZEGOSDKManager.instance.expressService.turnMicrophoneOn(false);
      user.isMicOnNotifier.value = false;
    }

    if (occupant != null) {
      if (occupant.userID == currentUserId) {
        muteLocal(occupant);
      } else if (isInRoom && occupant.isMicOnNotifier.value != false) {
        await muteSpeaker(occupant.userID, true);
      }
      return;
    }

    final self = ZEGOSDKManager.instance.currentUser;
    if (self != null) {
      muteLocal(self);
      if (isInRoom) {
        await muteSpeaker(self.userID, true);
      }
    }
  }

  void _syncLockedSeatsFromExtraInfo() {
    final raw = roomExtraInfoDict['locked_seats'];
    if (raw is List) {
      lockedSeatIndices.value =
          raw.map((e) => int.tryParse(e.toString()) ?? -1).where((i) => i >= 0).toSet();
    } else {
      lockedSeatIndices.value = {};
    }
  }

  Future<ZegoRoomSetRoomExtraInfoResult> lockSeat() async {
    roomExtraInfoDict['lockseat'] = !isLockSeat.value;
    final dataJson = jsonEncode(roomExtraInfoDict);

    final result = await ZEGOSDKManager.instance.expressService
        .setRoomExtraInfo(roomKey, dataJson);
    if (result.errorCode == 0) {
      isLockSeat.value = !isLockSeat.value;
    }
    return result;
  }

  Future<ZIMRoomAttributesOperatedCallResult?> takeSeat(int seatIndex) async {
    final result = await roomSeatService?.takeSeat(seatIndex);
    if (result != null) {
      if (!result.errorKeys.contains(seatIndex.toString())) {
        for (final element in seatList) {
          if (element.seatIndex == seatIndex) {
            if (roleNoti.value != ZegoLiveRole.host) {
              roleNoti.value = ZegoLiveRole.coHost;
            }
            break;
          }
        }
      }
    }
    return result;
  }

  Future<ZIMRoomAttributesBatchOperatedResult?> switchSeat(
      int fromSeatIndex, int toSeatIndex) async {
    return roomSeatService?.switchSeat(fromSeatIndex, toSeatIndex);
  }

  Future<bool> switchSeatSafely(int fromSeatIndex, int toSeatIndex) async {
    return await roomSeatService?.switchSeatSafely(fromSeatIndex, toSeatIndex) ?? false;
  }

  Future<ZIMRoomAttributesOperatedCallResult?> leaveSeat(int seatIndex) async {
    return roomSeatService?.leaveSeat(seatIndex);
  }

  Future<ZIMRoomAttributesOperatedCallResult?> removeSpeakerFromSeat(
      String userID) async {
    return roomSeatService?.removeSpeakerFromSeat(userID);
  }

  void reconfigureAudioSeats(int totalSeatCount) {
    if (roomSeatService == null) return;
    final count = AudioRoomLayoutHelper.clampCoHostCount(totalSeatCount);
    if (roomSeatService!.seatList.length == count) return;

    final config = ZegoLiveAudioRoomLayoutConfig(
      rowConfigs: AudioRoomLayoutHelper.buildRowConfigs(count),
    );
    roomSeatService!.reconfigureLayout(config);
  }

  Future<ZIMMessageSentResult?> muteSpeaker(String userID, bool isMute) async {
    if (!isInRoom) return null;
    final messageType =
        isMute ? RoomCommandType.muteSpeaker : RoomCommandType.unMuteSpeaker;
    final commandMap = {
      'room_command_type': messageType,
      'receiver_id': userID
    };
    return ZEGOSDKManager()
        .zimService
        .sendRoomCommand(jsonEncode(commandMap));
  }

  Future<ZIMMessageSentResult?> kickOutRoom(String userID) async {
    if (!isInRoom) return null;
    final commandMap = {
      'room_command_type': RoomCommandType.kickOutRoom,
      'receiver_id': userID
    };
    return ZEGOSDKManager()
        .zimService
        .sendRoomCommand(jsonEncode(commandMap));
  }

  void leaveRoom() {
    ZEGOSDKManager.instance.logoutRoom();
    clear();
  }

  void clear() {
    roomSeatService?.clear();
    roomExtraInfoDict.clear();
    isLockSeat.value = false;
    lockedSeatIndices.value = {};
    hostUserNoti.value = null;
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
  }

  Future<ZegoRoomSetRoomExtraInfoResult?> setSelfHost() async {
    if (ZEGOSDKManager.instance.currentUser == null) {
      return null;
    }
    roomExtraInfoDict['host'] = ZEGOSDKManager.instance.currentUser!.userID;
    final dataJson = jsonEncode(roomExtraInfoDict);
    final result = await ZEGOSDKManager.instance.expressService
        .setRoomExtraInfo(roomKey, dataJson);
    if (result.errorCode == 0) {
      roleNoti.value = ZegoLiveRole.host;
    }
    else{
      print('setroomextrainfo${result.errorCode}');

    }
    return result;
  }

  Future<ZIMUserAvatarUrlUpdatedResult> updateUserAvatarUrl(String url) async {
    return ZEGOSDKManager.instance.zimService.updateUserAvatarUrl(url);
  }

  Future<ZIMUsersInfoQueriedResult> queryUsersInfo(
      List<String> userIDList) async {
    return ZEGOSDKManager.instance.zimService.queryUsersInfo(userIDList);
  }

  String? getUserAvatar(String userID) {
    return ZEGOSDKManager.instance.zimService.getUserAvatar(userID);
  }

  void onRoomExtraInfoUpdate(ZegoRoomExtraInfoEvent event) {
    for (final extraInfo in event.extraInfoList) {

      if (extraInfo.key == roomKey) {
        roomExtraInfoDict = jsonDecode(extraInfo.value);
        if (roomExtraInfoDict.containsKey('lockseat')) {
          final bool temp = roomExtraInfoDict['lockseat'];
          isLockSeat.value = temp;
        }
        if (roomExtraInfoDict.containsKey('host')) {
          final String tempUserID = roomExtraInfoDict['host'];
          hostUserNoti.value = getHostUser(tempUserID);
        }
        _syncLockedSeatsFromExtraInfo();
      }
    }
  }

  void onRoomUserListUpdate(ZegoRoomUserListUpdateEvent event) {
    if (event.updateType == ZegoUpdateType.Add) {
      final userIDList = <String>[];
      for (final element in event.userList) {
        userIDList.add(element.userID);
      }
      queryUsersInfo(userIDList);
    } else {
      // empty seat
    }
  }

  void onRoomCommandReceived(OnRoomCommandReceivedEvent event) {
    Map<String, dynamic> messageMap = jsonDecode(event.command);
    if (messageMap.keys.contains('room_command_type')) {
      final type = messageMap['room_command_type'];
      final receiverID = messageMap['receiver_id'];
      if (receiverID == ZEGOSDKManager().currentUser?.userID) {
        if (type == RoomCommandType.muteSpeaker) {
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
              const SnackBar(
                  content: Text('You have been mute speaker by the host')));
          ZEGOSDKManager().expressService.turnMicrophoneOn(false);
        } else if (type == RoomCommandType.unMuteSpeaker) {
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
              const SnackBar(
                  content: Text('You have been kick out of the room by the host')));
          ZEGOSDKManager().expressService.turnMicrophoneOn(true);
        } else if (type == RoomCommandType.kickOutRoom) {
          leaveRoom();
          Navigator.pop(navigatorKey.currentContext!);
        }
      }
    }
  }

  ZegoSDKUser? getHostUser(String userID) {
    return ZEGOSDKManager().getUser(userID);
  }
}
