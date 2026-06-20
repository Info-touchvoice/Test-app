import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiki/model/short_id_model.dart';
import 'package:tiki/view/widgets/short_id_badge.dart';

import '../../../../../../../utils/constants/app_constants.dart';
import '../../../../../../../utils/theme/colors_constant.dart';
import '../../../../../ui/gradient_text_widget.dart';
import '../../zegocloud/zim_zego_sdk/internal/sdk/basic/zego_sdk_user.dart';
import 'speaking_wave.dart';

class ActiveSeat extends StatelessWidget {
  final ZegoSDKUser userInfo;
  final double iconSize;
  final double nameFontSize;
  final double labelGap;
  final double? labelMaxWidth;
  final bool compact;
  final bool isHost;

  const ActiveSeat(
    this.userInfo, {
    required this.iconSize,
    required this.nameFontSize,
    required this.labelGap,
    this.labelMaxWidth,
    this.compact = false,
    this.isHost = false,
  });

  static const double _speakThreshold = 6.0;

  @override
  Widget build(BuildContext context) {
    final micBadgeSize = compact ? 14.w : 16.w;
    final shortId =
        isHost ? ShortIdModel.legendSample : ShortIdModel.premiumSample;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: iconSize,
          width: iconSize,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              ValueListenableBuilder<String?>(
                valueListenable: userInfo.avatarUrlNotifier,
                builder: (context, avatarUrl, _) {
                  Widget avatarBody;
                  if (avatarUrl != null && avatarUrl.isNotEmpty) {
                    avatarBody = Container(
                      height: iconSize,
                      width: iconSize,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.secondaryGradient(stops: [0, 1]),
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(avatarUrl),
                      ),
                    );
                  } else {
                    avatarBody = Container(
                      height: iconSize,
                      width: iconSize,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          userInfo.userID.isNotEmpty
                              ? userInfo.userID.substring(0, 1)
                              : '?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: iconSize * 0.35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }

                  return ValueListenableBuilder<double>(
                    valueListenable: userInfo.soundLevelNotifier,
                    builder: (context, level, _) {
                      return ValueListenableBuilder<bool?>(
                        valueListenable: userInfo.isMicOnNotifier,
                        builder: (context, isMicOn, __) {
                          final speaking =
                              (isMicOn != false) && level > _speakThreshold;
                          return SpeakingWave(
                            isSpeaking: speaking,
                            size: iconSize,
                            color: AppColors.yellowBtnColor,
                            child: avatarBody,
                          );
                        },
                      );
                    },
                  );
                },
              ),
              if (isHost)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: compact ? 3.w : 5.w,
                        vertical: compact ? 0 : 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: GradientText(
                        text: 'Host',
                        style: TextStyle(
                          color: AppColors.yellowBtnColor,
                          fontSize: compact ? 6.sp : 7.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 0,
                right: 0,
                child: ValueListenableBuilder<bool?>(
                  valueListenable: userInfo.isMicOnNotifier,
                  builder: (context, isMicOn, _) {
                    return Visibility(
                      visible: isMicOn == false,
                      child: Container(
                        height: micBadgeSize,
                        width: micBadgeSize,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Image.asset(
                            AppImagePath.mic_off,
                            width: micBadgeSize * 0.7,
                            height: micBadgeSize * 0.7,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: labelGap),
        SizedBox(
          width: labelMaxWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  userInfo.userName?.split(' ').first ?? 'User',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle(
                    fontSize: nameFontSize,
                    height: 1,
                    forceStrutHeight: true,
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: nameFontSize,
                    height: 1,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              ShortIdBadge.compact(shortId: shortId),
            ],
          ),
        ),
        if (!compact) ...[
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 8,
                backgroundColor: const Color(0xFF231E28),
                child: Image.asset(
                  AppImagePath.audioLiveCoin,
                  width: 8.w,
                  height: 8.w,
                ),
              ),
              SizedBox(width: 2.w),
              ValueListenableBuilder<int?>(
                valueListenable: userInfo.coinsNotifier,
                builder: (context, coins, _) {
                  return Text(
                    '${coins ?? 0}',
                    style: TextStyle(
                      color: AppColors.yellowBtnColor,
                      fontSize: nameFontSize * 0.85,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ],
    );
  }
}
