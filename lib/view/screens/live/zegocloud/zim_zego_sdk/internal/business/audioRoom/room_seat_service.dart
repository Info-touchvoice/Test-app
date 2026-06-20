
import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../../../../view_model/zego_controller.dart';
import '../../../live_audio_room_manager.dart';
import '../../../zego_sdk_manager.dart';
import '../business_define.dart';
import 'layout_config.dart';
import 'live_audio_room_seat.dart';

class RoomSeatService {

  int hostSeatIndex = 0;
  List<ZegoLiveAudioRoomSeat> seatList = [];
  bool isBatchOperation = false;

  List<StreamSubscription<dynamic>> subscriptions = [];

  ZegoLiveAudioRoomLayoutConfig? layoutConfig;

  void initWithConfig(ZegoLiveAudioRoomLayoutConfig config, ZegoLiveRole role) {
    layoutConfig = config;
    final expressService = ZEGOSDKManager.instance.expressService;
    final zimService = ZEGOSDKManager.instance.zimService;
    subscriptions.addAll([
      expressService.roomUserListUpdateStreamCtrl.stream.listen(onRoomUserListUpdate),
      zimService.roomAttributeUpdateStreamCtrl.stream.listen(onRoomAttributeUpdate),
      zimService.roomAttributeBatchUpdatedStreamCtrl.stream.listen(onRoomAttributeBatchUpdate)
    ]);
    initSeat(config);
  }

  void initSeat(ZegoLiveAudioRoomLayoutConfig config) {
    for (var columIndex = 0; columIndex < config.rowConfigs.length; columIndex++) {
      final rowConfig = config.rowConfigs[columIndex];
      for (var rowIndex = 0; rowIndex < rowConfig.count; rowIndex++) {
        final seat = ZegoLiveAudioRoomSeat(seatList.length, rowIndex, columIndex);
        seatList.add(seat);
      }
    }
  }

  Future<ZIMRoomAttributesOperatedCallResult?> takeSeat(int seatIndex) async {
    final attributes = {seatIndex.toString(): ZEGOSDKManager.instance.currentUser?.userID ?? ''};
    final result = await ZEGOSDKManager.instance.zimService.setRoomAttributes(
      attributes,
      isForce: false,
      isUpdateOwner: true,
      isDeleteAfterOwnerLeft: true,
    );
    if (result != null) {
      if (!result.errorKeys.contains(seatIndex.toString())) {
        for (final element in seatList) {
          if (element.seatIndex == seatIndex) {
            element.currentUser.value = ZEGOSDKManager.instance.currentUser;
            break;
          }
        }
      }
    }
    return result;
  }

  Future<ZIMRoomAttributesBatchOperatedResult?> switchSeat(int fromSeatIndex, int toSeatIndex) async {
    if (isBatchOperation) return null;
    if (fromSeatIndex == toSeatIndex) return null;

    isBatchOperation = true;
    final zimService = ZEGOSDKManager.instance.zimService;
    final userID = ZEGOSDKManager.instance.currentUser?.userID ?? '';

    zimService.beginRoomAttributesBatchOperation(
      isForce: false,
      isUpdateOwner: true,
      isDeleteAfterOwnerLeft: true,
    );

    // These calls are included in the batch; the final commit happens at endRoomPropertiesBatchOperation().
    await zimService.setRoomAttributes(
      {toSeatIndex.toString(): userID},
      isForce: false,
      isUpdateOwner: true,
      isDeleteAfterOwnerLeft: true,
    );
    await zimService.deleteRoomAttributes([fromSeatIndex.toString()]);

    final result = await zimService.endRoomPropertiesBatchOperation();
    isBatchOperation = false;
    return result;
  }

  /// Conflict-safe seat switch:
  /// - Only leaves [fromSeatIndex] after successfully claiming [toSeatIndex]
  /// - Best-effort rollback if leaving the old seat fails (to avoid occupying 2 seats)
  Future<bool> switchSeatSafely(int fromSeatIndex, int toSeatIndex) async {
    if (isBatchOperation) return false;
    if (fromSeatIndex == toSeatIndex) return true;

    isBatchOperation = true;
    try {
      final zimService = ZEGOSDKManager.instance.zimService;
      final userID = ZEGOSDKManager.instance.currentUser?.userID ?? '';
      if (userID.isEmpty) return false;

      // 1) Try to claim the destination seat (fails if already taken).
      final takeResult = await zimService.setRoomAttributes(
        {toSeatIndex.toString(): userID},
        isForce: false,
        isUpdateOwner: true,
        isDeleteAfterOwnerLeft: true,
      );
      if (takeResult == null || takeResult.errorKeys.contains(toSeatIndex.toString())) {
        return false;
      }

      // 2) Now release the old seat.
      final leaveResult = await zimService.deleteRoomAttributes([fromSeatIndex.toString()]);
      if (leaveResult == null || leaveResult.errorKeys.contains(fromSeatIndex.toString())) {
        // Rollback: avoid occupying 2 seats.
        await zimService.deleteRoomAttributes([toSeatIndex.toString()]);
        return false;
      }

      // Local optimistic update (remote update events will also reconcile).
      for (final element in seatList) {
        if (element.seatIndex == fromSeatIndex) {
          element.currentUser.value = null;
        } else if (element.seatIndex == toSeatIndex) {
          element.currentUser.value = ZEGOSDKManager.instance.currentUser;
        }
      }

      return true;
    } finally {
      isBatchOperation = false;
    }
  }

