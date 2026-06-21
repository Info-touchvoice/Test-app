import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/typography.dart';
import '../../../../../view_model/trending_controller.dart';
import '../../../../widgets/region_widgets.dart';
import '../touchvoice_group_constants.dart';

/// Discover tab: countries, gift wall, broadcast, activities, events.
class TouchVoiceDiscoverTab extends StatefulWidget {
  const TouchVoiceDiscoverTab({Key? key}) : super(key: key);

  @override
  State<TouchVoiceDiscoverTab> createState() => _TouchVoiceDiscoverTabState();
}

class _TouchVoiceDiscoverTabState extends State<TouchVoiceDiscoverTab> {
  final TrendingViewModel trendingViewModel = Get.put(TrendingViewModel());

  @override
  void initState() {
    super.initState();
    trendingViewModel.loadLive();
  }

  Future<void> _refresh() async {
    await trendingViewModel.loadLive();
    if (trendingViewModel.chosenCountry.value.isNotEmpty) {
      trendingViewModel.updateListForChosenCountry(
          trendingViewModel.chosenCountry.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      color: TouchVoiceGroupColors.brandPurple,
      child: Obx(() {
        final hasCountry = trendingViewModel.chosenCountry.value.isNotEmpty;
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          children: [
            SizedBox(height: 8.h),
            if (!hasCountry) ...[
              RegionWidget(),
              SizedBox(height: 12.h),
              _featuredCountryCard(),
              SizedBox(height: 14.h),
              _giftWallSection(),
              SizedBox(height: 14.h),
              _broadcastSection(),
              SizedBox(height: 14.h),
              _activitiesSection(),
              SizedBox(height: 14.h),
            ] else ...[
              _selectedCountryHeader(),
              SizedBox(height: 12.h),
            ],
            _eventsSection(),
            SizedBox(height: 80.h),
          ],
        );
      }),
    );
  }

  Widget _sectionHeader(String title, {VoidCallback? onMore}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: sfProDisplayMedium.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: TouchVoiceGroupColors.sectionTitle,
            ),
          ),
        ),
        if (onMore != null)
          GestureDetector(
            onTap: onMore,
            child: Row(
              children: [
                Text(
                  'More',
                  style: sfProDisplayRegular.copyWith(
                    fontSize: 12.sp,
                    color: TouchVoiceGroupColors.subText,
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 12.sp, color: TouchVoiceGroupColors.subText),
              ],
            ),
          ),
      ],
    );
  }

  Widget _featuredCountryCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: SizedBox(
        height: 72.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(TouchVoiceGroupAssets.discoverCountryBg, fit: BoxFit.cover),
            Positioned(
              right: 8.w,
              top: 0,
              bottom: 0,
              child: Image.asset(
                TouchVoiceGroupAssets.discoverCountryStar,
                width: 75.w,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Country',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: List.generate(
                      3,
                      (i) => Padding(
                        padding: EdgeInsets.only(right: 6.w),
                        child: CircleAvatar(
                          radius: 16.r,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person,
                              size: 16.sp, color: Colors.white),
                        ),
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
  }

  Widget _giftWallSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Gift Wall'),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Image.asset(
            TouchVoiceGroupAssets.discoverGiftBg,
            height: 73.h,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _broadcastSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Broadcast', onMore: () {}),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Image.asset(
            TouchVoiceGroupAssets.discoverBroadcastBg,
            height: 111.h,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _activitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Activities', onMore: () {}),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: SizedBox(
            height: 130.h,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: TouchVoiceGroupAssets.discoverActivitiesPhotoUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: TouchVoiceGroupColors.cardBg,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (_, __, ___) => Image.asset(
                TouchVoiceGroupAssets.discoverActivity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _selectedCountryHeader() {
    return GestureDetector(
      onTap: () {
        trendingViewModel.chosenCountry.value = '';
        trendingViewModel.chosenCountryFlag.value = '';
      },
      child: Row(
        children: [
          Text(
            trendingViewModel.chosenCountry.value,
            style: sfProDisplayMedium.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: TouchVoiceGroupColors.titleText,
            ),
          ),
          if (trendingViewModel.chosenCountryFlag.value.isNotEmpty) ...[
            SizedBox(width: 12.w),
            SvgPicture.asset(
              trendingViewModel.chosenCountryFlag.value,
              height: 19.h,
              width: 26.w,
            ),
          ],
          SizedBox(width: 8.w),
          Icon(Icons.close, size: 16.sp, color: TouchVoiceGroupColors.subText),
        ],
      ),
    );
  }

  Widget _eventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event',
          style: sfProDisplayMedium.copyWith(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: TouchVoiceGroupColors.sectionTitle,
          ),
        ),
        SizedBox(height: 8.h),
        ...TouchVoiceGroupAssets.eventBannerAssets.map(_eventBannerTile),
      ],
    );
  }

  Widget _eventBannerTile(String assetPath) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: SizedBox(
          height: 120.h,
          width: double.infinity,
          child: Image.asset(
            assetPath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: TouchVoiceGroupColors.cardBg,
              alignment: Alignment.center,
              child: Icon(Icons.live_tv,
                  size: 36.sp, color: TouchVoiceGroupColors.subText),
            ),
          ),
        ),
      ),
    );
  }
}
