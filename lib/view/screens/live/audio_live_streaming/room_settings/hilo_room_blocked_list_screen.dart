import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tiki/helpers/quick_actions.dart';
import 'package:tiki/parse/UserModel.dart';
import 'package:tiki/utils/constants/status.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_setting_constants.dart';
import 'package:tiki/view_model/live_controller.dart';

class HiloRoomBlockedListScreen extends StatefulWidget {
  const HiloRoomBlockedListScreen({Key? key}) : super(key: key);

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HiloRoomBlockedListScreen()),
    );
  }

  @override
  State<HiloRoomBlockedListScreen> createState() =>
      _HiloRoomBlockedListScreenState();
}

class _HiloRoomBlockedListScreenState extends State<HiloRoomBlockedListScreen> {
  final LiveViewModel _vm = Get.find();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _vm.status = Status.Loading;
    _vm.blockUserList(_vm.liveStreamingModel);
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<UserModel> get _filteredUsers {
    final users = _vm.blockList.whereType<UserModel>().toList();
    if (_query.isEmpty) return users;
    final q = _query.toLowerCase();
    return users.where((user) {
      final uid = user.getUid?.toString() ?? '';
      final name = user.getFullName?.toLowerCase() ?? '';
      return uid.contains(q) || name.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HiloRoomSettingColors.bodyBg,
      appBar: AppBar(
        backgroundColor: HiloRoomSettingColors.toolbarBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Blocked List',
          style: sfProDisplayMedium.copyWith(fontSize: 15.sp, color: Colors.white),
        ),
      ),
      body: GetBuilder<LiveViewModel>(
        builder: (_) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 8.h),
                child: TextField(
                  controller: _searchController,
                  style: sfProDisplayRegular.copyWith(fontSize: 14.sp),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search user ID',
                    hintStyle: sfProDisplayRegular.copyWith(
                      fontSize: 14.sp,
                      color: Colors.black45,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.black45),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                ),
              ),
              Expanded(
                child: _vm.status == Status.Loading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredUsers.isEmpty
                        ? _EmptyBlockedState()
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 8.h,
                            ),
                            itemCount: _filteredUsers.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12.h),
                            itemBuilder: (_, index) {
                              final user = _filteredUsers[index];
                              return _BlockedUserRow(
                                user: user,
                                onUnblock: () {
                                  _vm.removeBlockUser(user.getUid!);
                                  _vm.blockList.remove(user);
                                  _vm.update();
                                  setState(() {});
                                },
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyBlockedState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 72.w,
                height: 72.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF7B61FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.sentiment_satisfied_alt,
                    size: 40.sp, color: Colors.white),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 56.w,
                height: 56.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF7BA1C),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.sentiment_very_satisfied,
                    size: 30.sp, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'No blocked users',
            style: sfProDisplayRegular.copyWith(
              fontSize: 14.sp,
              color: HiloRoomSettingColors.hint,
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockedUserRow extends StatelessWidget {
  final UserModel user;
  final VoidCallback onUnblock;

  const _BlockedUserRow({required this.user, required this.onUnblock});

  @override
  Widget build(BuildContext context) {
    final avatarUrl = user.getAvatar?.url;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: HiloRoomSettingColors.rowBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: const Color(0xFF1A1530),
            backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                ? CachedNetworkImageProvider(avatarUrl)
                : null,
            child: (avatarUrl == null || avatarUrl.isEmpty)
                ? Icon(Icons.person, color: Colors.white54, size: 22.sp)
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.getFullName ?? 'User',
                  style: sfProDisplayMedium.copyWith(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      'ID: ${user.getUid ?? ''}',
                      style: sfProDisplayRegular.copyWith(
                        fontSize: 12.sp,
                        color: HiloRoomSettingColors.hint,
                      ),
                    ),
                    if (user.getHideMyLocation == false) ...[
                      SizedBox(width: 8.w),
                      SizedBox(
                        width: 22.w,
                        height: 14.h,
                        child: QuickActions.getCountryFlag(user).isNotEmpty
                            ? SvgPicture.asset(
                                QuickActions.getCountryFlag(user),
                                fit: BoxFit.cover,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onUnblock,
            child: Text(
              'Unblock',
              style: sfProDisplayMedium.copyWith(
                fontSize: 13.sp,
                color: HiloRoomSettingColors.customBar,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
