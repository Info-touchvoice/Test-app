
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../utils/constants/app_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../view_model/live_controller.dart';
import '../single_live_streaming/single_streamer_live/single_live_screen/widgets/chat_feature.dart';
import '../audio_live_streaming/widgets/hilo_audio_room_bottom_bar.dart';
import 'bottom_bar.dart';
import '../zegocloud/zim_zego_sdk/internal/business/business_define.dart';
import '../audio_live_streaming/widgets/audio_viewers_strip.dart';

class BottomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LiveViewModel liveViewModel = Get.find();
    final isAudio = liveViewModel.isAudioLive;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: liveViewModel.isMultiGuest ? 12.w : 0),
      child: SizedBox(
        height: isAudio ? 185.h : 230.h,
        child: Obx(() {
          return Column(
            children: [
              if (isAudio) const AudioViewersStrip(),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: ChatFeature(height: isAudio ? null : 185),
                      ),
                    ),
                    if (!isAudio) ...[
                      SizedBox(width: 5.w),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.store),
                        child: Padding(
                          padding: EdgeInsets.only(top: 15.h),
                          child: Image.asset(
                            AppImagePath.shopIcon,
                            height: 115.h,
                            width: 100.w,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 115.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (liveViewModel.chatField.value == false)
                isAudio
                    ? const HiloAudioRoomBottomBar()
                    : BottomBar(),
              if (liveViewModel.chatField.value == true)
                SizedBox(height: isAudio ? 53.h : 67.h),
              if (liveViewModel.chatField.value == false && !isAudio)
                SizedBox(
                  height: Get.find<LiveViewModel>().role == ZegoLiveRole.audience
                      ? 18
                      : 20,
                ),
            ],
          );
        }),
      ),
    );
  }
}
