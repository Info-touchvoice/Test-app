import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tiki/helpers/quick_help.dart';
import 'package:tiki/utils/constants/app_constants.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/theme/colors_constant.dart';

import '../../../utils/routes/app_routes.dart';
import '../../widgets/base_scaffold.dart';
import '../../widgets/custom_buttons.dart';

// Available language options and their flag assets
final List<String> languageNames = [
  "English",
  "French",
  "Arabic",
  "Turkish",
  "Russian",
  "Spanish",
  "Italian",
];

final List<String> languageImages = [
  AppImagePath.englandFlag, // English (UK)
  AppImagePath.franceFlag, // French
  AppImagePath.saudiFlag, // Arabic (generic)
  AppImagePath.Turkey, // Turkish
  AppImagePath.franceFlag, // Russian (placeholder)
  AppImagePath.Mexico, // Spanish (using Mexico flag)
  AppImagePath.Italy, // Italian
];

class LanguageScreen extends StatefulWidget {
  LanguageScreen();

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

TextEditingController searchController = TextEditingController();

class _LanguageScreenState extends State<LanguageScreen> {
  String? _selectedLanguage;

  @override
  Widget build(BuildContext context) {
    // Some routes pass non‑bool arguments (e.g. maps), so guard the cast.
    final args = Get.arguments;
    final bool settings = args is bool ? args : false;
    return BaseScaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 55.h, left: 21.w, right: 21.w),
        child: Column(
          children: [
            Image.asset(AppImagePath.languageIcon),
            SizedBox(
              height: ScreenUtil().setHeight(16.h),
            ),
            Text(
              'Language',
              style: sfProDisplaySemiBold.copyWith(
                  color: AppColors.textPrimaryColor, fontSize: 24.sp),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10.h),
            ),
            Text(
              'Select your language',
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
            ListView.builder(
              itemCount: languageNames.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 10.w),
                  horizontalTitleGap: 10,
                  leading: SvgPicture.asset(
                    languageImages[index],
                    height: 20.h,
                    width: 32.w,
                  ),
                  title: Text(languageNames[index]),
                  trailing: Radio(
                      activeColor: AppColors.primaryColor,
                      value: languageNames[index],
                      groupValue: _selectedLanguage,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedLanguage = value; // Update the selected language
                        });
                      }),
                );
              },
            ),
            Spacer(),
            PrimaryButton(
                title: "Next",
                onTap: () {
                  if (_selectedLanguage != null) {
                    if (settings == false)
                      Get.toNamed(AppRoutes.trendingBroadcastersScreen);
                    else
                      Get.back();
                  } else {
                    QuickHelp.showAppNotificationAdvanced(
                        title: 'Please select a language!', context: context);
                  }
                }),
            SizedBox(height: ScreenUtil().setHeight(24)),
          ],
        ),
      ),
    );
  }
}
