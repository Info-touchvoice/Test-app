import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiki/view/screens/live/streamer_live_preview/widgets/camera_off_widget.dart';
import 'package:tiki/view_model/live_controller.dart';

import '../../../../../../utils/constants/app_constants.dart';
import '../../../../../../utils/theme/colors_constant.dart';
import '../../../../../../view_model/camera_controller.dart';

class ThreePerson extends StatelessWidget {
  const ThreePerson({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LiveViewModel liveViewModel = Get.find();
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.2),
                    border: Border(
                        right: BorderSide(color: AppColors.divider, width: 0))),
                child: Obx(() {
                  if (liveViewModel.isCameraOn.value)
                    return GetBuilder<CameraViewModel>(
                        builder: (cameraViewModel) {
                      return FutureBuilder<void>(
                          future: cameraViewModel.initializeControllerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return CameraPreview(
                                  cameraViewModel.cameraController!);
                            } else {
                              return Container(
                                color: Colors.black,
                              );
                            }
                          });
                    });
                  else
                    return CameraOffPreviewWidget(
                      radius: 34,
                    );
                }),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.2),
                      ),
                      child: Image.asset(
                        AppImagePath.bitCoinSofa,
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                  Divider(color: AppColors.divider, height: 0),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.2),
                      ),
                      child: Image.asset(
                        AppImagePath.bitCoinSofa,
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
