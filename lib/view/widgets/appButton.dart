import 'package:flutter/material.dart';

import '../../utils/constants/typography.dart';
import '../../utils/theme/colors_constant.dart';

Widget appButton(BuildContext context, String btnText, Function()? onTap,
    {Color? textColor, Color? backgroundColor}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        gradient: backgroundColor == null ? AppColors.secondaryGradient() : null,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppColors.buttonRadius),
        boxShadow: AppColors.softShadow(
          color: AppColors.primaryPurple,
          opacity: 0.20,
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(btnText,
            style: sfProDisplaySemiBold.copyWith(
                fontSize: 16, color: textColor ?? AppColors.textPrimaryColor)),
      )),
    ),
  );
}
