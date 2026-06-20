import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_setting_constants.dart';

class HiloRoomOptionPickerSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selected;

  const HiloRoomOptionPickerSheet({
    Key? key,
    required this.title,
    required this.options,
    required this.selected,
  }) : super(key: key);

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String selected,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: HiloRoomSettingColors.bodyBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => HiloRoomOptionPickerSheet(
        title: title,
        options: options,
        selected: selected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16.h),
          Text(
            title,
            style: sfProDisplayMedium.copyWith(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12.h),
          ...options.map((option) {
            final isSelected = option == selected;
            return InkWell(
              onTap: () => Navigator.pop(context, option),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? HiloRoomSettingColors.customBar.withOpacity(0.25)
                      : Colors.transparent,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option,
                        style: sfProDisplayRegular.copyWith(
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check, color: Colors.white, size: 18.sp),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
