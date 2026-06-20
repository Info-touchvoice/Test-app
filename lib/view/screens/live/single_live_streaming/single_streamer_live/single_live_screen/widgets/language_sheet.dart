import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/theme/colors_constant.dart';
import 'package:tiki/view/widgets/custom_buttons.dart';

import '../../../../../../../view_model/live_controller.dart';

class LanguageSheet extends StatefulWidget {
  const LanguageSheet();

  @override
  State<LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<LanguageSheet> {
  List<String> languages = [
    'English',
    'عربى',
    'हिन्दी',
    'Русский язык',
    'اُردُو'
  ];
  final LiveViewModel liveViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    RxString language = liveViewModel.selectedLanguage.value.obs;
    return Container(
      height: 520,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: AppColors.cardBg,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30),
              Text(
                'Language',
                style: sfProDisplaySemiBold.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 12),
              ...List.generate(
                languages.length,
                (index) => GestureDetector(
                  onTap: () => language.value = languages[index],
                  child: Column(
                    children: [
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 16),
                      Text(
                        languages[index],
                        style: sfProDisplaySemiBold.copyWith(
                            fontSize: 16,
                            color: language.value == languages[index]
                                ? AppColors.yellowColor
                                : Colors.white),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                title: 'Confirm',
                borderRadius: 35,
                onTap: () {
                  liveViewModel.selectedLanguage.value = language.value;
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
            ],
          );
        }),
      ),
    );
  }
}
