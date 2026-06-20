import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../utils/constants/app_constants.dart';
import '../../../../../../utils/theme/colors_constant.dart';
import '../../../../../../view_model/camera_controller.dart';
import '../../../../../../view_model/live_controller.dart';
import '../../widgets/camera_off_widget.dart';

class TwelvePerson extends StatelessWidget {
  const TwelvePerson({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LiveViewModel liveViewModel = Get.find();
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColors.black.withOpacity(0.2),
                          border: Border(
                              bottom: BorderSide(
                                  color: AppColors.divider, width: 0))),
                      child: Obx(() {
                        if (liveViewModel.isCameraOn.value)
                          return GetBuilder<CameraViewModel>(
                              builder: (cameraViewModel) {
                            return FutureBuilder<void>(
                                future:
                                    cameraViewModel.initializeControllerFuture,
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
                            radius: 16,
                          );
                      }),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.2),
                        border: Border(
                          left: BorderSide(color: AppColors.divider, width: 0),
                          bottom:
                              BorderSide(color: AppColors.divider, width: 0),
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImagePath.sofaFilled,
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.2),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImagePath.sofaFilled,
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                  ),
                ],
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
                        border: Border(
                          left: BorderSide(color: AppColors.divider, width: 0),
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImagePath.sofaFilled,
                          height: 30,
                          width: 30.w,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.2),
                        border: Border(
                          bottom:
                              BorderSide(color: AppColors.divider, width: 0),
                          top: BorderSide(color: AppColors.divider, width: 0),
                          left: BorderSide(color: AppColors.divider, width: 0),
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImagePath.sofaFilled,
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.2),
                        border: Border(
                          left: BorderSide(color: AppColors.divider, width: 0),
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImagePath.sofaFilled,
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                  ),
                ],
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
                        border: Border(
                          left: BorderSide(color: AppColors.divider, width: 0),
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImagePath.sofaFilled,
                          height: 30,
                          width: 30.w,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.2),
                        border: Border(
                          bottom:
                              BorderSide(color: AppColors.divider, width: 0),
                          top: BorderSide(color: AppColors.divider, width: 0),
                          left: BorderSide(color: AppColors.divider, width: 0),
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImagePath.sofaFilled,
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.2),
                        border: Border(
                          left: BorderSide(color: AppColors.divider, width: 0),
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImagePath.sofaFilled,
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                  ),
                ],
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
                        border: Border(
                          left: BorderSide(color: AppColors.divider, width: 0),
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImagePath.sofaFilled,
                          height: 30,
                          width: 30.w,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.2),
                        border: Border(
                          bottom:
                              BorderSide(color: AppColors.divider, width: 0),
                          top: BorderSide(color: AppColors.divider, width: 0),
                          left: BorderSide(color: AppColors.divider, width: 0),
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImagePath.sofaFilled,
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.2),
                        border: Border(
                          left: BorderSide(color: AppColors.divider, width: 0),
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImagePath.sofaFilled,
                          height: 25,
                          width: 25,
                        ),
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
