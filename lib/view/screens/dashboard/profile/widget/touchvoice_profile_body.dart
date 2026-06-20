import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../parse/UserModel.dart';
import '../../../../../utils/constants/typography.dart';
import '../../../../../utils/routes/app_routes.dart';
import '../../../../../view_model/userViewModel.dart';
import '../touchvoice_profile_constants.dart';
import 'profile_reels_section.dart';
import 'profile_reels_tab_bar.dart';
import 'touchvoice_profile_sections.dart';

class TouchVoiceProfileBody extends StatefulWidget {
  const TouchVoiceProfileBody({Key? key, required this.user}) : super(key: key);

  final UserModel? user;

  @override
  State<TouchVoiceProfileBody> createState() => _TouchVoiceProfileBodyState();
}

class _TouchVoiceProfileBodyState extends State<TouchVoiceProfileBody> {
  static const _tabs = ['Profile', 'Props', 'Memories'];
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -TouchVoiceProfileLayout.whiteCardOverlap.h),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: TouchVoiceProfileColors.bodyBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: TouchVoiceProfileLayout.statsTopPadding.h),
            _statsRow(),
            SizedBox(height: 22.h),
            _tabBar(),
            SizedBox(height: 14.h),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: TouchVoiceProfileLayout.horizontalPadding.w,
              ),
              child: _tabContent(),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _statsRow() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: TouchVoiceProfileLayout.horizontalPadding.w,
      ),
      child: Row(
        children: [
          _statItem(
            '${widget.user?.getFollowing?.length ?? 0}',
            'Follow',
            () => Get.toNamed(
              AppRoutes.userSubscriptionsList,
              arguments: {'userModel': widget.user},
            ),
          ),
          SizedBox(width: 24.w),
          _statItem(
            null,
            'Fans',
            () => Get.toNamed(
              AppRoutes.userSubscribersList,
              arguments: {'userModel': widget.user},
            ),
            countFuture: Get.find<UserViewModel>()
                .getFollowersCountForUser(widget.user?.objectId),
          ),
          SizedBox(width: 24.w),
          _statItem('0', 'Visitor', null),
        ],
      ),
    );
  }

  Widget _statItem(
    String? count,
    String label,
    VoidCallback? onTap, {
    Future<int>? countFuture,
  }) {
    final countStyle = sfProDisplayMedium.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w800,
      color: TouchVoiceProfileColors.titleText,
    );
    final labelStyle = sfProDisplayRegular.copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: TouchVoiceProfileColors.subText,
    );

    Widget countText(String value) {
      return Text(value, style: countStyle);
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (countFuture != null)
            FutureBuilder<int>(
              future: countFuture,
              builder: (context, snapshot) =>
                  countText('${snapshot.data ?? 0}'),
            )
          else
            countText(count ?? '0'),
          SizedBox(width: 5.w),
          Text(label, style: labelStyle),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: TouchVoiceProfileLayout.horizontalPadding.w,
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final selected = _selectedTab == i;
          return Padding(
            padding: EdgeInsets.only(right: i < _tabs.length - 1 ? 28.w : 0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _tabs[i],
                    style: sfProDisplayMedium.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? TouchVoiceProfileColors.tabActive
                          : TouchVoiceProfileColors.tabInactive,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 3.h,
                    width: selected ? 40.w : 0,
                    decoration: BoxDecoration(
                      color: TouchVoiceProfileColors.brandPurple,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _tabContent() {
    switch (_selectedTab) {
      case 1:
        return _emptyTab('Props coming soon');
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileReelsTabBar(),
            SizedBox(height: 12.h),
            const Divider(height: 1, color: TouchVoiceProfileColors.sectionDivider),
            const ProfileReelsSection(),
          ],
        );
      default:
        return const TouchVoiceProfileSections();
    }
  }

  Widget _emptyTab(String message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 48.h),
      child: Center(
        child: Text(
          message,
          style: sfProDisplayRegular.copyWith(
            fontSize: 14.sp,
            color: TouchVoiceProfileColors.subText,
          ),
        ),
      ),
    );
  }
}
