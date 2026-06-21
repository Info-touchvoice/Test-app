import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../view/widgets/custom_buttons.dart';
import '../constants/typography.dart';
import '../theme/colors_constant.dart'; // if you're using GetX
// import your AppColors, fonts, and PrimaryButton files

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmBgColor;
  final Color? cancelBgColor;
  final Color? confirmTextColor;
  final Color? cancelTextColor;
  final Color? borderColor;
  final bool forLive;

  const ConfirmDialog({
    required this.title,
    required this.onConfirm,
    this.onCancel,
    this.confirmText = 'Yes',
    this.cancelText = 'No',
    this.confirmBgColor,
    this.cancelBgColor,
    this.confirmTextColor,
    this.cancelTextColor,
    this.borderColor,
    this.forLive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.cardRadius),
        side: BorderSide(color: AppColors.borderColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: sfProDisplayRegular.copyWith(
              fontSize: 16.sp,
              color: AppColors.textPrimaryColor,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              if (forLive)
                Expanded(
                  child: OutlineButton(
                    title: cancelText,
                    width: 140.w,
                    useTextGradient: true,
                    parentBgColor: AppColors.cardBackground,
                    borderRadius: 35,
                    textStyle: sfProDisplaySemiBold.copyWith(
                      fontSize: 20.sp,
                      color: cancelTextColor ?? AppColors.white80,
                    ),
                    borderColor: AppColors.textSecondaryColor,
                    onTap: onCancel ??
                        () {
                          Navigator.pop(context);
                        },
                  ),
                )
              else
                Expanded(
                  child: PrimaryButton(
                    title: cancelText,
                    height: 40,
                    width: 140.w,
                    borderRadius: 35,
                    textStyle: sfProDisplaySemiBold.copyWith(
                      fontSize: 20.sp,
                      color: cancelTextColor ?? AppColors.white80,
                    ),
                    bgColor: Colors.transparent,
                    borderColor: AppColors.textSecondaryColor,
                    onTap: onCancel ??
                        () {
                          Navigator.pop(context);
                        },
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: PrimaryButton(
                  title: confirmText,
                  height: 40,
                  width: 140.w,
                  borderRadius: 35,
                  textStyle: sfProDisplaySemiBold.copyWith(
                    fontSize: 20.sp,
                    color: AppColors.textPrimaryColor,
                  ),
                  gradient: forLive
                      ? AppColors.secondaryGradient(stops: const [0.0, 1.0])
                      : null,
                    bgColor: forLive ? null : AppColors.error,
                  onTap: onConfirm,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
