import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/view/screens/home/explore.dart';

import '../../../../../model/popular_card_model.dart';
import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/constants/typography.dart';
import '../../../../../utils/theme/colors_constant.dart';
import '../../../../../view_model/audio_home_view_model.dart';

class CardWidgets extends StatelessWidget {
  const CardWidgets({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            GetBuilder<AudioHomeViewModel>(builder: (audio) {
              List<PopularModel> modelList = audio.audioLiveModelList;
              List<String> avatars = modelList.map((e) => e.avatar).toList();
              return _buildCard(
                title: 'Audio Rooms',
                image: AppImagePath.audioHomeImage,
                fillColor: AppColors.oceanBlue,
                strokeColor: AppColors.soundWaveBlue,
                onTap: () {},
                avatars: avatars,
              );
            }),
            SizedBox(width: 13.w),
            _buildCard(
              title: 'Explore',
              image: AppImagePath.exploreHomeImage,
              fillColor: AppColors.emeraldGreen,
              strokeColor: AppColors.explorerGreen,
              onTap: () => Get.to(() => Explore()),
              avatars: [],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String image,
    required Color fillColor,
    required Color strokeColor,
    required Function() onTap,
    required List<String> avatars,
  }) {
    int displayCount = avatars.length > 3 ? 3 : avatars.length;
    int remainingCount = avatars.length > 3 ? avatars.length - 3 : 0;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 155.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.r)),
          border: Border.all(color: strokeColor, width: 2),
          color: fillColor,
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 46.w,
                        height: 17.h,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: List.generate(displayCount, (index) {
                            return Positioned(
                              left: (index * 21).w,
                              child: _buildAvatar(image: avatars[index]),
                            );
                          }),
                        ),
                      ),
                      SizedBox(width: (displayCount * 21).w + 10.w),
                      if (remainingCount > 0)
                        Text(
                          '+$remainingCount',
                          style: sfProDisplayRegular.copyWith(
                            color: AppColors.black,
                            fontSize: 12.sp,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    title,
                    style: sfProDisplayMedium.copyWith(
                      color: AppColors.black,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar({required String image}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: 1),
      ),
      child: CircleAvatar(
        radius: 12.r,
        backgroundImage: NetworkImage(image),
      ),
    );
  }
}
