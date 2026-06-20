import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/constants/typography.dart';
import '../../../../../utils/theme/colors_constant.dart';
import '../../../../../view_model/userViewModel.dart';
import '../../../../widgets/custom_buttons.dart';

class VerificationCongratulationsWidget extends StatelessWidget {
  const VerificationCongratulationsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 16.w, right: 16.w),
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 60.38.h,
      ),
      decoration: BoxDecoration(
          color: AppColors.navBarColor,
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          border: Border.all(color: Colors.white.withOpacity(0.07))),
      child: Column(
        children: [
          Column(
            children: [
              Image.asset(AppImagePath.verifiedSuccess),
              SizedBox(height: 24.h),
              Text(
                "Congratulations!",
                style: sfProDisplayBold.copyWith(
                    fontSize: 20.sp, color: AppColors.white),
              )
            ],
          ),
          SizedBox(height: 24.h),
          Divider(color: Colors.white.withOpacity(0.20)),
          SizedBox(height: 24.h),
          Text(
              "You've successfully completed your payment! Your profile is now verified and your verification badge is active for others to see on your profile.",
              textAlign: TextAlign.center,
              style: sfProDisplayRegular.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.white.withOpacity(0.7),
              )),
          SizedBox(height: 24.h),
          Divider(color: Colors.white.withOpacity(0.20)),
          SizedBox(height: 24.h),
          PrimaryButton(
            height: 44.h,
            borderRadius: 50.r,
            textStyle: sfProDisplayMedium.copyWith(
                fontSize: 16, color: AppColors.white),
            bgColor: AppColors.primaryColor,
            onTap: () {
              Get.back();
            },
            child: Text(
              "Continue to Profile",
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
          SizedBox(height: 12.h),
          GetBuilder<UserViewModel>(builder: (userViewModel) {
            DateTime? verifiedAt =
                userViewModel.currentUser.verificationExpiredDate;
            return Text(
                "The membership will expire on ${formatReadableDate(verifiedAt?.toLocal())}.",
                textAlign: TextAlign.center,
                style: sfProDisplayRegular.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ));
          }),
        ],
      ),
    );
  }

  String formatReadableDate(DateTime? date) {
    if (date == null) return "N/A";

    final months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    final month = months[date.month - 1];
    final day = date.day;
    final year = date.year;

    return "$month $day, $year";
  }
}
