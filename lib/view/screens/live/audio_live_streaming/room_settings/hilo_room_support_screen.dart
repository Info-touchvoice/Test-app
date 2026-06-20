import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/parse/LiveStreamingModel.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_setting_constants.dart';
import 'package:tiki/view_model/live_controller.dart';

class HiloRoomSupportScreen extends StatefulWidget {
  const HiloRoomSupportScreen({Key? key}) : super(key: key);

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HiloRoomSupportScreen()),
    );
  }

  @override
  State<HiloRoomSupportScreen> createState() => _HiloRoomSupportScreenState();
}

class _HiloRoomSupportScreenState extends State<HiloRoomSupportScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<LiveViewModel>().setGifterList();
  }

  static String _formatTrophy(num value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveViewModel>(
      builder: (controller) {
        final supporters = controller.hostGifters.length;
        var trophyTotal = 0;
        for (final gifter in controller.hostGifters) {
          trophyTotal +=
              (gifter[LiveStreamingModel.keyCoins] as int? ?? 0);
        }
        if (trophyTotal == 0) {
          trophyTotal = controller.liveStreamingModel.getTotalCoins ?? 0;
        }

        return Scaffold(
          backgroundColor: HiloRoomSettingColors.bodyBg,
          appBar: AppBar(
            backgroundColor: HiloRoomSettingColors.toolbarBg,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text(
              'Room Support',
              style: sfProDisplayMedium.copyWith(
                fontSize: 15.sp,
                color: Colors.white,
              ),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(14.w, 13.h, 22.w, 90.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _StatsCard(
                      title: 'Last Week Ended',
                      supporter: '0',
                      trophy: '0',
                      level: '0',
                    ),
                    SizedBox(height: 10.h),
                    _StatsCard(
                      title: 'This Week In Progress',
                      supporter: '$supporters',
                      trophy: _formatTrophy(trophyTotal),
                      level: '0',
                    ),
                    SizedBox(height: 25.h),
                    _SectionLabel(title: 'Rule'),
                    SizedBox(height: 13.h),
                    _ruleText(
                      '1. Last week room support rewards can be received from Monday 05:00AM (GMT+3), and the rewards will be invalid if they expire.',
                    ),
                    _ruleText(
                      '2. An account can only receive support once per week. A device can only receive support once a week.',
                    ),
                    _ruleText(
                      '3. After receiving the reward, it will be automatically distributed to all administrators of the room.',
                    ),
                    _ruleText(
                      '4. Wealth level of the award administrators should >= level 3.',
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    14.w,
                    12.h,
                    14.w,
                    12.h + MediaQuery.of(context).padding.bottom,
                  ),
                  decoration: BoxDecoration(
                    color: HiloRoomSettingColors.customBar,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
                  ),
                  child: Text(
                    'Last week\'s room support did not meet the standard. This week\'s room support will be updated after 67:41:49',
                    textAlign: TextAlign.center,
                    style: sfProDisplayRegular.copyWith(
                      fontSize: 11.sp,
                      color: Colors.white,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _ruleText(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: sfProDisplayRegular.copyWith(
          fontSize: 11.sp,
          color: HiloRoomSettingColors.hint,
          height: 1.4,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;

  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 5.w,
          height: 13.h,
          decoration: BoxDecoration(
            color: const Color(0xFFA73CFF),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          title,
          style: sfProDisplayMedium.copyWith(
            fontSize: 12.sp,
            color: const Color(0xFFA73CFF),
          ),
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final String supporter;
  final String trophy;
  final String level;

  const _StatsCard({
    required this.title,
    required this.supporter,
    required this.trophy,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 87.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Column(
        children: [
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.diamond, size: 10.sp, color: const Color(0xFFA73CFF)),
              SizedBox(width: 10.w),
              Text(
                title,
                style: sfProDisplayMedium.copyWith(
                  fontSize: 12.sp,
                  color: const Color(0xFFA73CFF),
                ),
              ),
              SizedBox(width: 10.w),
              Icon(Icons.diamond, size: 10.sp, color: const Color(0xFFA73CFF)),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(child: _StatColumn(value: supporter, label: 'Supporter')),
              _verticalDivider(),
              Expanded(child: _StatColumn(value: trophy, label: 'Trophy')),
              _verticalDivider(),
              Expanded(child: _StatColumn(value: level, label: 'Level')),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 2.w,
      height: 10.h,
      color: const Color(0xFFBDBDBD),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;

  const _StatColumn({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: sfProDisplayMedium.copyWith(fontSize: 14.sp, color: Colors.white),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: sfProDisplayRegular.copyWith(
            fontSize: 11.sp,
            color: const Color(0xFFBDBDBD),
          ),
        ),
      ],
    );
  }
}
