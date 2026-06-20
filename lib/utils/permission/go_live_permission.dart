import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Trans;
import 'package:permission_handler/permission_handler.dart';
import 'package:tiki/utils/routes/app_routes.dart';
import 'package:tiki/view_model/audio_home_view_model.dart';
import 'package:tiki/view_model/userViewModel.dart';

import '../../data/app/setup.dart';
import '../../helpers/quick_help.dart';
import '../../parse/LiveStreamingModel.dart';
import '../../parse/UserModel.dart';
import '../../services/group_history_service.dart';
import '../../view/screens/location_screen.dart';

class LivePermissionHandler {
  static Future<void> checkPermission(
      String? streamingType, BuildContext context,
      {LiveStreamingModel? liveStreamingModel}) async {
    if (QuickHelp.isAndroidPlatform() || QuickHelp.isIOSPlatform()) {
      final PermissionStatus micStatus = await Permission.microphone.status;
      _checkMicStatus(micStatus, context, liveStreamingModel: liveStreamingModel);
    } else {
      _gotoLiveScreen(context, liveStreamingModel: liveStreamingModel);
    }
  }

  static void _checkMicStatus(
      PermissionStatus micStatus, BuildContext context,
      {LiveStreamingModel? liveStreamingModel}) {
    if (micStatus.isDenied) {
      QuickHelp.showDialogPermission(
          context: context,
          title: "permissions.photo_access".tr(),
          confirmButtonText: "permissions.okay_".tr().toUpperCase(),
          message: "permissions.photo_access_explain"
              .tr(namedArgs: {"app_name": Setup.appName}),
          onPressed: () async {
            QuickHelp.hideLoadingDialog(context);
            final PermissionStatus status =
                await Permission.microphone.request();
            if (status.isGranted) {
              _gotoLiveScreen(context, liveStreamingModel: liveStreamingModel);
            }
          });
    } else if (micStatus.isPermanentlyDenied) {
      QuickHelp.showDialogPermission(
          context: context,
          title: "permissions.photo_access_denied".tr(),
          confirmButtonText: "permissions.okay_settings".tr().toUpperCase(),
          message: "permissions.photo_access_denied_explain"
              .tr(namedArgs: {"app_name": Setup.appName}),
          onPressed: () {
            QuickHelp.hideLoadingDialog(context);
            openAppSettings();
          });
    } else if (micStatus.isGranted) {
      _gotoLiveScreen(context, liveStreamingModel: liveStreamingModel);
    }
  }

  static _gotoLiveScreen(BuildContext context,
      {LiveStreamingModel? liveStreamingModel}) async {
    if (Get.find<UserViewModel>().currentUser.getGeoPoint == null) {
      QuickHelp.showDialogLivEend(
        context: context,
        dismiss: true,
        title: 'live_streaming.location_needed'.tr(),
        confirmButtonText: 'live_streaming.add_location'.tr(),
        message: 'live_streaming.location_needed_explain'.tr(),
        onPressed: () async {
          QuickHelp.goBackToPreviousPage(context);
          UserModel? user = await QuickHelp.goToNavigatorScreenForResult(
              context,
              LocationScreen(
                currentUser: Get.find<UserViewModel>().currentUser,
              ));
          if (user != null) {
            Get.find<UserViewModel>().currentUser = user;
          }
        },
      );
      return;
    }

    if (liveStreamingModel == null) {
      return;
    }

    if (liveStreamingModel.getStreamingType !=
        LiveStreamingModel.keyTypeAudioLive) {
      QuickHelp.showAppNotificationAdvanced(
        context: context,
        title: 'Audio rooms only',
        message: 'This room type is no longer supported.',
      );
      return;
    }

    GroupHistoryService.recordVisit(liveStreamingModel);

    Get.toNamed(AppRoutes.audienceAudioLive, arguments: liveStreamingModel)
        ?.then((value) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
      if (Get.isRegistered<AudioHomeViewModel>()) {
        final audioHome = Get.find<AudioHomeViewModel>();
        audioHome.loadRecentGroups();
        audioHome.loadJoinedGroups();
      }
    });
  }
}
