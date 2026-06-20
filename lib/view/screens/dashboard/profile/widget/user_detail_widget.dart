import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/view/screens/dashboard/profile/widget/top_icons.dart';

import '../../../../../helpers/quick_help.dart';
import '../../../../../helpers/quick_actions.dart';
import '../../../../../parse/UserModel.dart';
import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/routes/app_routes.dart';
import '../../../../../utils/theme/colors_constant.dart';
import '../../../../../view_model/userViewModel.dart';

class UserDetailsWidget extends StatelessWidget {
  final UserModel? userModel;
  const UserDetailsWidget({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 88.w,
                width: 88.w,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.secondaryColor, width: 3.2),
                      ),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: QuickHelp.getUserAvatarProvider(userModel),
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
              SizedBox(
                width: 24.w,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 11.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          userModel?.getFullName ?? '',
                          style: sfProDisplayMedium.copyWith(
                              color: AppColors.primaryText(context),
                              fontSize: 16.sp),
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
                    if (userModel?.getWebsite?.isNotEmpty ?? false) ...[
                      SizedBox(
                        height: 12.h,
                      ),
                      Row(
                        children: [
                          Text(
                            userModel?.getWebsite ?? '',
                            style: sfProDisplayRegular.copyWith(
                              color: AppColors.secondaryText(context),
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Image.asset(
                            AppImagePath.linkIcon,
                          )
                        ],
                      )
                    ],
                    SizedBox(
                      height: 12.h,
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
                        SizedBox(
                          width: 22.w,
                        ),
                        if (userModel?.getHideMyLocation == false &&
                            (userModel?.getCountry?.isNotEmpty ?? false))
                          SvgPicture.asset(
                            QuickActions.getCountryFlag(userModel) ?? '',
                            height: 17.h,
                            width: 24.w,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              ProfileTopIcons(),
            ],
          ),
          SizedBox(
            height: 24.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Subscriptions
                GestureDetector(
                  onTap: () => Get.toNamed(
                    AppRoutes.userSubscriptionsList,
                    arguments: {'userModel': userModel},
                  ),
                  child: Column(
                    children: [
                      Text(
                        "${userModel?.getFollowing?.length ?? 0}",
                        style: sfProDisplayHeavy.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 18.sp,
                          color: AppColors.primaryText(context),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "Follow",
                        style: sfProDisplayRegular.copyWith(
                          fontSize: 12.sp,
                          color: AppColors.secondaryText(context),
                        ),
                      ),
                    ],
                  ),
                ),
                // Subscribers
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
                            style: sfProDisplayHeavy.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 18.sp,
                              color: AppColors.primaryText(context),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "Fans",
                        style: sfProDisplayRegular.copyWith(
                          fontSize: 12.sp,
                          color: AppColors.secondaryText(context),
                        ),
                      ),
                    ],
                  ),
                ),
                // Likes (not navigable yet)
                Column(
                  children: [
                    Text(
                      "0",
                      style: sfProDisplayHeavy.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 18.sp,
                        color: AppColors.primaryText(context),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "Visitor",
                      style: sfProDisplayRegular.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.secondaryText(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
