import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/parse/UserModel.dart';
import 'package:tiki/utils/constants/app_constants.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/theme/colors_constant.dart';
import 'package:tiki/view/screens/live/single_live_streaming/single_audience_live/widgets/audience_list_sheet.dart';
import 'package:tiki/view_model/live_controller.dart';

class AudioViewersStrip extends StatelessWidget {
  const AudioViewersStrip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final liveViewModel = Get.find<LiveViewModel>();

    return GetBuilder<LiveViewModel>(builder: (_) {
      final total = liveViewModel.liveStreamingModel.getViewersId?.length ?? 0;
      final viewers = liveViewModel.viewerList.take(20).toList();
      final extra = total > 20 ? total - 20 : 0;

      if (total <= 0) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: GestureDetector(
          onTap: () => showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            isScrollControlled: true,
            backgroundColor: AppColors.grey500,
            builder: (context) => Wrap(
              children: [
                AudienceListSheet(),
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                height: 34.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: AppColors.divider.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AppImagePath.icViews,
                      width: 14.w,
                      height: 14.w,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      total.toString(),
                      style: sfProDisplayMedium.copyWith(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: viewers.isEmpty
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'No viewers',
                                style: sfProDisplayRegular.copyWith(
                                  color: Colors.white70,
                                  fontSize: 11.sp,
                                ),
                              ),
                            )
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: viewers.length + (extra > 0 ? 1 : 0),
                              separatorBuilder: (_, __) => SizedBox(width: 6.w),
                              itemBuilder: (context, index) {
                                if (index >= viewers.length) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                    child: Text(
                                      '+$extra',
                                      style: sfProDisplayMedium.copyWith(
                                        color: Colors.white,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  );
                                }

                                final user = viewers[index];
                                final avatarUrl = user is UserModel
                                    ? user.getAvatar?.url
                                    : null;

                                return CircleAvatar(
                                  radius: 12.r,
                                  backgroundColor: Colors.black26,
                                  backgroundImage:
                                      (avatarUrl != null && avatarUrl.isNotEmpty)
                                          ? NetworkImage(avatarUrl)
                                          : null,
                                  child: (avatarUrl == null || avatarUrl.isEmpty)
                                      ? Icon(Icons.person,
                                          size: 14.sp, color: Colors.white70)
                                      : null,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}


