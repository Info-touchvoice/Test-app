import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/view/screens/live/zegocloud/zim_zego_sdk/internal/business/audioRoom/live_audio_room_seat.dart';
import 'package:tiki/view/screens/live/zegocloud/zim_zego_sdk/internal/sdk/basic/zego_sdk_user.dart';
import 'package:tiki/view/screens/live/zegocloud/zim_zego_sdk/live_audio_room_manager.dart';
import 'package:tiki/view_model/userViewModel.dart';
import 'package:tiki/view_model/zego_controller.dart';

class AudioSeatOptionsSheet extends StatelessWidget {
  final ZegoLiveAudioRoomSeat seat;
  final ZegoSDKUser? occupant;
  final int displayNumber;
  final bool isHostRole;

  const AudioSeatOptionsSheet({
    Key? key,
    required this.seat,
    required this.occupant,
    required this.displayNumber,
    required this.isHostRole,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required ZegoLiveAudioRoomSeat seat,
    required ZegoSDKUser? occupant,
    required int displayNumber,
    required bool isHostRole,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AudioSeatOptionsSheet(
        seat: seat,
        occupant: occupant,
        displayNumber: displayNumber,
        isHostRole: isHostRole,
      ),
    );
  }

  bool get _isEmpty => occupant == null;

  String get _userName {
    final user = Get.find<UserViewModel>().currentUser;
    return user.getFullName ?? user.getUsername ?? 'User';
  }

  @override
  Widget build(BuildContext context) {
    final manager = ZegoLiveAudioRoomManager.instance;
    final zego = Get.find<ZegoController>();
    final currentUserId =
        Get.find<UserViewModel>().currentUser.getUid.toString();
    final isSelf = occupant?.userID == currentUserId;

    return ValueListenableBuilder<Set<int>>(
      valueListenable: manager.lockedSeatIndices,
      builder: (context, lockedSeats, _) {
        final isLocked = lockedSeats.contains(seat.seatIndex);
        final showTakeMic = _isEmpty && !isLocked;
        final showCloseMic = isHostRole || (!_isEmpty && isSelf);

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A2640),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          padding: EdgeInsets.fromLTRB(0, 12.h, 0, 0),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showTakeMic)
                  _OptionTile(
                    title: 'Take the mic',
                    onTap: () async {
                      Navigator.pop(context);
                      await zego.takeOrSwitchSeat(seat.seatIndex);
                    },
                  ),
                if (showCloseMic)
                  _OptionTile(
                    title: 'Close mic',
                    onTap: () async {
                      Navigator.pop(context);
                      await manager.closeMicForSeat(
                        occupant: occupant,
                        currentUserId: currentUserId,
                      );
                      zego.update();
                    },
                  ),
                if (isHostRole)
                  _OptionTile(
                    title: isLocked ? 'Unlock seat' : 'Lock seat',
                    onTap: () async {
                      Navigator.pop(context);
                      await manager.toggleSeatLock(seat.seatIndex);
                      zego.update();
                    },
                  ),
                Container(
                  height: 0.5,
                  color: Colors.white12,
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _userName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: sfProDisplayMedium.copyWith(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: sfProDisplayMedium.copyWith(
                            fontSize: 14.sp,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _OptionTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        alignment: Alignment.center,
        child: Text(
          title,
          style: sfProDisplayRegular.copyWith(
            fontSize: 15.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
