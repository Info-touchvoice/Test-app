import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../model/popular_card_model.dart';
import '../../../../../utils/constants/typography.dart';
import '../../../../../utils/permission/go_live_permission.dart';
import '../touchvoice_group_constants.dart';

class TouchVoiceRoomListTile extends StatelessWidget {
  final PopularModel room;
  final bool showNewBadge;

  const TouchVoiceRoomListTile({
    Key? key,
    required this.room,
    this.showNewBadge = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => LivePermissionHandler.checkPermission(
        room.liveModel.getStreamingType,
        context,
        liveStreamingModel: room.liveModel,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
        constraints: BoxConstraints(minHeight: 87.h),
        decoration: const BoxDecoration(
          color: TouchVoiceGroupColors.bodyBg,
          border: Border(bottom: BorderSide(color: TouchVoiceGroupColors.divider)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CachedNetworkImage(
                imageUrl: room.image,
                width: 73.w,
                height: 73.w,
                fit: BoxFit.cover,
                placeholder: (_, __) => Image.asset(
                  TouchVoiceGroupAssets.roomPlaceholder,
                  width: 73.w,
                  height: 73.w,
                  fit: BoxFit.cover,
                ),
                errorWidget: (_, __, ___) => Image.asset(
                  TouchVoiceGroupAssets.roomPlaceholder,
                  width: 73.w,
                  height: 73.w,
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
                      Flexible(
                        child: Text(
                          room.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: sfProDisplayMedium.copyWith(
                            fontSize: 15.sp,
                            color: TouchVoiceGroupColors.titleText,
                          ),
                        ),
                      ),
                      if (showNewBadge) ...[
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: TouchVoiceGroupColors.brandPurple,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    room.liveModel.getTitle ?? room.country,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: sfProDisplayRegular.copyWith(
                      fontSize: 12.sp,
                      color: TouchVoiceGroupColors.subText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Image.asset(
                    TouchVoiceGroupAssets.rocketGreen,
                    width: 15.w,
                    height: 20.h,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Image.asset(TouchVoiceGroupAssets.onMic, width: 16.w, height: 16.w),
                SizedBox(height: 6.h),
                Text(
                  '${room.achievementCount}',
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
}
