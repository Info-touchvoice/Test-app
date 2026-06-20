import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/theme/colors_constant.dart';
import 'package:tiki/view/widgets/custom_buttons.dart';
import 'package:tiki/view_model/live_controller.dart';

class LiveBottomCard extends StatelessWidget {
  final LiveViewModel liveViewModel;

  LiveBottomCard(this.liveViewModel);

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset > 0 ? 0 : 10),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: PrimaryButton(
                    title: 'Start Audio Room',
                    gradient: AppColors.secondaryGradient(stops: [0.0, 1.0]),
                    borderRadius: 35,
                    onTap: () {
                      Get.find<LiveViewModel>().createLive(context);
                    },
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Audio Room',
              style: sfProDisplayMedium.copyWith(
                fontSize: 16.sp,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
