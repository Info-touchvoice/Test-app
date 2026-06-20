import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/view_model/userViewModel.dart';

import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/constants/typography.dart';
import '../../../../../utils/theme/colors_constant.dart';
import '../../../../widgets/custom_buttons.dart';

class VerificationSubscriptionWidget extends StatelessWidget {
  const VerificationSubscriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Get.find<UserViewModel>();
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 16.w, right: 16.w),
      padding: EdgeInsets.symmetric(vertical: 27.h, horizontal: 24.w),
      decoration: BoxDecoration(
          color: AppColors.navBarColor,
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          border: Border.all(color: Colors.white.withOpacity(0.07))),
      child: Column(
        children: [
          Column(
            children: [
              Image.asset(AppImagePath.verifiedBadge),
              SizedBox(height: 24.h),
              Text(
                "Get Your Verified Badge",
                style: sfProDisplayBold.copyWith(
                    fontSize: 16.sp, color: AppColors.white),
              )
            ],
          ),
          SizedBox(height: 24.h),
          Divider(color: Colors.white.withOpacity(0.20)),
          SizedBox(height: 24.h),
          Column(
            children: [
              Row(
                children: [
                  Image.asset(AppImagePath.checkList),
                  SizedBox(width: 8.w),
                  Text(
                    "Verified Badge on your profile",
                    style: sfProDisplayRegular.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Image.asset(AppImagePath.checkList),
                  SizedBox(width: 8.w),
                  Text(
                    "Get discovered more easily",
                    style: sfProDisplayRegular.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Image.asset(AppImagePath.checkList),
                  SizedBox(width: 8.w),
                  Text(
                    "Tiki Priority Support",
                    style: sfProDisplayRegular.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Divider(color: Colors.white.withOpacity(0.20)),
          SizedBox(height: 24.h),
          Text(
              "Tiki Verified is a premium subscription for top-tier creators and brands. It confirms your profile is authentic and helps you build trust and credibility with your audience.",
              textAlign: TextAlign.center,
              style: sfProDisplayRegular.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.white.withOpacity(0.7),
              )),
          SizedBox(height: 24.h),
          PrimaryButton(
            height: 44.h,
            borderRadius: 50.r,
            textStyle: sfProDisplayMedium.copyWith(
                fontSize: 16, color: AppColors.white),
            bgColor: AppColors.primaryColor,
            onTap: () {
              userViewModel.verifyUser();
            },
            child: Text(
              "Subscribe for \$50",
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
