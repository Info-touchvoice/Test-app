import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../helpers/quick_help.dart';
import '../../../../../parse/UserModel.dart';
import '../../../../../utils/constants/typography.dart';
import '../../../../../utils/routes/app_routes.dart';
import '../touchvoice_profile_constants.dart';
import 'touchvoice_profile_badges.dart';

/// Hilo reference: dark banner, left column — avatar, name, ID, badges.
class TouchVoiceProfileHeader extends StatelessWidget {
  const TouchVoiceProfileHeader({Key? key, required this.user}) : super(key: key);

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final coverUrl = user?.getCover?.url;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: SizedBox(
        height: TouchVoiceProfileLayout.headerTotalHeight.h,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _banner(coverUrl),
            Positioned(
              left: TouchVoiceProfileLayout.horizontalPadding.w,
              right: TouchVoiceProfileLayout.horizontalPadding.w,
              top: topInset + 44.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _avatar(),
                  SizedBox(height: 14.h),
                  Text(
                    user?.getFullName ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: sfProDisplayMedium.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'ID: ${user?.getUid ?? ''}',
                    style: sfProDisplayRegular.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.88),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TouchVoiceProfileBadges(user: user),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _banner(String? coverUrl) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (coverUrl != null && coverUrl.isNotEmpty)
          CachedNetworkImage(
            imageUrl: coverUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => _gradientBanner(),
            errorWidget: (_, __, ___) => _gradientBanner(),
          )
        else
          _gradientBanner(),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.15),
                Colors.black.withOpacity(0.55),
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _gradientBanner() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            TouchVoiceProfileColors.headerTop,
            TouchVoiceProfileColors.headerBottom,
          ],
        ),
      ),
      child: Image.asset(
        TouchVoiceProfileAssets.topCover,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        opacity: const AlwaysStoppedAnimation(0.35),
      ),
    );
  }

  Widget _avatar() {
    return Container(
      width: TouchVoiceProfileLayout.avatarSize.w,
      height: TouchVoiceProfileLayout.avatarSize.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      clipBehavior: Clip.antiAlias,
      child: CircleAvatar(
        backgroundImage: QuickHelp.getUserAvatarProvider(user),
      ),
    );
  }
}

class TouchVoiceProfileTopActions extends StatelessWidget {
  const TouchVoiceProfileTopActions({Key? key, this.onBack}) : super(key: key);

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        if (onBack != null)
          Positioned(
            top: topInset + 8.h,
            left: TouchVoiceProfileLayout.horizontalPadding.w,
            child: _actionIcon(Icons.arrow_back_ios_new_rounded, onBack!),
          ),
        Positioned(
          top: topInset + 8.h,
          right: TouchVoiceProfileLayout.horizontalPadding.w,
          child: Row(
            children: [
              _actionIcon(
                Icons.edit_outlined,
                () => Get.toNamed(AppRoutes.editProfileScreen),
              ),
              SizedBox(width: 14.w),
              _actionIcon(
                Icons.notifications_outlined,
                () => Get.toNamed(
                  AppRoutes.notificationScreen,
                  arguments: {'otherProfile': false},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.white, size: 22.sp),
    );
  }
}
