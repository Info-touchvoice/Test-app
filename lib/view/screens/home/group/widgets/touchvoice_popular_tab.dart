import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/typography.dart';
import '../../../../../view_model/audio_home_view_model.dart';
import '../touchvoice_group_constants.dart';
import 'touchvoice_banner_carousel.dart';
import 'touchvoice_room_list_tile.dart';

class TouchVoicePopularTab extends StatefulWidget {
  const TouchVoicePopularTab({Key? key}) : super(key: key);

  @override
  State<TouchVoicePopularTab> createState() => _TouchVoicePopularTabState();
}

class _TouchVoicePopularTabState extends State<TouchVoicePopularTab> {
  int _subTab = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioHomeViewModel>(
      builder: (controller) {
        final rooms = controller.audioLiveModelList;
        return RefreshIndicator(
          onRefresh: controller.loadLive,
          color: TouchVoiceGroupColors.brandPurple,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              TouchVoiceBannerCarousel(
                items: TouchVoiceGroupAssets.audioRoomBannerUrls,
                padding: EdgeInsets.fromLTRB(15.w, 5.h, 15.w, 0),
              ),
              _rankRow(rooms),
              _subTabBar(),
              if (_subTab == 0) ...[
                ...rooms.map((r) => TouchVoiceRoomListTile(room: r)),
              ] else ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 6.h),
                  child: Text(
                    'Latest groups',
                    style: sfProDisplayRegular.copyWith(
                      fontSize: 12.sp,
                      color: TouchVoiceGroupColors.subText,
                    ),
                  ),
                ),
                ...rooms
                    .map((r) => TouchVoiceRoomListTile(room: r, showNewBadge: true)),
              ],
              if (rooms.isEmpty)
                Padding(
                  padding: EdgeInsets.all(40.h),
                  child: Center(
                    child: Text(
                      'No live rooms right now',
                      style: sfProDisplayRegular.copyWith(
                        color: TouchVoiceGroupColors.subText,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 80.h),
            ],
          ),
        );
      },
    );
  }

  Widget _rankRow(List rooms) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.w, 7.h, 15.w, 8.h),
      child: Row(
        children: [
          _rankCard(TouchVoiceGroupAssets.rankPower, 'Family', rooms),
          SizedBox(width: 7.w),
          _rankCard(TouchVoiceGroupAssets.rankFamous, 'Rank', rooms),
          SizedBox(width: 7.w),
          _rankCard(TouchVoiceGroupAssets.rankCp, 'CP', rooms),
        ],
      ),
    );
  }

  Widget _rankCard(String bg, String label, List rooms) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: SizedBox(
          height: 68.h,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(bg, fit: BoxFit.cover),
              Column(
                children: [
                  SizedBox(height: 7.h),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final avatar = rooms.length > i
                          ? rooms[i].avatar as String
                          : null;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: CircleAvatar(
                          radius: 14.r,
                          backgroundColor: Colors.white24,
                          backgroundImage: avatar != null && avatar.isNotEmpty
                              ? CachedNetworkImageProvider(avatar)
                              : null,
                          child: avatar == null || avatar.isEmpty
                              ? Icon(Icons.person, size: 14.sp, color: Colors.white)
                              : null,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 6.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _subTabBar() {
    return Container(
      height: 37.h,
      decoration: const BoxDecoration(
        color: TouchVoiceGroupColors.subTabBar,
        border: Border(bottom: BorderSide(color: TouchVoiceGroupColors.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          _subTabButton('Popular', 0),
          _subTabButton('New', 1),
        ],
      ),
    );
  }

  Widget _subTabButton(String label, int index) {
    final active = _subTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _subTab = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: sfProDisplayMedium.copyWith(
                fontSize: 14.sp,
                color: active
                    ? TouchVoiceGroupColors.titleText
                    : const Color(0x80333333),
              ),
            ),
            SizedBox(height: 6.h),
            if (active)
              Container(
                width: 16.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: TouchVoiceGroupColors.brandPurple,
                  borderRadius: BorderRadius.circular(1.5.r),
                ),
              )
            else
              SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}
