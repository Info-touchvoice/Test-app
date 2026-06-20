import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/view/screens/live/widgets/whisper/whisper_modal.dart';
import 'package:tiki/view_model/live_controller.dart';

import 'hilo_audio_room_constants.dart';

class HiloAudioRoomChatSheet extends StatelessWidget {
  const HiloAudioRoomChatSheet({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const HiloAudioRoomChatSheet(),
    );
  }

  void _openSayHiChat() {
    final liveViewModel = Get.find<LiveViewModel>();
    liveViewModel.chatField.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 80.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Text(
              'Chat',
              style: sfProDisplaySemiBold.copyWith(
                fontSize: 16.sp,
                color: const Color(0xFF333333),
              ),
            ),
          ),
          _item(
            context,
            iconAsset: HiloAudioRoomAssets.chatInformation,
            iconBg: const Color(0xFFFFC107),
            title: 'TouchVoice Information',
            subtitle: 'Room updates and announcements',
            onTap: () {
              Navigator.pop(context);
              _openSayHiChat();
            },
          ),
          _divider(),
          _item(
            context,
            iconAsset: HiloAudioRoomAssets.chatAssistant,
            iconBg: const Color(0xFF9C27B0),
            title: 'TouchVoice assistant',
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => WhisperModal(),
              );
            },
          ),
          _divider(),
          _item(
            context,
            iconAsset: HiloAudioRoomAssets.chatPlaza,
            iconBg: const Color(0xFFFF9800),
            title: 'Plaza',
            subtitle: 'share your moments',
            onTap: () => Navigator.pop(context),
          ),
          _divider(),
          _item(
            context,
            iconAsset: HiloAudioRoomAssets.chatMasked,
            iconBg: const Color(0xFFE91E63),
            title: 'Masked Chat',
            subtitle: 'Start a private conversation',
            showOnlineDot: true,
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => WhisperModal(),
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 12.h),
        ],
      ),
    );
  }

  Widget _divider() => Divider(height: 1, color: Colors.grey.shade200);

  Widget _item(
    BuildContext context, {
    required String iconAsset,
    required Color iconBg,
    required String title,
    String? subtitle,
    bool showOnlineDot = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8.w),
              child: Image.asset(iconAsset, fit: BoxFit.contain),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: sfProDisplayMedium.copyWith(
                      fontSize: 15.sp,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        if (showOnlineDot) ...[
                          Container(
                            width: 7.w,
                            height: 7.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFF26EA83),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5.w),
                        ],
                        Expanded(
                          child: Text(
                            subtitle,
                            style: sfProDisplayRegular.copyWith(
                              fontSize: 12.sp,
                              color: const Color(0xFF999999),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
