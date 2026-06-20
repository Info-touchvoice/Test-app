import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiki/view_model/camera_controller.dart';
import 'package:tiki/view_model/live_controller.dart';

class CameraPreviewWidget extends StatelessWidget {
  CameraPreviewWidget();

  @override
  Widget build(BuildContext context) {
    LiveViewModel liveViewModel = Get.find();
    CameraViewModel cameraViewModel = Get.find();

    return Obx(() {
      if (liveViewModel.isCameraOn.value == true)
        return Positioned.fill(
          child: GetBuilder<CameraViewModel>(builder: (cameraViewModel) {
            return FutureBuilder<void>(
                future: cameraViewModel.initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // Fill the available space; CameraPreview will handle aspect ratio internally.
                    return CameraPreview(cameraViewModel.cameraController!);
                  } else {
                    return Container(
                      color: Colors.black,
                    );
                  }
                });
          }),
        );
      return SizedBox();
    });
  }
}
