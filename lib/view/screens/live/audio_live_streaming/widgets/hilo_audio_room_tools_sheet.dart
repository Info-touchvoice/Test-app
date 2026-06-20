import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/helpers/quick_actions.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/view/screens/live/widgets/basic_feature_sheets/local_music.dart';
import 'package:tiki/view/screens/live/widgets/beauty_filters_sheets/sticker_modal_sheets.dart';

import 'hilo_audio_room_constants.dart';

class HiloAudioRoomToolsSheet extends StatelessWidget {
  const HiloAudioRoomToolsSheet({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const HiloAudioRoomToolsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF232138),
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15.w, 13.h, 15.w, 0),
            child: Text(
              'Basic Tools',
              style: sfProDisplayRegular.copyWith(
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              children: [
                _tool(context, HiloAudioRoomAssets.toolGathering, 'Gathering', () {}),
                _tool(context, HiloAudioRoomAssets.toolBroadcast, 'Broadcast', () {}),
                _tool(
                  context,
                  HiloAudioRoomAssets.toolMusic,
                  'Music',
                  () {
                    Navigator.pop(context);
                    openBottomSheet(LocalMusicWidget(), context, back: true);
                  },
                ),
                _tool(context, HiloAudioRoomAssets.toolInvite, 'Invite', () {}),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              children: [
                _tool(
                  context,
                  HiloAudioRoomAssets.toolEffect,
                  'Effect',
                  () {
                    Navigator.pop(context);
                    openBottomSheet(StickerModalSheet(), context, back: true);
                  },
                ),
                _tool(context, HiloAudioRoomAssets.toolClean, 'Clean', () {}),
                _tool(context, HiloAudioRoomAssets.toolMusic, 'Noise Reduction', () {}),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tool(
    BuildContext context,
    String icon,
    String label,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Image.asset(icon, width: 39.w, height: 39.w, errorBuilder: (_, __, ___) {
              return Icon(Icons.settings, color: Colors.white70, size: 32.w);
            }),
            SizedBox(height: 5.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: sfProDisplayRegular.copyWith(
                fontSize: 12.sp,
                color: const Color(0xFFBDBDBD),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
