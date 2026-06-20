import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/view/screens/dashboard/verified_member/widgets/verificaiton_congragulation_widget.dart';
import 'package:tiki/view/screens/dashboard/verified_member/widgets/verificaiton_subscription_widget.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';

import '../../../../utils/constants/typography.dart';
import '../../../../utils/theme/colors_constant.dart';
import '../../../../view_model/userViewModel.dart';

class VerifiedMemberScreen extends StatelessWidget {
  const VerifiedMemberScreen();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Verified Member',
            style: sfProDisplayMedium.copyWith(
                fontSize: 16.sp,
                color: Get.isDarkMode ? AppColors.white : AppColors.black),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios,
                  color: Get.isDarkMode ? AppColors.white : AppColors.black)),
        ),
        body: Column(children: [
          Container(
            color: Color(0xff494848),
            height: 16.h,
            width: double.infinity,
          ),
          SizedBox(
            height: 24.h,
          ),
          GetBuilder<UserViewModel>(builder: (userViewModel) {
            if (userViewModel.currentUser.isVerified == true)
              return VerificationCongratulationsWidget();
            else
              return VerificationSubscriptionWidget();
          }),
        ]));
  }
}
