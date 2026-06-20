import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../utils/constants/typography.dart';
import '../../../../../../utils/gradient_switch.dart';
import '../../../../../../view_model/live_controller.dart';

class SettingsSheet extends StatefulWidget {
  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  LiveViewModel liveViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveViewModel>(
        init: liveViewModel,
        builder: (controller) {
          return SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.close, color: Colors.transparent),
                      Text(
                        'Live Settings',
                        style: sfProDisplaySemiBold.copyWith(fontSize: 24),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(thickness: 2),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Gift animation',
                        style: sfProDisplayRegular.copyWith(fontSize: 16),
                      ),
                      const Spacer(),
                      GradientCupertinoSwitch(
                        value: liveViewModel.giftAnimation.value,
                        onChanged: (value) => setState(
                            () => liveViewModel.giftAnimation.value = value),
                      ),
                      // Switch.adaptive(
                      //   value: true,
                      //   activeColor: Colors.white,
                      //   inactiveThumbColor: Colors.grey,
                      //   inactiveTrackColor: Colors.grey,
                      //   activeTrackColor: AppColors.yellowColor,
                      //   onChanged: (value) {},
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
