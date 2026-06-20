import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tiki/helpers/quick_actions.dart';
import 'package:tiki/parse/LiveStreamingModel.dart';
import 'package:tiki/parse/UserModel.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/theme/colors_constant.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/widgets/hilo_audio_room_info_constants.dart';
import 'package:tiki/view/screens/live/single_live_streaming/single_audience_live/widgets/audience_list_sheet.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_setting_screen.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_support_screen.dart';
import 'package:tiki/view/screens/live/zegocloud/zim_zego_sdk/internal/business/business_define.dart';
import 'package:tiki/view_model/live_controller.dart';

/// Hilo 4.16.0 `dialog_room_info2.xml` + `fragment_room_profile.xml`.
class HiloAudioRoomInfoSheet extends StatefulWidget {
  final LiveStreamingModel live;
  final UserModel author;

  const HiloAudioRoomInfoSheet({
    Key? key,
    required this.live,
    required this.author,
  }) : super(key: key);

  static Future<void> show(BuildContext context) {
    final liveViewModel = Get.find<LiveViewModel>();
    final live = liveViewModel.liveStreamingModel;
    final author = live.getAuthor;
    if (author == null) return Future.value();

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HiloAudioRoomInfoSheet(live: live, author: author),
    );
  }

  @override
  State<HiloAudioRoomInfoSheet> createState() => _HiloAudioRoomInfoSheetState();
}

