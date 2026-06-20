import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/theme/colors_constant.dart';
import 'package:tiki/view/widgets/custom_buttons.dart';

import '../../../../../../../ui/gradient_text_widget.dart';

class BattleTimeSheet extends StatelessWidget {
  BattleTimeSheet({required this.time});

  RxInt time;

  RxBool quit = false.obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.grey400,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Obx(() {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      time.value = 3;
                      quit.value = false;
                    },
                    child: GradientText(
                      text: '3 min',
                      useGradient: time.value == 3 && quit.value == false,
                      style: sfProDisplaySemiBold.copyWith(
                          fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      time.value = 5;
                      quit.value = false;
                    },
                    child: GradientText(
                      text: '5 min',
                      useGradient: time.value == 5 && quit.value == false,
                      style: sfProDisplaySemiBold.copyWith(
                          fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      quit.value = true;
                    },
                    child: GradientText(
                      text: 'Quite Games 500 coins',
                      useGradient: quit.value == true,
                      style: sfProDisplaySemiBold.copyWith(
                          fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            title: 'Confirm',
            borderRadius: 35,
            height: 48,
            textStyle:
                sfProDisplayBold.copyWith(fontSize: 16, color: AppColors.black),
            bgColor: AppColors.yellowBtnColor,
            onTap: () {
              if (quit.value == true) {
                Navigator.pop(context);
              }
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
