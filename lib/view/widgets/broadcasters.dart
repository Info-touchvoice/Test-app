import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/constants/app_constants.dart';
import '../../utils/constants/typography.dart';
import '../../view_model/broadcaster_controller.dart';
import '../../view_model/search_controller.dart';

class BroadCasters extends StatelessWidget {
  final int index;

  const BroadCasters({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BroadCastersController());
    final controller = Get.find<BroadCastersController>();
    final searchController = Get.find<SearchController>();

    return InkWell(
      onTap: () {
        controller.toggleSelection(index);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Obx(() {
        final fullName = searchController.recentPopular[index].getFullName;
        final firstTwoWords = fullName?.split(' ').take(2).join(' ');

        return Column(
          children: [
            if (searchController.recentPopular[index].getAvatar != null)
              Stack(
                children: [
                  CircleAvatar(
                    radius: 31.r,
                    backgroundImage: NetworkImage(
                        searchController.recentPopular[index].getAvatar!.url!),
                  ),
                  if (controller.isSelected(index))
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(AppImagePath.tickIcon),
                    ),
                ],
              ),
            SizedBox(
              height: ScreenUtil().setHeight(14),
            ),
            Text(
              '$firstTwoWords',
              style: sfProDisplayMedium.copyWith(fontSize: 14),
            ),
          ],
        );
      }),
    );
  }
}

class BroadCasterLoading extends StatelessWidget {
  const BroadCasterLoading();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade600,
      highlightColor: Colors.grey.shade400,
      child: Column(
        children: [
          // Circle shimmer (avatar)
          CircleAvatar(
            radius: 31.r,
          ),
          SizedBox(height: 14.h),
          // Name shimmer bar
          Container(
            width: 60.w,
            height: 14.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}
