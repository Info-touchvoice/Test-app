import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

import '../../utils/constants/typography.dart';
import '../../utils/theme/colors_constant.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isObSecure;
  final String hintText;
  final Color? txtColor;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final bool isPrefixIcon;
  final Widget? prefixIcon;
  final bool isSuffixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final double borderRadius;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final AutovalidateMode? autoValidateMode;
  final String? headingText;
  final bool enableHeadingText;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final Color? borderColor;
  final bool readOnly;
  final bool autoFocus;

  const AppTextFormField(
      {Key? key,
      required this.controller,
      this.keyboardType = TextInputType.text,
      required this.validator,
      required this.hintText,
      this.txtColor,
      this.isObSecure = false,
      this.onTap,
      this.inputFormatters,
      this.isPrefixIcon = false,
      this.prefixIcon,
      this.isSuffixIcon = false,
      this.suffixIcon,
      this.maxLines = 1,
      this.borderRadius = 8,
      this.textInputAction = TextInputAction.none,
      this.onChanged,
      this.autoValidateMode,
      this.headingText,
      this.hintStyle,
      this.enableHeadingText = false,
      this.fillColor,
      this.borderColor,
      this.readOnly = false,
      this.autoFocus = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        enableHeadingText
            ? Text(headingText ?? '',
                style: sfProDisplaySemiBold.copyWith(
                    fontSize: 14.sp, color: AppColors.textPrimaryColor))
            : const SizedBox.shrink(),
        SizedBox(
          height: ScreenUtil().setHeight(12.h),
        ),
        TextFormField(
          keyboardType: keyboardType,
          readOnly: readOnly,
          autofocus: autoFocus,
          textInputAction: textInputAction,
          controller: controller,
          cursorColor: txtColor ?? AppColors.primaryBlue,
          obscureText: isObSecure,
          maxLines: maxLines,
          onTap: onTap,
          inputFormatters: inputFormatters,
          style: sfProDisplayRegular.copyWith(
              fontSize: 14.sp, color: AppColors.textPrimaryColor),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 15.0),
            hintText: hintText,
            hintStyle: hintStyle ?? sfProDisplayRegular.copyWith(
                fontSize: 14.sp, color: AppColors.textSecondaryColor),
            filled: true,
            fillColor: fillColor ?? AppColors.textFieldFilledColor,
            prefixIcon: isPrefixIcon ? prefixIcon : null,
            suffixIcon: isSuffixIcon ? suffixIcon : null,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide:
                    BorderSide(color: borderColor ?? AppColors.borderColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: AppColors.primaryPurple)),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  borderRadius), // Adjust the radius as needed
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  borderRadius), // Adjust the radius as needed
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
          validator: validator,
          onChanged: onChanged,
          autovalidateMode: autoValidateMode,
        ),
      ],
    );
  }
}
