import 'internal/sdk/express/express_service.dart';
import 'internal/sdk/zim/zim_service.dart';

export 'internal/sdk/express/express_service.dart';
export 'internal/sdk/zim/zim_service.dart';

class ZEGOSDKManager {
  ZEGOSDKManager._internal();
  factory ZEGOSDKManager() => instance;
  static final ZEGOSDKManager instance = ZEGOSDKManager._internal();

  ExpressService expressService = ExpressService.instance;
  ZIMService zimService = ZIMService.instance;

  Future<void> init(int appID, String? appSign, {ZegoScenario scenario = ZegoScenario.Default}) async {
    await expressService.init(appID: appID, appSign: appSign, scenario: scenario);
    await zimService.init(appID: appID, appSign: appSign);
  }

  Future<void> connectUser(String userID, String userName, {String? token}) async {
    await expressService.connectUser(userID, userName, token: token);
    await zimService.connectUser(userID, userName, token: token);
  }

  Future<void> disconnectUser() async {
    await logoutRoom();
    await expressService.disconnectUser();
    await zimService.disconnectUser();
  }

  Future<void> uploadLog() async {
    await Future.wait([
      expressService.uploadLog(),
      zimService.uploadLog(),
    ]);
    return;
  }

  bool get isInRoom =>
      expressService.currentRoomID.isNotEmpty &&
      zimService.currentRoomID != null &&
      zimService.currentRoomID!.isNotEmpty;

  Future<ZegoRoomLoginResult> loginRoom(String roomID, ZegoScenario scenario, {String? token}) async {
    if (roomID.isEmpty) {
      return ZegoRoomLoginResult(-1, {'errorMessage': 'Room ID is empty'});
    }

    if (isInRoom &&
        expressService.currentRoomID == roomID &&
        zimService.currentRoomID == roomID) {
      return ZegoRoomLoginResult(0, {});
    }

    if (expressService.currentRoomID.isNotEmpty ||
        (zimService.currentRoomID?.isNotEmpty ?? false)) {
      await logoutRoom();
    }

    if (expressService.currentScenario != scenario) {
      try {
        await expressService.setRoomScenario(scenario);
      } catch (error) {
        print("zegoroomScenario$error");
      }
    }

    final expressResult = await expressService.loginRoom(roomID, token: token);
    if (expressResult.errorCode != 0) {
      print("expressResult${expressResult.errorCode}");
      return expressResult;
    }

    final zimResult = await zimService.loginRoom(roomID);
    if (zimResult.errorCode != 0) {
      print("zimResult${zimResult.errorCode}");
      await expressService.logoutRoom();
    }
    return zimResult;
  }

  Future<void> logoutRoom() async {
    await expressService.logoutRoom();
    await zimService.logoutRoom();
  }

  ZegoSDKUser? get currentUser => expressService.currentUser;
  ZegoSDKUser? getUser(String userID) {
    for (final user in expressService.userInfoList) {
      if (userID == user.userID) {
        return user;
      }
    }
    return null;
  }
}
