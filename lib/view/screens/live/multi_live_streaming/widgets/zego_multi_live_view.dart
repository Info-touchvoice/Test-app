import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tiki/view/screens/live/multi_live_streaming/widgets/screen_share_view.dart';
import 'package:tiki/view/screens/live/zegocloud/zim_zego_sdk/internal/business/business_define.dart';
import 'package:tiki/view/screens/live/zegocloud/zim_zego_sdk/zego_sdk_manager.dart';
import 'package:tiki/view_model/live_controller.dart';
import 'package:tiki/view_model/zego_controller.dart';
import '../../../../../utils/theme/colors_constant.dart';
import '../../zegocloud/zim_zego_sdk/internal/sdk/basic/zego_sdk_user.dart';
import '../../zegocloud/zim_zego_sdk/zego_live_streaming_manager.dart';
import 'active_multi_guest_options.dart';
import 'camera_off_widget.dart';
import 'empty_seat.dart';
import 'multi_guest_grid_settings.dart';
import 'multi_user_details_widget.dart';
import '../../audio_live_streaming/widgets/speaking_wave.dart';

class ZegoMultiLiveView extends StatefulWidget {
  const ZegoMultiLiveView({required this.userInfo, required this.seat,});

  final ZegoSDKUser? userInfo;
  final int seat;

  @override
  State<ZegoMultiLiveView> createState() => _ZegoMultiLiveViewState();
}

class _ZegoMultiLiveViewState extends State<ZegoMultiLiveView> {
  LiveViewModel liveViewModel = Get.find();
  // Higher threshold + softer animation to avoid distracting others.
  static const double _speakThreshold = 10.0;

  @override
  Widget build(BuildContext context) {
    if(widget.userInfo != null)
      return GestureDetector(
        onTap: (){
          if(liveViewModel.role == ZegoLiveRole.host)
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
              if(widget.seat!=0)
              ActiveMultiGuestOptions(widget.userInfo,widget.seat),
              if(widget.seat==0)
                MultiGuestGridSettings(widget.userInfo!),
            ],
          ),
        );
          else{
          if(widget.userInfo!.userID == ZEGOSDKManager.instance.currentUser!.userID)
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
                    MultiGuestGridSettings(widget.userInfo!),
                ],
              ),
            );
          }

        },
        child: ValueListenableBuilder<bool>(
            valueListenable: widget.userInfo!.isCamerOnNotifier,
            builder: (context, isCameraOn, _) {
              final tile = Container(
                decoration: BoxDecoration(
                  color:  AppColors.black.withOpacity(0.2) ,
                ),
                child: Stack(children:
                [
                  createView(isCameraOn),
                  MultiUserDetails(widget.userInfo!, widget.seat),
                ]),
              );

              return ValueListenableBuilder<double>(
                  valueListenable: widget.userInfo!.soundLevelNotifier,
                  builder: (context, level, __) {
                    return ValueListenableBuilder<bool>(
                        valueListenable: widget.userInfo!.isMicOnNotifier,
                        builder: (context, micOn, ___) {
                          final speaking = micOn && level > _speakThreshold;
                          return SpeakingWave(
                            isSpeaking: speaking,
                            color: AppColors.yellowBtnColor,
                            shape: SpeakingWaveShape.roundedRect,
                            borderRadius: 12,
                            ringCount: 1,
                            maxScaleDelta: 0.06,
                            maxOpacity: 0.35,
                            strokeWidth: 2,
                            glow: false,
                            clipBehavior: Clip.hardEdge,
                            child: tile,
                          );
                        });
                  });
            }),
      );
    else
      return Container(
        width: double.infinity,
          child: EmptySeatMultiLive(widget.seat));
  }

  Widget createView(bool isCameraOn) {
    return ValueListenableBuilder<bool>(
      valueListenable: ZEGOSDKManager.instance.expressService.isSharingScreen,
      builder: (context, screenSharing, _) {
        if(screenSharing && widget.seat==0)
        return ValueListenableBuilder<Widget?>(
          valueListenable: ZEGOSDKManager.instance.expressService.hostScreenView,
          builder: (context, screenView, _) {
            if(screenView != null || liveViewModel.role == ZegoLiveRole.host)
              return liveViewModel.role==ZegoLiveRole.host ? ScreenShareView(widget.userInfo!) : screenView!;
            else
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.2),
                ),
              );
          });
        else
        if (isCameraOn) {
          return videoView();
        } else {
          if (widget.userInfo!.streamID != null) {
            return CameraOffWidget(widget.seat , widget.userInfo!);
          } else {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(0.2),
              ),
            );
          }
        }
      },
    );
  }


  Widget videoView() {
    return ValueListenableBuilder<Widget?>(
      valueListenable: widget.userInfo!.videoViewNotifier,
      builder: (context, view, _) {
        if (view != null) {
          return view;
        } else {
          return SizedBox();
        }
      },
    );
  }
}
