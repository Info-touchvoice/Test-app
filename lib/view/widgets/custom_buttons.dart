import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants/typography.dart';
import '../../utils/theme/colors_constant.dart';

class PrimaryButton extends StatelessWidget {
  final String? title;
  final Color? bgColor;
  Color? textColor;
  TextStyle? textStyle;
  final Color? disabledColor;
  final Color? disabledTextColor;
  Color? borderColor;
  final Function()? onTap;
  final Widget? child;
  final double width;
  final double height;
  final double borderRadius;
  final double fontSize;
  Gradient? gradient;
  final String? image;
  final double? imageSize;

  PrimaryButton({
    this.title,
    this.textStyle,
    this.bgColor,
    this.textColor,
    this.disabledColor,
    this.disabledTextColor,
    this.borderColor,
    required this.onTap,
    this.child,
    this.width = double.infinity,
    this.height = 43,
    this.borderRadius = AppColors.buttonRadius,
    this.fontSize = 20,
    this.gradient,
    this.image,
    this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    if (bgColor == AppColors.primaryColor) {
      gradient = AppColors.secondaryGradient(stops: [0.0, 1.0]);
      borderColor = null;
      textColor = AppColors.white;
      textStyle = null;
    }
    return Container(
      height: height,
      decoration: BoxDecoration(
        // ✅ Use gradient if available, otherwise solid color
        gradient:
            gradient ?? (bgColor == null ? AppColors.secondaryGradient() : null),
        color: gradient == null ? bgColor : null,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null
            ? Border.all(color: borderColor!)
            : Border.all(color: AppColors.cardBorderColor),
        boxShadow: bgColor == Colors.transparent
            ? null
            : AppColors.softShadow(
                color: AppColors.primaryPurple,
                opacity: 0.20,
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
      ),
      child: MaterialButton(
        elevation: 0,
        height: height,
        minWidth: width,
        color: Colors.transparent, // Important: transparent to show gradient/bg
        disabledColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        onPressed: onTap,
        child: child ??
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (image != null)
                  Image.asset(image!, width: imageSize, height: imageSize),
                if (image != null) SizedBox(width: 8.w),
                Text(
                  title ?? '',
                  style: textStyle ??
                      sfProDisplayBold.copyWith(
                        color: textColor ?? Colors.white,
                        fontSize: fontSize,
                      ),
                ),
              ],
            ),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String? title;
  final Color? textColor;
  final TextStyle? textStyle;
  final Color borderColor;
  final Function()? onTap;
  final Widget? child;
  final double width;
  final double height;
  final double borderRadius;
  final double fontSize;
  final String? image;
  final double imageWidth;
  final bool useTextGradient;
  final Color parentBgColor; // 👈 new parameter

  const OutlineButton({
    this.title,
    this.textStyle,
    this.textColor,
    this.borderColor = Colors.transparent,
    required this.onTap,
    this.child,
    this.width = double.infinity,
    this.height = 43,
    this.borderRadius = AppColors.buttonRadius,
    this.fontSize = 20,
    this.image,
    this.imageWidth = 20,
    this.useTextGradient = false, // 👈 default false
    this.parentBgColor = AppColors.background,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: AppColors.secondaryGradient(stops: [0.0, 1.0]),
        ),
        child: Container(
          margin: const EdgeInsets.all(1), // Border thickness
          decoration: BoxDecoration(
            color: parentBgColor,
            borderRadius: BorderRadius.circular(borderRadius - 2),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (image != null)
                  Container(
                    width: imageWidth,
                    height: imageWidth,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.secondaryGradient(stops: [0.0, 1.0])
                              .createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: ClipOval(
                        child: Image.asset(
                          image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                if (image != null) const SizedBox(width: 8),
                child ??
                    (useTextGradient
                        ? ShaderMask(
                            shaderCallback: (bounds) =>
                                AppColors.secondaryGradient(stops: [0.0, 1.0])
                                    .createShader(bounds),
                            blendMode: BlendMode.srcIn,
                            child: Text(
                              title ?? '',
                              style: textStyle ??
                                  sfProDisplayMedium.copyWith(
                                    color: Colors.white, // base color for mask
                                    fontSize: fontSize,
                                  ),
                            ),
                          )
                        : Text(
                            title ?? '',
                            style: textStyle ??
                                sfProDisplayMedium.copyWith(
                                  color:
                                      textColor ?? AppColors.textPrimaryColor,
                                  fontSize: fontSize,
                                ),
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UnderlineTextButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final Color? color;

  const UnderlineTextButton({
    this.onTap,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: sfProDisplayRegular.copyWith(
          fontSize: 14,
          decoration: TextDecoration.underline,
          decorationColor: color ?? Colors.white,
          color: color,
        ),
      ),
    );
  }
}

class PrimaryButtonIcon extends StatelessWidget {
  final String? title;
  final Color? bgColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final Color borderColor;
  final Function()? onTap;
  final Widget? child;
  final double width;
  final double height;
  final double borderRadius;
  final double fontSize;
  final String icon;

  const PrimaryButtonIcon({
    this.title,
    this.textStyle,
    this.bgColor,
    this.textColor,
    this.disabledColor,
    this.disabledTextColor,
    this.borderColor = Colors.transparent,
    required this.onTap,
    this.child,
    this.width = double.infinity,
    this.height = 48,
    this.borderRadius = AppColors.buttonRadius,
    this.fontSize = 20,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height.h,
      minWidth: width,
      color: bgColor ?? AppColors.primaryPurple,
      disabledColor: disabledColor,
      disabledTextColor: disabledTextColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: borderColor, width: 1),
      ),
      onPressed: onTap,
      child: child ??
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icon),
              SizedBox(width: 10.w),
              Text(
                title ?? '',
                style: textStyle ??
                    sfProDisplayMedium.copyWith(color: textColor, fontSize: 18),
              ),
            ],
          ),
    );
  }
}
