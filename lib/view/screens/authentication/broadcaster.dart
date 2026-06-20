import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/routes/app_routes.dart';
import 'package:tiki/utils/theme/colors_constant.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';
import 'package:tiki/view/widgets/broadcasters.dart';
import 'package:tiki/view/widgets/custom_buttons.dart';

import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/status.dart';
import '../../../view_model/search_controller.dart';

class TrendingBroadcastersScreen extends StatelessWidget {
  const TrendingBroadcastersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchController searchController = Get.put(SearchController());
    return BaseScaffold(
        body: Padding(
      padding:
          EdgeInsets.only(top: 42.h, bottom: 24.h, left: 21.w, right: 21.w),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Image.asset(AppImagePath.trendingIcon),
                SizedBox(
                  height: ScreenUtil().setHeight(16.h),
                ),
                Text(
                  'Trending Streamer',
                  style: sfProDisplaySemiBold.copyWith(
                      color: AppColors.textPrimaryColor, fontSize: 24.sp),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10.h),
                ),
                Text(
                  'Select your streamer',
                  style: sfProDisplayRegular.copyWith(
                      color: AppColors.textSecondaryColor, fontSize: 16.sp),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(32.h),
                ),
                Image.asset(AppImagePath.progressIndicator),
                SizedBox(
                  height: ScreenUtil().setHeight(28.h),
                ),
                Expanded(
                  child: GetBuilder<SearchController>(
                      init: searchController,
                      builder: (controller) {
                        if (searchController.getStatus == Status.Loading) {
                          return LoadingView();
                        }
                        return GridView.builder(
                          itemCount: searchController.recentPopular.length,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, childAspectRatio: 0.9),
                          itemBuilder: (BuildContext context, int index) {
                            return BroadCasters(
                              index: index,
                            );
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
          PrimaryButton(
            title: "Done",
            onTap: () => Get.toNamed(AppRoutes.dashboardScreen),
          ),
        ],
      ),
    ));
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 9,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 0.9),
      itemBuilder: (BuildContext context, int index) {
        return BroadCasterLoading();
      },
    );
  }
}