class _HiloAudioRoomInfoSheetState extends State<HiloAudioRoomInfoSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Get.find<LiveViewModel>().fetchViewersList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String get _groupName {
    final title = widget.live.getTitle?.trim();
    if (title != null && title.isNotEmpty) return title;
    return widget.author.getFullName ?? 'Touch Voice';
  }

  String get _introduction {
    final goal = widget.live.getGoalTile?.trim();
    if (goal != null && goal.isNotEmpty) return goal;
    final bio = widget.author.getBio?.trim();
    if (bio != null && bio.isNotEmpty) return bio;
    return '$_groupName Room';
  }

  String get _announcement {
    final roomText = widget.live.getRoomAnnouncement?.trim();
    if (roomText != null && roomText.isNotEmpty) return roomText;
    return 'Welcome to Touch Voice!';
  }

  String? get _avatarUrl => widget.author.getAvatar?.url;

  String? get _coverUrl {
    final bg = widget.live.getBackgroundImage?.url;
    if (bg != null && bg.isNotEmpty) return bg;
    final image = widget.live.getImage?.url;
    if (image != null && image.isNotEmpty) return image;
    return _avatarUrl;
  }

  bool get _isHost {
    final liveViewModel = Get.find<LiveViewModel>();
    return liveViewModel.role == ZegoLiveRole.host;
  }

  int get _contribution {
    return widget.live.getTotalCoins ??
        widget.live.getAuthorTotalDiamonds ??
        0;
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.of(context).size.height * 0.78;

    return Container(
      height: sheetHeight,
      decoration: const BoxDecoration(
        color: HiloAudioRoomInfoColors.sheetBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          _buildIdentity(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ProfileTab(
                  live: widget.live,
                  author: widget.author,
                  contribution: _contribution,
                  introduction: _introduction,
                  announcement: _announcement,
                  isHost: _isHost,
                  onSetting: _openSettings,
                ),
                const _ActivitiesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openSettings() {
    Navigator.pop(context);
    HiloRoomSettingScreen.open(context);
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 145.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: SizedBox(
              height: 145.h,
              width: double.infinity,
              child: _coverUrl != null
                  ? ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: CachedNetworkImage(
                        imageUrl: _coverUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 145.h,
                      ),
                    )
                  : Container(color: const Color(0xFF1A1530)),
            ),
          ),
          Positioned(
            top: 10.h,
            left: 10.w,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: Text(
                  'Close',
                  style: sfProDisplayRegular.copyWith(
                    fontSize: 14.sp,
                    color: HiloAudioRoomInfoColors.body,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 5.h,
            right: 5.w,
            child: IconButton(
              padding: EdgeInsets.all(12.w),
              icon: _HiloAssetIcon(
                asset: HiloAudioRoomInfoAssets.report,
                width: 22.w,
                height: 22.w,
                fallback: Icons.report_outlined,
              ),
              onPressed: () {},
            ),
          ),
          Positioned(
            left: 14.w,
            bottom: -48.h,
            child: _GroupAvatar(url: _avatarUrl),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentity() {
    final flagPath = QuickActions.getCountryFlag(widget.author);
    final uid = widget.author.getUid;

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 58.h, 14.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _groupName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: sfProDisplayMedium.copyWith(
              fontSize: 15.sp,
              color: HiloAudioRoomInfoColors.body,
            ),
          ),
          SizedBox(height: 7.h),
          Row(
            children: [
              if (flagPath.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2.r),
                    child: SvgPicture.asset(
                      flagPath,
                      width: 22.w,
                      height: 14.h,
                      fit: BoxFit.cover,
                      placeholderBuilder: (_) => SizedBox(
                        width: 22.w,
                        height: 14.h,
                      ),
                    ),
                  ),
                ),
              Flexible(
                child: Text(
                  uid != null ? 'ID: $uid' : '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sfProDisplayRegular.copyWith(
                    fontSize: 12.sp,
                    color: HiloAudioRoomInfoColors.idText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: EdgeInsets.only(left: 3.w, top: 25.h),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: HiloAudioRoomInfoColors.tabActive,
        indicatorWeight: 2,
        labelColor: HiloAudioRoomInfoColors.tabActive,
        unselectedLabelColor: HiloAudioRoomInfoColors.tabInactive,
        labelStyle: sfProDisplayMedium.copyWith(fontSize: 15.sp),
        unselectedLabelStyle: sfProDisplayRegular.copyWith(fontSize: 15.sp),
        tabs: const [
          Tab(text: 'Profile'),
          Tab(text: 'Activities'),
        ],
      ),
    );
  }
}

class _HiloAssetIcon extends StatelessWidget {
  final String asset;
  final double width;
  final double height;
  final IconData fallback;

  const _HiloAssetIcon({
    Key? key,
    required this.asset,
    required this.width,
    required this.height,
    required this.fallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(
        fallback,
        size: width,
        color: Colors.white70,
      ),
    );
  }
}

class _GroupAvatar extends StatelessWidget {
  final String? url;

  const _GroupAvatar({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 97.w,
      height: 97.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.white24, width: 1),
        color: const Color(0xFF1A1530),
      ),
      clipBehavior: Clip.antiAlias,
      child: url != null && url!.isNotEmpty
          ? CachedNetworkImage(imageUrl: url!, fit: BoxFit.cover)
          : Icon(Icons.person, color: Colors.white54, size: 40.sp),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  final LiveStreamingModel live;
  final UserModel author;
  final int contribution;
  final String introduction;
  final String announcement;
  final bool isHost;
  final VoidCallback onSetting;

  const _ProfileTab({
    Key? key,
    required this.live,
    required this.author,
    required this.contribution,
    required this.introduction,
    required this.announcement,
    required this.isHost,
    required this.onSetting,
  }) : super(key: key);

  List<UserModel> _collectMembers(LiveViewModel vm) {
    final members = <UserModel>[author];
    final authorUid = author.getUid;
    for (final user in vm.viewerList) {
      if (user is! UserModel) continue;
      if (user.getUid == authorUid) continue;
      members.add(user);
    }
    return members;
  }

  void _openMemberList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: AppColors.grey500,
      builder: (_) => Wrap(children: [AudienceListSheet()]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveViewModel>(
      builder: (vm) {
        final members = _collectMembers(vm);
        final topAvatars = vm.hostGiftersAvatar;

        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GroupMemberHeader(
                count: members.length,
                onTap: () => _openMemberList(context),
              ),
              _GroupMemberAvatarRow(
                members: members,
                hostUid: author.getUid,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15.w, 18.h, 15.w, 0),
                child: Text(
                  'Room Contribution',
                  style: sfProDisplayRegular.copyWith(
                    fontSize: 12.sp,
                    color: HiloAudioRoomInfoColors.label,
                  ),
                ),
              ),
              _GroupContributionRow(
                contribution: contribution,
                topAvatars: topAvatars,
                onTap: () {},
              ),
          _MenuRow(
            iconAsset: HiloAudioRoomInfoAssets.groupSupport,
            fallbackIcon: Icons.diamond_outlined,
            label: 'Room support',
            onTap: () {
              Navigator.pop(context);
              HiloRoomSupportScreen.open(context);
            },
          ),
              _MenuRow(
                iconAsset: HiloAudioRoomInfoAssets.groupActivity,
                fallbackIcon: Icons.flag_outlined,
                label: 'Room Activity',
                onTap: () {},
              ),
              _TextSection(title: 'Room Introduction', content: introduction),
              _TextSection(
                title: 'Room Announcement',
                content: announcement,
                topSpacing: 27,
              ),
              if (isHost) ...[
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: GestureDetector(
                    onTap: onSetting,
                    child: Container(
                      height: 44.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      child: Text(
                        'Setting',
                        style: sfProDisplayMedium.copyWith(
                          fontSize: 16.sp,
                          color: HiloAudioRoomInfoColors.settingButtonText,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _GroupMemberHeader extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _GroupMemberHeader({
    Key? key,
    required this.count,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Room Member($count)',
                style: sfProDisplayRegular.copyWith(
                  fontSize: 12.sp,
                  color: HiloAudioRoomInfoColors.label,
                ),
              ),
            ),
            _HiloAssetIcon(
              asset: HiloAudioRoomInfoAssets.arrowRight,
              width: 6.w,
              height: 10.h,
              fallback: Icons.chevron_right,
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupMemberAvatarRow extends StatelessWidget {
  final List<UserModel> members;
  final int? hostUid;

  const _GroupMemberAvatarRow({
    Key? key,
    required this.members,
    required this.hostUid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(15.w, 9.h, 15.w, 0),
        physics: const BouncingScrollPhysics(),
        itemCount: members.length,
        separatorBuilder: (_, __) => SizedBox(width: 17.w),
        itemBuilder: (_, index) {
          final member = members[index];
          final isHost = member.getUid == hostUid;
          return _GroupMemberAvatar(user: member, isHost: isHost);
        },
      ),
    );
  }
}

class _GroupMemberAvatar extends StatelessWidget {
  final UserModel user;
  final bool isHost;

  const _GroupMemberAvatar({
    Key? key,
    required this.user,
    required this.isHost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatarUrl = user.getAvatar?.url;

    return SizedBox(
      width: 42.w,
      height: 42.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 21.r,
            backgroundColor: const Color(0xFF1A1530),
            backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                ? CachedNetworkImageProvider(avatarUrl)
                : null,
            child: (avatarUrl == null || avatarUrl.isEmpty)
                ? Icon(Icons.person, color: Colors.white54, size: 22.sp)
                : null,
          ),
          if (isHost)
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF7B61FF),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.person, size: 7.sp, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class _GroupContributionRow extends StatelessWidget {
  final int contribution;
  final List<String> topAvatars;
  final VoidCallback onTap;

  const _GroupContributionRow({
    Key? key,
    required this.contribution,
    required this.topAvatars,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15.w, 4.h, 15.w, 0),
        child: Row(
          children: [
            _HiloAssetIcon(
              asset: HiloAudioRoomInfoAssets.trophy,
              width: 18.w,
              height: 18.w,
              fallback: Icons.emoji_events_outlined,
            ),
            SizedBox(width: 6.w),
            Text(
              contribution.toString(),
              style: sfProDisplayRegular.copyWith(
                fontSize: 12.sp,
                color: HiloAudioRoomInfoColors.body,
              ),
            ),
            const Spacer(),
            if (topAvatars.isNotEmpty)
              _TopContributorAvatars(avatars: topAvatars.take(3).toList()),
            _HiloAssetIcon(
              asset: HiloAudioRoomInfoAssets.arrowRight,
              width: 6.w,
              height: 10.h,
              fallback: Icons.chevron_right,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopContributorAvatars extends StatelessWidget {
  final List<String> avatars;

  const _TopContributorAvatars({Key? key, required this.avatars})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(avatars.length, (index) {
        final reversedIndex = avatars.length - 1 - index;
        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 0 : 4.w),
          child: SizedBox(
            width: 36.w,
            height: 36.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 13.5.r,
                  backgroundColor: const Color(0xFF1A1530),
                  backgroundImage: NetworkImage(avatars[reversedIndex]),
                ),
                SvgPicture.asset(
                  _badgeAsset(reversedIndex),
                  width: 36.w,
                  height: 36.w,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  String _badgeAsset(int rankIndex) {
    switch (rankIndex) {
      case 0:
        return 'assets/svg/badge1.svg';
      case 1:
        return 'assets/svg/badge2.svg';
      default:
        return 'assets/svg/badge3.svg';
    }
  }
}

class _ActivitiesTab extends StatelessWidget {
  const _ActivitiesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No activities yet',
        style: sfProDisplayRegular.copyWith(
          fontSize: 13.sp,
          color: HiloAudioRoomInfoColors.label,
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final String iconAsset;
  final IconData fallbackIcon;
  final String label;
  final VoidCallback onTap;

  const _MenuRow({
    Key? key,
    required this.iconAsset,
    required this.fallbackIcon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 53.h,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 0),
          child: Row(
            children: [
              _HiloAssetIcon(
                asset: iconAsset,
                width: 19.w,
                height: 19.w,
                fallback: fallbackIcon,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sfProDisplayRegular.copyWith(
                    fontSize: 13.sp,
                    color: HiloAudioRoomInfoColors.body,
                  ),
                ),
              ),
              _HiloAssetIcon(
                asset: HiloAudioRoomInfoAssets.arrowRight,
                width: 6.w,
                height: 10.h,
                fallback: Icons.chevron_right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextSection extends StatelessWidget {
  final String title;
  final String content;
  final double topSpacing;

  const _TextSection({
    Key? key,
    required this.title,
    required this.content,
    this.topSpacing = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.w, topSpacing.h, 15.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: sfProDisplayRegular.copyWith(
              fontSize: 12.sp,
              color: HiloAudioRoomInfoColors.label,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            content,
            style: sfProDisplayRegular.copyWith(
              fontSize: 12.sp,
              color: HiloAudioRoomInfoColors.body,
            ),
          ),
        ],
      ),
    );
  }
}
