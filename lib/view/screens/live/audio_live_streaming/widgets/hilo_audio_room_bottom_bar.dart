import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/helpers/quick_help.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/widgets/hilo_audio_room_chat_sheet.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/widgets/hilo_audio_room_constants.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/widgets/hilo_audio_room_tools_sheet.dart';
import 'package:tiki/view/screens/live/single_live_streaming/single_audience_live/widgets/audience_gift_sheet.dart';
import 'package:tiki/view/screens/live/zegocloud/zim_zego_sdk/zego_sdk_manager.dart';
import 'package:tiki/view_model/live_controller.dart';

/// Hilo 4.16.0 `chat_group_input_layout.xml` — 49dp bar, Say Hi + action icons.
class HiloAudioRoomBottomBar extends StatefulWidget {
  const HiloAudioRoomBottomBar({Key? key}) : super(key: key);

  @override
  State<HiloAudioRoomBottomBar> createState() => _HiloAudioRoomBottomBarState();
}

class _HiloAudioRoomBottomBarState extends State<HiloAudioRoomBottomBar> {
  bool _roomSoundMuted = false;

  void _openSayHi() {
    final liveViewModel = Get.find<LiveViewModel>();
    if (liveViewModel.isUserInChatDisableList() == true) {
      QuickHelp.showAppNotificationAdvanced(
        title: 'The streamer has disabled your access to the chat feature.',
        context: context,
      );
      return;
    }
    liveViewModel.chatField.value = true;
  }

  void _toggleRoomSound() {
    setState(() => _roomSoundMuted = !_roomSoundMuted);
    ZEGOSDKManager.instance.expressService
        .muteAllPlayStreamAudio(_roomSoundMuted);
  }

  void _openGiftSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2A2A2E),
      builder: (context) => Wrap(children: [AudienceGiftSheet()]),
    );
  }

  Widget _actionIcon(String asset, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.all(2.w),
        child: Image.asset(
          asset,
          width: 38.w,
          height: 38.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: EdgeInsets.zero,
      child: SizedBox(
        height: 49.h,
        child: Padding(
          padding: EdgeInsets.only(left: 8.w, bottom: 4.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _openSayHi,
                  child: Container(
                    height: 34.h,
                    constraints: BoxConstraints(minWidth: 106.w),
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: HiloAudioRoomColors.sayHiPillFill,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          HiloAudioRoomAssets.sayHiIcon,
                          width: 16.w,
                          height: 16.w,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            'Say Hi',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: sfProDisplayRegular.copyWith(
                              fontSize: 12.sp,
                              color: HiloAudioRoomColors.sayHiText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              _actionIcon(
                _roomSoundMuted
                    ? HiloAudioRoomAssets.soundMuted
                    : HiloAudioRoomAssets.soundOn,
                onTap: _toggleRoomSound,
              ),
              SizedBox(width: 8.w),
              _actionIcon(
                HiloAudioRoomAssets.messages,
                onTap: () => HiloAudioRoomChatSheet.show(context),
              ),
              SizedBox(width: 8.w),
              _actionIcon(
                HiloAudioRoomAssets.tools,
                onTap: () => HiloAudioRoomToolsSheet.show(context),
              ),
              const Expanded(child: SizedBox.shrink()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Image.asset(
                  HiloAudioRoomAssets.game,
                  width: 32.w,
                  height: 25.h,
                  fit: BoxFit.contain,
                ),
              ),
              GestureDetector(
                onTap: _openGiftSheet,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.only(right: 14.w),
                  child: Image.asset(
                    HiloAudioRoomAssets.gift,
                    width: 30.w,
                    height: 30.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
