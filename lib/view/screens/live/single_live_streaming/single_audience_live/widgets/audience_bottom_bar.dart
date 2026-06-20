import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tiki/helpers/quick_actions.dart';
import 'package:tiki/helpers/quick_help.dart';
import 'package:tiki/utils/gradient_wrapper.dart';
import 'package:tiki/view/screens/live/single_live_streaming/single_audience_live/widgets/audience_gift_sheet.dart';
import 'package:tiki/view_model/battle_controller.dart';
import 'package:tiki/view_model/zego_controller.dart';

import '../../../../../../utils/constants/app_constants.dart';
import '../../../../../../utils/theme/colors_constant.dart';
import '../../../../../../view_model/live_controller.dart';
import '../../../widgets/audio_live_invitation_sheet.dart';
import '../../../widgets/basic_audience_feature_sheet.dart';
import '../../../widgets/subscrption/susbcription_audience_sheet.dart';
import '../../../zegocloud/zim_zego_sdk/internal/business/business_define.dart';
import '../../../zegocloud/zim_zego_sdk/zego_live_streaming_manager.dart';
import '../../../zegocloud/zim_zego_sdk/zego_sdk_manager.dart';
import '../../single_streamer_live/single_live_screen/battle/battle_disconnect_sheet.dart';

class AudienceBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BattleViewModel battleViewModel = Get.find();
    ZegoController zegoController = Get.find();
    LiveViewModel liveViewModel = Get.find();
    RxBool joined = false.obs;
    return GetBuilder<ZegoController>(
        init: zegoController,
        builder: (zegoController) {
          return ValueListenableBuilder<ZegoLiveRole>(
              valueListenable:
                  ZegoLiveStreamingManager.instance.currentUserRoleNoti,
              builder: (context, role, _) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: battleViewModel.isBattleView ? 15 : 20, right: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => openBottomSheet(Subscribe(), context),
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: Image.asset(AppImagePath.subscriber,
                              width: 25, height: 25),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          if (Get.find<LiveViewModel>()
                                  .isUserInChatDisableList() ==
                              true) {
                            QuickHelp.showAppNotificationAdvanced(
                                title:
                                    'The streamer has disabled your access to the chat feature.',
                                context: context);
                          } else {
                            Get.find<LiveViewModel>().chatField.value = true;
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: Image.asset(AppImagePath.chat,
                              width: 22, height: 22),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            backgroundColor: AppColors.grey500,
                            builder: (context) => BasicAudienceFeatureSheet(),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: Image.asset(AppImagePath.menu,
                              width: 25, height: 25),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (role == ZegoLiveRole.audience)
                        ValueListenableBuilder<bool>(
                            valueListenable: zegoController.isApplyStateNoti,
                            builder: (context, applying, _) {
                              return GestureDetector(
                                onTap: () {
                                  if (applying == false)
                                    zegoController.applyCoHost();
                                  else {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      isScrollControlled: true,
                                      backgroundColor: AppColors.grey500,
                                      builder: (context) => Wrap(
                                        children: [
                                          AudioBottomModalSheet(),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: CircleAvatar(
                                  backgroundColor:
                                      Colors.black.withOpacity(0.5),
                                  child: GradientWrapper(
                                      applyGradient: applying,
                                      child: Image.asset(AppImagePath.link,
                                          width: 25,
                                          height: 25,
                                          color: AppColors.white)),
                                ),
                              );
                            }),
                      if (role == ZegoLiveRole.coHost ||
                          battleViewModel.isCurrentUserPlayerB == true)
                        if (ZEGOSDKManager.instance.currentUser != null)
                          ValueListenableBuilder<bool>(
                              valueListenable: ZEGOSDKManager
                                  .instance.currentUser!.isMicOnNotifier,
                              builder: (context, isMicOn, _) {
                                return GestureDetector(
                                  onTap: () {
                                    ZEGOSDKManager.instance.expressService
                                        .turnMicrophoneOn(!isMicOn);
                                    isMicOn = !isMicOn;
                                  },
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Colors.black.withOpacity(0.5),
                                    child: Image.asset(
                                      AppImagePath.micIcon,
                                      width: 25,
                                      height: 25,
                                      color: isMicOn
                                          ? AppColors.white
                                          : AppColors.yellowBtnColor,
                                    ),
                                  ),
                                );
                              }),
                      const Spacer(),
                      if (role == ZegoLiveRole.coHost)
                        GestureDetector(
                          onTap: () {
                            zegoController.endCoHost();
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.black.withOpacity(0.5),
                            child: Image.asset(AppImagePath.end_call,
                                width: 25, height: 25),
                          ),
                        ),
                      if (role == ZegoLiveRole.coHost) const SizedBox(width: 8),
                      if (battleViewModel.isCurrentUserPlayerB == false)
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              isScrollControlled: true,
                              backgroundColor: AppColors.grey500,
                              builder: (context) => Wrap(
                                children: [
                                  AudienceGiftSheet(
                                    battleViewModel: battleViewModel,
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            width: 36.w,
                            height: 36.w,
                            child: Lottie.asset(AppImagePath.giftAnimation,
                                fit: BoxFit.cover),
                          ),
                        ),
                      if (battleViewModel.isCurrentUserPlayerB == true)
                        GestureDetector(
                          onTap: () {
                            if (battleViewModel.isBattleView) {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                isScrollControlled: true,
                                backgroundColor: AppColors.grey500,
                                builder: (context) => Wrap(
                                  children: [
                                    BattleDisconnectSheet(),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.lightOrange,
                                  AppColors.darkOrange,
                                ],
                              ),
                            ),
                            child: Image.asset(AppImagePath.sword,
                                width: 25, height: 25),
                          ),
                        )
                    ],
                  ),
                );
              });
        });
  }
}
