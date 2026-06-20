import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/typography.dart';
import '../../../../../utils/permission/go_live_permission.dart';
import '../../../../../view_model/audio_home_view_model.dart';
import '../touchvoice_group_constants.dart';
import 'touchvoice_planets_globe.dart';

class TouchVoiceNewTab extends StatefulWidget {
  const TouchVoiceNewTab({Key? key}) : super(key: key);

  @override
  State<TouchVoiceNewTab> createState() => _TouchVoiceNewTabState();
}

class _TouchVoiceNewTabState extends State<TouchVoiceNewTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AudioHomeViewModel>().loadNewSection();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioHomeViewModel>(
      builder: (controller) {
        return RefreshIndicator(
          onRefresh: controller.loadNewSection,
          color: TouchVoiceGroupColors.brandPurple,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(15.w, 20.h, 15.w, 0),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: _sectionTitle('New Members'),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: SizedBox(
                    height: 365.h,
                    width: MediaQuery.of(context).size.width,
                    child: TouchVoicePlanetsGlobe(
                      members: TouchVoiceGlobeDemoMembers.members,
                      height: 365.h,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(15.w, 20.h, 15.w, 80.h),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: _newUsersRow(
                          TouchVoiceGlobeDemoMembers.members.length,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      _sectionTitle('New Room'),
                      SizedBox(height: 10.h),
                      if (controller.newRoomList.isEmpty)
                        _emptyHint('No new rooms yet')
                      else
                        _newRoomsGrid(controller.newRoomList),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: sfProDisplayMedium.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: TouchVoiceGroupColors.titleText,
      ),
    );
  }

  Widget _newUsersRow(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.circle, size: 7.sp, color: const Color(0xFF62C9FE)),
        SizedBox(width: 6.w),
        Text(
          'New users',
          style: sfProDisplayRegular.copyWith(
            fontSize: 13.sp,
            color: TouchVoiceGroupColors.subText,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          '$count',
          style: sfProDisplayMedium.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: TouchVoiceGroupColors.titleText,
          ),
        ),
      ],
    );
  }

  Widget _emptyHint(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: Text(
          text,
          style: sfProDisplayRegular.copyWith(
            fontSize: 13.sp,
            color: TouchVoiceGroupColors.subText,
          ),
        ),
      ),
    );
  }

  Widget _newRoomsGrid(List rooms) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 0.78,
      ),
      itemCount: rooms.length,
      itemBuilder: (_, i) => _newRoomCard(rooms[i]),
    );
  }

  Widget _newRoomCard(room) {
    return GestureDetector(
      onTap: () => LivePermissionHandler.checkPermission(
        room.liveModel.getStreamingType,
        context,
        liveStreamingModel: room.liveModel,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CachedNetworkImage(
                    imageUrl: room.image,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Image.asset(
                      TouchVoiceGroupAssets.roomPlaceholder,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.r),
                        bottomRight: Radius.circular(8.r),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 10.sp),
                        SizedBox(width: 2.w),
                        Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 6.w,
                  bottom: 6.h,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          TouchVoiceGroupAssets.onMic,
                          width: 12.w,
                          height: 12.w,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          '${room.achievementCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              if (room.flag.isNotEmpty)
                Text(room.flag, style: TextStyle(fontSize: 12.sp)),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  room.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sfProDisplayMedium.copyWith(
                    fontSize: 12.sp,
                    color: TouchVoiceGroupColors.titleText,
                  ),
                ),
              ),
            ],
          ),
          Text(
            room.liveModel.getTitle ?? room.country,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sfProDisplayRegular.copyWith(
              fontSize: 11.sp,
              color: TouchVoiceGroupColors.subText,
            ),
          ),
        ],
      ),
    );
  }
}
