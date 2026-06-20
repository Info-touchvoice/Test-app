import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../utils/routes/app_routes.dart';
import '../../../../../utils/theme/colors_constant.dart';
import '../../../../../view_model/userViewModel.dart';

class ProfileTopIcons extends StatelessWidget {
  const ProfileTopIcons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color iconColor = AppColors.primaryText(context);
    final Color circleBg = Theme.of(context).brightness == Brightness.light
        ? AppColors.white100
        : AppColors.white20;
    final Color circleBorder = Theme.of(context).brightness == Brightness.light
        ? AppColors.strokeWhite
        : AppColors.white10;
    final Color actionBg = Theme.of(context).brightness == Brightness.light
        ? AppColors.buttonWhite
        : const Color(0xff494848);

    return GetBuilder<UserViewModel>(builder: (userViewModel) {
      if (userViewModel.showFullDetailView == false) {
        return GestureDetector(
          onTap: () => userViewModel.showFullDetailView = true,
          child: Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleBg,
              border: Border.all(color: circleBorder),
            ),
            child: Center(
              child: Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: iconColor,
              ),
            ),
          ),
        );
      }

      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => userViewModel.showFullDetailView = false,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: actionBg,
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: iconColor,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.settingScreen,
                      arguments: {"otherProfile": false}),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: actionBg,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.settings_rounded,
                        size: 20,
                        color: const Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.75.w,
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.notificationScreen,
                      arguments: {"otherProfile": false}),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: actionBg,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.notifications_rounded,
                        size: 20,
                        color: iconColor,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ]);
    });
  }
}