  Future<ZIMRoomAttributesOperatedCallResult?> leaveSeat(int seatIndex) async {
    final result = await ZEGOSDKManager.instance.zimService.deleteRoomAttributes([seatIndex.toString()]);
    if (result != null) {
      if (!result.errorKeys.contains(seatIndex.toString())) {
        for (final element in seatList) {
          if (element.seatIndex == seatIndex) {
            element.currentUser.value = null;
          }
        }
      }
    }
    return result;
  }

  Future<ZIMRoomAttributesOperatedCallResult?> removeSpeakerFromSeat(String userID) async {
    for (final seat in seatList) {
      if (seat.currentUser.value?.userID == userID) {
        final result = await leaveSeat(seat.seatIndex);
        return result;
      }
    }
    return null;
  }

  void unInit() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
  }

  void clear() {
    seatList.clear();
    isBatchOperation = false;
    unInit();
  }

  /// Rebuild seat grid when co-host count changes without leaving the room.
  void reconfigureLayout(ZegoLiveAudioRoomLayoutConfig config) {
    final attributeMap = Map<String, String>.from(
      ZEGOSDKManager.instance.zimService.roomAttributesMap,
    );

    seatList.clear();
    layoutConfig = config;
    initSeat(config);

    attributeMap.forEach((key, userId) {
      for (final element in seatList) {
        if (element.seatIndex.toString() == key) {
          element.currentUser.value = ZEGOSDKManager.instance.getUser(userId);
          break;
        }
      }
    });

    if (Get.isRegistered<ZegoController>()) {
      Get.find<ZegoController>().update();
    }
  }

  int get totalSeatCount => seatList.length;


  void onRoomUserListUpdate(ZegoRoomUserListUpdateEvent event) {
    if (event.updateType == ZegoUpdateType.Add) {
      final userIDList = <String>[];
      for (final element in event.userList) {
        userIDList.add(element.userID);
        ZEGOSDKManager.instance.zimService.roomAttributesMap.forEach((key, value) {
          if (element.userID == value) {
            for (final seat in seatList) {
              if (seat.seatIndex.toString() == key) {
                seat.currentUser.value = ZEGOSDKManager.instance.getUser(value);
                Get.find<ZegoController>().update();
                break;
              }
            }
          }
        });
      }
    } else {
      // empty seat
    }
  }

  void onRoomAttributeBatchUpdate(ZIMServiceRoomAttributeBatchUpdatedEvent event) {
    event.updateInfos.forEach(_onRoomAttributeUpdate);
  }

  void onRoomAttributeUpdate(ZIMServiceRoomAttributeUpdateEvent event) {
    _onRoomAttributeUpdate(event.updateInfo);
  }

  void _onRoomAttributeUpdate(ZIMRoomAttributesUpdateInfo updateInfo) {
    if (updateInfo.action == ZIMRoomAttributesUpdateAction.set) {
      updateInfo.roomAttributes.forEach((key, value) {
        for (final element in seatList) {
          if (element.seatIndex.toString() == key) {
            if (value == ZEGOSDKManager.instance.currentUser?.userID) {
              element.currentUser.value = ZEGOSDKManager.instance.currentUser;
            } else {
              element.currentUser.value = ZEGOSDKManager.instance.getUser(value);
            }
          }
        }
      });
    } else {
      updateInfo.roomAttributes.forEach((key, value) {
        for (final element in seatList) {
          if (element.seatIndex.toString() == key) {
            element.currentUser.value = null;
            updateCurrentUserRole();
          }
        }
      });
    }
  }

  void updateCurrentUserRole() {
    var isFindSelf = false;
    for (final seat in seatList) {
      if (seat.currentUser.value != null && seat.currentUser.value?.userID == ZEGOSDKManager().currentUser?.userID) {
        isFindSelf = true;
        break;
      }
    }
    final liveAudioRoomManager = ZegoLiveAudioRoomManager.instance;
    if (isFindSelf) {
      if (liveAudioRoomManager.roleNoti.value != ZegoLiveRole.host) {
        liveAudioRoomManager.roleNoti.value = ZegoLiveRole.coHost;
      }
    } else {
      liveAudioRoomManager.roleNoti.value = ZegoLiveRole.audience;
      ZEGOSDKManager().expressService.stopPublishingStream();
    }
    
  }
  
}