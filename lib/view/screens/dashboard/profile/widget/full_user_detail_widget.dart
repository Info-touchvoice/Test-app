import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../helpers/quick_help.dart';
import '../../../../../helpers/quick_actions.dart';
import '../../../../../parse/UserModel.dart';
import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/routes/app_routes.dart';
import '../../../../../utils/theme/colors_constant.dart';
import '../../../../../view_model/userViewModel.dart';

class FullUserDetailsWidget extends StatelessWidget {
  final UserModel? userModel;
  const FullUserDetailsWidget({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryText = AppColors.primaryText(context);
    final Color secondaryText = AppColors.secondaryText(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 90.w,
              width: 90.w,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(3), // border thickness
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.secondaryGradient(stops: [
                        0.0,
                        1.0
                      ]), // your gradient function or custom gradient
                    ),
                    child: CircleAvatar(
                      radius: 80, // main avatar radius
                      backgroundColor:
                          Colors.transparent, // transparent background
                      backgroundImage:
                          QuickHelp.getUserAvatarProvider(userModel),
                    ),
                  ),
                  if (userModel?.userIsLive ?? false)
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          AppImagePath.icLive,
                          height: 15.h,
                          fit: BoxFit.fill,
                        ))
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 24.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userModel?.getFullName ?? '',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: primaryText,
              ),
            ),
            if (userModel?.isVerified ?? false) ...[
              SizedBox(
                width: 10.w,
              ),
              Image.asset(
                AppImagePath.icVerified,
              ),
            ]
          ],
        ),
        SizedBox(
          height: 24.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 13.h,
              decoration: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Lv.",
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "${userModel?.getLevel ?? 1}",
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (userModel?.getHideMyLocation == false &&
                (userModel?.getCountry?.isNotEmpty ?? false)) ...[
              SizedBox(
                width: 22.w,
              ),
              SvgPicture.asset(
                QuickActions.getCountryFlag(userModel),
                height: 17.h,
                width: 24.w,
              ),
            ],
            if (userModel?.og ?? false) ...[
              SizedBox(
                width: 22.w,
              ),
              Image.asset(AppImagePath.icOg)
            ]
          ],
        ),
        SizedBox(
          height: 24.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(
                AppRoutes.userSubscriptionsList,
                arguments: {'userModel': userModel},
              ),
              child: Column(
                children: [
                  Text(
                    "${userModel?.getFollowing?.length ?? 0}",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18.sp,
                      color: primaryText,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "Follow",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 35.h,
              width: 1,
              decoration: BoxDecoration(
                gradient: AppColors.secondaryGradient(stops: [0, 1]),
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(
                AppRoutes.userSubscribersList,
                arguments: {'userModel': userModel},
              ),
              child: Column(
                children: [
                  FutureBuilder<int>(
                    future: Get.find<UserViewModel>()
                        .getFollowersCountForUser(userModel?.objectId),
                    builder: (context, snapshot) {
                      final int count = snapshot.data ?? 0;
                      return Text(
                        "$count",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18.sp,
                          color: primaryText,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "Fans",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 35.h,
              width: 1,
              decoration: BoxDecoration(
                gradient: AppColors.secondaryGradient(stops: [0, 1]),
              ),
            ),
            Column(
              children: [
                Text(
                  "0",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18.sp,
                    color: primaryText,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "Visitor",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
