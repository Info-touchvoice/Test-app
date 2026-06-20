import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiki/helpers/quick_help.dart';
import 'package:tiki/view/screens/live/zegocloud/zim_zego_sdk/internal/business/business_define.dart';
import 'package:tiki/view_model/live_controller.dart';
import 'package:tiki/view_model/zego_controller.dart';

import '../../../../../../utils/constants/typography.dart';
import '../../../../../../utils/theme/colors_constant.dart';

class ScreenRecordingSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LiveViewModel liveViewModel = Get.find();

    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.close, color: Colors.transparent),
                Text(
                  'Screen Recording',
                  style: sfProDisplaySemiBold.copyWith(fontSize: 24),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 2),
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (liveViewModel
                              .liveStreamingModel.getDisableScreenShot ??
                          false == true)
                        QuickHelp.showAppNotificationAdvanced(
                            title: 'Screenshot is disabled by streamer.',
                            context: context);
                      else {
                        if (Get.find<ZegoController>().role ==
                            ZegoLiveRole.host) {
                          Get.back();
                          Get.find<ZegoController>()
                              .onSnapshotButtonClickedHost(context);
                        } else {
                          Get.back();
                          Get.find<ZegoController>()
                              .onSnapshotButtonClickedAudience(context);
                        }
                      }
                    },
                    child: Row(
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.crop, size: 35),
                            const SizedBox(height: 11),
                            Text(
                              'Screenshot',
                              style: sfProDisplayRegular.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (liveViewModel.liveStreamingModel.getDisableRecord ??
                          false == true)
                        QuickHelp.showAppNotificationAdvanced(
                            title: 'Recording is disabled by streamer.',
                            context: context);
                      else {
                        // recordingController.startRecord(fileName: "fazan", width: 50, height: 100);
                        // recordingController.stopRecord();
                        Get.find<ZegoController>().startLiveStreamRecording(
                            Get.find<ZegoController>().appDocumentsPath);
                      }
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient:
                                AppColors.secondaryGradient(stops: [0, 1]),
                          ),
                          child: Center(
                            child: Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.grey500,
                              ),
                              child: Center(
                                child: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppColors.secondaryGradient(
                                          stops: [0, 1]),
                                    )),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 80),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'click to start 5 to 60 second screen recording!',
                // " ${recordingController.response!.success.toString()}",
                style: sfProDisplayRegular.copyWith(
                    fontSize: 12, color: AppColors.white.withOpacity(0.7)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
