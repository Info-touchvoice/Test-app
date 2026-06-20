import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/view_model/live_controller.dart';

import '../../../../../model/popular_card_model.dart';
import '../../../../../utils/constants/typography.dart';
import '../../../../../view_model/audio_home_view_model.dart';
import '../touchvoice_group_constants.dart';
import 'touchvoice_room_list_tile.dart';

class TouchVoiceRelatedTab extends StatefulWidget {
  const TouchVoiceRelatedTab({Key? key}) : super(key: key);

  @override
  State<TouchVoiceRelatedTab> createState() => _TouchVoiceRelatedTabState();
}

class _TouchVoiceRelatedTabState extends State<TouchVoiceRelatedTab> {
  int _filter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCurrentFilter());
  }

  void _loadCurrentFilter() {
    final controller = Get.find<AudioHomeViewModel>();
    if (_filter == 0) {
      controller.loadRecentGroups();
    } else {
      controller.loadJoinedGroups();
    }
  }

  Future<void> _openCreateGroup() async {
    await LiveViewModel.openOrCreateMyAudioRoom(context);
    if (mounted) {
      await Get.find<AudioHomeViewModel>().loadMyOwnedGroup();
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioHomeViewModel>(
      builder: (controller) {
        final rooms =
            _filter == 0 ? controller.recentGroupList : controller.joinedGroupList;
        final emptyMessage = _filter == 0
            ? "You don't have recent groups"
            : "You haven't joined any groups yet";

        return RefreshIndicator(
          onRefresh: () async => _loadCurrentFilter(),
          color: TouchVoiceGroupColors.brandPurple,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              controller.myOwnedGroup != null
                  ? _myGroupCard(controller, controller.myOwnedGroup!)
                  : _createGroupCard(),
              _filterPills(),
              if (rooms.isEmpty)
                Padding(
                  padding: EdgeInsets.all(32.h),
                  child: Center(
                    child: Text(
                      emptyMessage,
                      style: sfProDisplayRegular.copyWith(
                        fontSize: 13.sp,
                        color: TouchVoiceGroupColors.subText,
                      ),
                    ),
                  ),
                )
              else
                ...rooms.map((r) => TouchVoiceRoomListTile(room: r)),
              SizedBox(height: 80.h),
            ],
          ),
        );
      },
    );
  }

  Widget _myGroupCard(AudioHomeViewModel controller, PopularModel group) {
    final liveModel = group.liveModel;
    final welcome = controller.welcomeMessageFor(liveModel);
    final viewerCount = liveModel.getViewersCount ?? 0;

    return GestureDetector(
      onTap: _openCreateGroup,
      child: Container(
        margin: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 10.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CachedNetworkImage(
                imageUrl: group.image,
                width: 58.w,
                height: 58.w,
                fit: BoxFit.cover,
                placeholder: (_, __) => Image.asset(
                  TouchVoiceGroupAssets.roomPlaceholder,
                  width: 58.w,
                  height: 58.w,
                  fit: BoxFit.cover,
                ),
                errorWidget: (_, __, ___) => Image.asset(
                  TouchVoiceGroupAssets.roomPlaceholder,
                  width: 58.w,
                  height: 58.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (group.flag.isNotEmpty) ...[
                        Text(group.flag, style: TextStyle(fontSize: 14.sp)),
                        SizedBox(width: 4.w),
                      ],
                      Expanded(
                        child: Text(
                          group.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: sfProDisplayMedium.copyWith(
                            fontSize: 15.sp,
                            color: TouchVoiceGroupColors.titleText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    welcome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: sfProDisplayRegular.copyWith(
                      fontSize: 12.sp,
                      color: TouchVoiceGroupColors.subText,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Image.asset(
                  TouchVoiceGroupAssets.onMic,
                  width: 16.w,
                  height: 16.w,
                ),
                SizedBox(height: 6.h),
                Text(
                  '$viewerCount',
                  style: sfProDisplayMedium.copyWith(
                    fontSize: 12.sp,
                    color: TouchVoiceGroupColors.brandPurple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _createGroupCard() {
    return GestureDetector(
      onTap: _openCreateGroup,
      child: Container(
        margin: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 10.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              TouchVoiceGroupAssets.createGroup,
              width: 58.w,
              height: 58.w,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create My Group',
                    style: sfProDisplayMedium.copyWith(
                      fontSize: 15.sp,
                      color: TouchVoiceGroupColors.titleText,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Start your journey in TouchVoice',
                    style: sfProDisplayRegular.copyWith(
                      fontSize: 12.sp,
                      color: TouchVoiceGroupColors.subText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterPills() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.w, 4.h, 15.w, 8.h),
      child: Row(
        children: [
          _pill('Recently', 0),
          SizedBox(width: 10.w),
          _pill('Joined', 1),
        ],
      ),
    );
  }

  Widget _pill(String label, int index) {
    final active = _filter == index;
    return GestureDetector(
      onTap: () {
        if (_filter == index) return;
        setState(() => _filter = index);
        _loadCurrentFilter();
      },
      child: Container(
        constraints: BoxConstraints(minWidth: 71.w, minHeight: 27.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFF0E6FF) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(14.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active
                ? TouchVoiceGroupColors.filterActive
                : TouchVoiceGroupColors.filterInactive,
          ),
        ),
      ),
    );
  }
}
