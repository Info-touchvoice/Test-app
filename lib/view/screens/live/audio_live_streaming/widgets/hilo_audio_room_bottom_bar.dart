import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/helpers/quick_help.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/theme/colors_constant.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/widgets/hilo_audio_room_chat_sheet.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/widgets/hilo_audio_room_constants.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/widgets/hilo_audio_room_tools_sheet.dart';
import 'package:tiki/view/screens/live/single_live_streaming/single_audience_live/widgets/audience_gift_sheet.dart';
import 'package:tiki/view/screens/live/single_live_streaming/single_audience_live/widgets/gift_wish_sheet.dart';
import 'package:tiki/view/screens/live/zegocloud/zim_zego_sdk/zego_sdk_manager.dart';
import 'package:tiki/view_model/live_controller.dart';

/// TouchVoice compact room action bar inspired by Hilo's icon-first system.
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

  void _openTreasureSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: AppColors.grey500,
      builder: (context) => Wrap(children: [GiftWishSheet()]),
    );
  }

  Widget _inputPill({required bool compact}) {
    return GestureDetector(
      onTap: _openSayHi,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: compact ? 34.h : 38.h,
        padding: EdgeInsets.symmetric(horizontal: compact ? 9.w : 12.w),
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground.withOpacity(0.65),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.vipGold.withOpacity(0.22)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: compact ? 14.w : 16.w,
              color: Colors.white.withOpacity(0.85),
            ),
            SizedBox(width: compact ? 5.w : 7.w),
            Flexible(
              child: Text(
                'Say Hi...',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: sfProDisplayRegular.copyWith(
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton({
    required VoidCallback onTap,
    IconData? icon,
    String? asset,
    String? label,
    bool accent = false,
    bool colorful = false,
    required bool compact,
  }) {
    final foregroundColor =
        accent ? AppColors.vipGold : Colors.white.withOpacity(0.85);
    final buttonSize = compact ? 34.w : 38.w;
    final iconSize = compact ? 19.w : 21.w;
    final assetSize = colorful ? (compact ? 25.w : 28.w) : iconSize;

    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: buttonSize,
          height: compact ? 34.h : 38.h,
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground.withOpacity(0.65),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: accent
                  ? AppColors.vipGold.withOpacity(0.55)
                  : Colors.white.withOpacity(0.08),
            ),
          ),
          alignment: Alignment.center,
          child: asset != null
              ? Image.asset(
                  asset,
                  width: assetSize,
                  height: assetSize,
                  fit: BoxFit.contain,
                  color: colorful ? null : foregroundColor,
                  errorBuilder: (_, __, ___) => Icon(
                    icon ?? Icons.apps_rounded,
                    color: foregroundColor,
                    size: iconSize,
                  ),
                )
              : Icon(
                  icon,
                  color: foregroundColor,
                  size: iconSize,
                ),
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
        height: 54.h,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.w, 4.h, 8.w, 4.h),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 360;
              final tightGap = SizedBox(width: compact ? 4.w : 6.w);
              final groupGap = SizedBox(width: compact ? 5.w : 8.w);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: _inputPill(compact: compact),
                  ),
                  tightGap,
                  _iconButton(
                    onTap: _toggleRoomSound,
                    icon: _roomSoundMuted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                    label: 'Speaker',
                    accent: _roomSoundMuted,
                    compact: compact,
                  ),
                  tightGap,
                  _iconButton(
                    onTap: () => HiloAudioRoomChatSheet.show(context),
                    icon: Icons.mail_outline_rounded,
                    label: 'Messages',
                    compact: compact,
                  ),
                  tightGap,
                  _iconButton(
                    onTap: () => HiloAudioRoomToolsSheet.show(context),
                    icon: Icons.apps_rounded,
                    label: 'More tools',
                    compact: compact,
                  ),
                  groupGap,
                  _iconButton(
                    onTap: _openGiftSheet,
                    asset: HiloAudioRoomAssets.gift,
                    label: 'Gift',
                    accent: true,
                    colorful: true,
                    compact: compact,
                  ),
                  tightGap,
                  _iconButton(
                    onTap: _openTreasureSheet,
                    asset: HiloAudioRoomAssets.game,
                    icon: Icons.card_giftcard_rounded,
                    label: 'Treasure',
                    accent: true,
                    colorful: true,
                    compact: compact,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
