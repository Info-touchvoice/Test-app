import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helpers/quick_help.dart';
import '../../../../parse/UserModel.dart';
import '../../../../utils/constants/typography.dart';
import '../../../../utils/shared_manager.dart';
import '../../../../view_model/home_nav_controller.dart';
import '../../../../view_model/userViewModel.dart';
import 'touchvoice_group_constants.dart';
import 'touchvoice_home_header_theme.dart';
import 'widgets/touchvoice_discover_tab.dart';
import 'widgets/touchvoice_new_tab.dart';
import 'widgets/touchvoice_popular_tab.dart';
import 'widgets/touchvoice_related_tab.dart';

/// TouchVoice Group tab layout: Featured · Explore · Trending · Latest.
class TouchVoiceGroupHomeScreen extends StatefulWidget {
  final UserModel? currentUser;

  const TouchVoiceGroupHomeScreen({Key? key, this.currentUser})
      : super(key: key);

  @override
  State<TouchVoiceGroupHomeScreen> createState() =>
      _TouchVoiceGroupHomeScreenState();
}

class _TouchVoiceGroupHomeScreenState extends State<TouchVoiceGroupHomeScreen>
    with SingleTickerProviderStateMixin {
  static const _tabLabels = ['Featured', 'Explore', 'Trending', 'Latest'];

  late final TabController _tabController;
  String _headerThemeId = TouchVoiceHomeHeaderTheme.defaultTheme.id;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabLabels.length,
      vsync: this,
      initialIndex: 0,
    );
    _tabController.addListener(_onTabChanged);
    Get.find<HomeNavController>().setGroupTabIndex(0);
    _loadHeaderTheme();
  }

  Future<void> _loadHeaderTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeId = SharedManager().getHomeHeaderTheme(prefs);
    if (!mounted || themeId == _headerThemeId) return;
    setState(() {
      _headerThemeId = themeId;
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    Get.find<HomeNavController>().setGroupTabIndex(_tabController.index);
  }

  void _syncTabFromNav(int index) {
    if (_tabController.index == index) return;
    _tabController.animateTo(index);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeNavController>(
      builder: (homeNav) {
        if (_tabController.index != homeNav.groupTabIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _syncTabFromNav(homeNav.groupTabIndex);
          });
        }

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: Column(
            children: [
              _header(),
              Expanded(
                child: ColoredBox(
                  color: TouchVoiceGroupColors.bodyBg,
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      TouchVoiceRelatedTab(),
                      TouchVoicePopularTab(),
                      TouchVoiceDiscoverTab(),
                      TouchVoiceNewTab(),
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

  Widget _header() {
    final topInset = MediaQuery.of(context).padding.top;
    final headerTheme = TouchVoiceHomeHeaderTheme.resolve(_headerThemeId);

    return Container(
      width: double.infinity,
      height: topInset + 56.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            headerTheme.startColor,
            headerTheme.endColor,
          ],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          _HeaderGlowField(theme: headerTheme),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.08),
                  width: 0.6,
                ),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.black.withOpacity(0.08),
                  Colors.black.withOpacity(0.28),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: topInset, left: 4.w, right: 4.w),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56.h,
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        padding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
                        indicator: const BoxDecoration(),
                        splashFactory: NoSplash.splashFactory,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        tabs: [
                          for (var i = 0; i < _tabLabels.length; i++)
                            Tab(
                              child: _HeaderTabLabel(
                                index: i,
                                label: _tabLabels[i],
                                controller: _tabController,
                                glowColor: headerTheme.accentColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Image.asset(
                        TouchVoiceGroupAssets.search,
                        width: 24.w,
                        height: 24.w,
                      ),
                    ),
                  ),
                  _HeaderProfileAvatar(currentUser: _currentUser),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  UserModel? get _currentUser {
    if (widget.currentUser != null) return widget.currentUser;
    if (!Get.isRegistered<UserViewModel>()) return null;
    return Get.find<UserViewModel>().currentUser;
  }
}

class _HeaderGlowField extends StatelessWidget {
  const _HeaderGlowField({required this.theme});

  final TouchVoiceHomeHeaderTheme theme;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            right: -36.w,
            top: -34.h,
            child: _GlowOrb(
              size: 124.w,
              color: theme.accentColor.withOpacity(0.28),
            ),
          ),
          Positioned(
            left: -32.w,
            bottom: -48.h,
            child: _GlowOrb(
              size: 126.w,
              color: theme.endColor.withOpacity(0.34),
            ),
          ),
          Positioned(
            right: 80.w,
            bottom: 6.h,
            child: _GlowOrb(
              size: 22.w,
              color: Colors.white.withOpacity(0.22),
            ),
          ),
          Positioned(
            left: 122.w,
            top: 12.h,
            child: _GlowOrb(
              size: 9.w,
              color: Colors.white.withOpacity(0.24),
            ),
          ),
          Positioned(
            right: 138.w,
            top: 25.h,
            child: _GlowOrb(
              size: 6.w,
              color: theme.accentColor.withOpacity(0.34),
            ),
          ),
          Positioned(
            right: 8.w,
            bottom: 15.h,
            child: Transform.rotate(
              angle: -0.34,
              child: Container(
                width: 92.w,
                height: 22.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.12),
                    width: 0.8,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.16),
                      Colors.white.withOpacity(0.02),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withOpacity(0.0),
          ],
        ),
      ),
    );
  }
}

class _HeaderProfileAvatar extends StatelessWidget {
  const _HeaderProfileAvatar({required this.currentUser});

  final UserModel? currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.w, right: 8.w),
      child: Container(
        width: 32.w,
        height: 32.w,
        padding: EdgeInsets.all(1.5.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.92),
              const Color(0xFFFFD76A).withOpacity(0.72),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.24),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.16),
          backgroundImage: QuickHelp.getUserAvatarProvider(currentUser),
        ),
      ),
    );
  }
}

class _HeaderTabLabel extends StatelessWidget {
  const _HeaderTabLabel({
    required this.index,
    required this.label,
    required this.controller,
    required this.glowColor,
  });

  final int index;
  final String label;
  final TabController controller;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final anim =
            controller.animation?.value ?? controller.index.toDouble();
        final distance = (anim - index).abs();
        final scale = (1 - (distance * 0.18)).clamp(0.78, 1.0).toDouble();
        final opacity = (1 - (distance * 0.5)).clamp(0.4, 1.0).toDouble();

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: sfProDisplayMedium.copyWith(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                shadows: distance < 0.35
                    ? [
                        Shadow(
                          color: glowColor.withOpacity(0.55),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
