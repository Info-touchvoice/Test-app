import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/typography.dart';
import '../../../../../utils/theme/colors_constant.dart';
import '../../../../../view_model/nearby_controller.dart';

class CategoryTabs extends StatefulWidget {
  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  // IMPORTANT: Do NOT create a new instance here. HomeView already registers
  // HomeLiveViewModel. Creating another instance causes tab clicks/toggles to
  // update a different controller and can make the UI look "unresponsive"
  // until a navigation rebuild happens.
  final HomeLiveViewModel homeLiveViewModel = Get.find<HomeLiveViewModel>();

  List<String> subCategories = ["Nearby", "Popular"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        items(0),
        SizedBox(width: 16.w),
        items(1),
      ],
    ));
  }

  Widget items(int index) {
    return Obx(() {
      bool isSelected =
          homeLiveViewModel.isNearbySelected.value == (index == 0);
      return GestureDetector(
        onTap: () {
          homeLiveViewModel.switchToggle(
            index == 0,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              subCategories[index],
              style: sfProDisplayMedium.copyWith(
                fontSize: 16.sp,
                color: isSelected
                    ? AppColors.white // Selected color for dark theme
                    : AppColors.white50, // Unselected color for both themes
              ),
            ),
            SizedBox(height: 6.h),
            isSelected
                ? Container(
                    height: 2,
                    width: 10.w,
                    color: Color(0xffEA773F),
                  )
                : const SizedBox(),
          ],
        ),
      );
    });
  }
}
