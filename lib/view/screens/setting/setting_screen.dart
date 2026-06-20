import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tiki/helpers/quick_actions.dart';
import 'package:tiki/utils/routes/app_routes.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';

import '../../../helpers/quick_help.dart';
import '../../../utils/dialogs/confirm_dialog.dart';
import '../../../utils/theme/colors_constant.dart';
import '../../../view_model/userViewModel.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late bool _isToggled;

  @override
  void initState() {
    if (Get.isDarkMode == true)
      _isToggled = true;
    else {
      _isToggled = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        body: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                    ),
                  ),
                  Text(
                    "Settings",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(),
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Account and Security",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w400),
                      ),
                      Spacer(),
                      Text(
                        "Unsafe",
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.red),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.accountAndSecurity);
                          },
                          child: Icon(Icons.arrow_forward_ios))
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Divider(color: Color(0xff494848)),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Text(
                        "Privacy",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w400),
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.privacySettingScreen);
                          },
                          child: Icon(Icons.arrow_forward_ios))
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 16.h,
          color: Color(0xff494848),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  QuickActions.showAlertDialog(
                      context,
                      "Are you sure you want to clear cache?",
                      () => clearCache().then((value) => Get.back()));
                },
                child: Row(
                  children: [
                    Text(
                      "Clear Cache",
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w400),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Divider(color: Color(0xff494848)),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Text(
                    "About Us",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                  ),
                  Spacer(),
                  Text(
                    "1.1.1",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryColor),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          width: double.infinity,
          height: 16.h,
          color: Color(0xff494848),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "App Update",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                  ),
                  Spacer(),
                  Text(
                    "1.0.0",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryColor),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Divider(color: Color(0xff494848)),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Text(
                    "Logout",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                  ),
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ConfirmDialog(
                              title: 'Do you really want to log out?',
                              onConfirm: () {
                                QuickHelp.showLoadingDialog(context);
                                Get.find<UserViewModel>()
                                    .currentUser
                                    .logout(deleteLocalUserData: true)
                                    .then((value) {
                                  QuickHelp.hideLoadingDialog(context);
                                  clearCache();

                                  Get.offAllNamed(
                                    AppRoutes.onBoarding,
                                  );
                                }).onError(
                                  (error, stackTrace) {
                                    QuickHelp.hideLoadingDialog(context);
                                  },
                                );
                              },
                              onCancel: () {
                                Get.back();
                              },
                            );
                          },
                        );
                      },
                      child: Icon(Icons.arrow_forward_ios))
                ],
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Future<void> clearCache() async {
    try {
      Directory cacheDir = await getTemporaryDirectory();
      cacheDir.deleteSync(recursive: true);
      print('Cache cleared successfully.');
    } catch (e) {
      print('Failed to clear cache: $e');
    }
  }
}
