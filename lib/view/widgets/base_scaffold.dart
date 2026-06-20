import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/configuration/app_configuration.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/theme/colors_constant.dart';
import '../screens/dashboard_screen.dart';

class BaseScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final bool resizeToAvoidBottomInset;
  final Widget body;
  final EdgeInsetsGeometry padding;
  final bool bottomNavigationBar;
  final bool safeArea;
  final bool? topSafeArea;
  final Widget? endDrawer;
  final bool extendBodyBehindAppBar;
  const BaseScaffold({
    Key? key,
    required this.body,
    this.padding = EdgeInsets.zero,
    this.appBar,
    this.bottomNavigationBar = false,
    this.safeArea = false,
    this.endDrawer,
    this.extendBodyBehindAppBar = false,
    this.topSafeArea,
    this.resizeToAvoidBottomInset = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (safeArea == false) {
      AppConfigurations.setSystemPreference(isBottomNav: bottomNavigationBar);
    }

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBGColor : AppColors.lightBGColor,
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 0.85,
            colors: isDark
                ? [
                    AppColors.darkBGShadeColor.withOpacity(0.95),
                    AppColors.darkBGColor,
                  ]
                : [
                    AppColors.lightShadeColor.withOpacity(0.95),
                    AppColors.lightBGColor,
                  ],
            stops: const [0.0, 1.0],
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          appBar: appBar,
          body: SafeArea(
            // NOTE: This project historically uses inverted SafeArea semantics:
            // - safeArea == true  => full-bleed (no SafeArea padding)
            // - safeArea == false => apply SafeArea padding on top/left/right (not bottom)
            //
            // Many screens (especially Reels) rely on this behavior, so we keep it.
            top: (topSafeArea ?? safeArea) ? false : true,
            bottom: false,
            left: safeArea ? false : true,
            right: safeArea ? false : true,
            child: Stack(
              children: [
                Padding(
                  padding: padding,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [Expanded(child: body)],
                  ),
                ),
                if (bottomNavigationBar) ...[
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: CustomPaint(
                        size: Size(double.infinity, 82.h),
                        foregroundPainter: BNBCustomPainter(),
                      )),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset(
                            AppImagePath.bottomNavHomeIcon,
                            height: 28.h,
                            width: 28.w,
                          ),
                          SvgPicture.asset(
                            AppImagePath.bottomNavExploreIcon,
                            height: 28.h,
                            width: 28.w,
                          ),
                          SizedBox(width: 30.w),
                          SvgPicture.asset(
                            AppImagePath.bottomNavChatIcon,
                            height: 28.h,
                            width: 28.w,
                          ),
                          SvgPicture.asset(
                            AppImagePath.bottomNavProfileIcon,
                            height: 28.h,
                            width: 28.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 35.h,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 30.w,
                        backgroundColor: Colors.orange.shade300,
                        child: Image.asset(
                          AppImagePath.cameraIcon,
                          height: 24.w,
                          width: 24.w,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          isAntiAlias: true,
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
          endDrawer: endDrawer,
        ),
      ),
    );
  }
}
