import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tiki/helpers/quick_help.dart';
import 'package:tiki/view_model/userViewModel.dart';
import 'package:tiki/view_model/zego_controller.dart';

import '../../../../../../../utils/constants/typography.dart';
import '../../../../../../../utils/theme/colors_constant.dart';
import '../../../../../../../view_model/battle_controller.dart';
import '../../../../../../../view_model/global_live_stream_controller.dart';
import '../../../../../../../view_model/live_controller.dart';
import '../../../../../../widgets/custom_buttons.dart';

class BattleInviteSheet extends StatefulWidget {
  BattleInviteSheet(
      {required this.time, required this.round, required this.top});

  final int time;
  final int round;
  final int top;

  @override
  State<BattleInviteSheet> createState() => _BattleInviteSheetState();
}

class _BattleInviteSheetState extends State<BattleInviteSheet> {
  int selectedIndex = -1;
  int selectedUserUid = -1;

  GlobalLiveStreamViewModel globalViewModel = Get.find();

  @override
  void initState() {
    globalViewModel.loadLive();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalLiveStreamViewModel>(
        init: globalViewModel,
        builder: (controller) {
          return Container(
            height: Get.height * 0.6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.search, color: Colors.white, size: 28),
                      Text(
                        'Battles',
                        style: quinlliykRegular.copyWith(fontSize: 24),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.divider, thickness: 1.2),
                  const SizedBox(height: 24),
                  Text(
                    // 'Friends (80)',
                    'People who are live',
                    style: sfProDisplayBold.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  if (controller.liveStreamingModelList.isEmpty)
                    Column(
                      children: [
                        Container(
                          height: 200.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "*  ",
                                style: sfProDisplayBlack.copyWith(
                                    color: Colors.red),
                              ),
                              Text(
                                "No host is currently live",
                                style: sfProDisplayMedium.copyWith(
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (controller.liveStreamingModelList.isNotEmpty)
                    ...List.generate(
                      controller.liveStreamingModelList.length,
                      (index) => GestureDetector(
                        onTap: () {
                          selectedIndex = index;
                          selectedUserUid = controller
                              .liveStreamingModelList[index]
                              .liveModel
                              .getAuthor!
                              .getUid!;
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: AppColors.divider,
                                backgroundImage: NetworkImage(controller
                                    .liveStreamingModelList[index].avatar),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(controller
                                          .liveStreamingModelList[index].name),
                                      const SizedBox(width: 16),
                                      SvgPicture.asset(
                                        controller
                                            .liveStreamingModelList[index].flag,
                                        width: 24,
                                        height: 17,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        'id: ${controller.liveStreamingModelList[index].liveModel.getAuthor!.getUid!}',
                                        style: sfProDisplayRegular.copyWith(
                                            fontSize: 12,
                                            color: AppColors.white
                                                .withOpacity(0.7)),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(Icons.copy,
                                          size: 15,
                                          color:
                                              AppColors.white.withOpacity(0.7)),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.white.withOpacity(0.7),
                                      width: 2),
                                  color: selectedIndex == index
                                      ? AppColors.yellowColor
                                      : Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Spacer(),
                  PrimaryButton(
                    title: 'Invite',
                    borderRadius: 35,
                    height: 48,
                    textStyle: sfProDisplayBold.copyWith(
                        fontSize: 16, color: AppColors.white),
                    gradient: AppColors.secondaryGradient(stops: [0.0, 1]),
                    onTap: () {
                      if (selectedIndex != -1) {
                        Navigator.pop(context);
                        Get.find<ZegoController>()
                            .sendPkBattleRequest(selectedUserUid, context);
                        Get.find<BattleViewModel>().initializeBattle(
                            time: widget.time,
                            rounds: widget.round,
                            host: Get.find<UserViewModel>().currentUser,
                            liveObjectId: Get.find<LiveViewModel>()
                                .liveStreamingModel
                                .objectId!,
                            liveObject:
                                Get.find<LiveViewModel>().liveStreamingModel);
                      } else {
                        QuickHelp.showAppNotificationAdvanced(
                            title:
                                "Please choose a user to invite to a PK battle",
                            context: context);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        });
  }
}
