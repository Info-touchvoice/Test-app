import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../parse/UserModel.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/typography.dart';
import '../../../../view_model/home_nav_controller.dart';
import 'touchvoice_group_constants.dart';
import 'widgets/touchvoice_discover_tab.dart';
import 'widgets/touchvoice_new_tab.dart';
import 'widgets/touchvoice_popular_tab.dart';
import 'widgets/touchvoice_related_tab.dart';

/// TouchVoice Group tab layout: Related · Popular · Discover · New.
class TouchVoiceGroupHomeScreen extends StatefulWidget {
  final UserModel? currentUser;

  const TouchVoiceGroupHomeScreen({Key? key, this.currentUser}) : super(key: key);

  @override
  State<TouchVoiceGroupHomeScreen> createState() => _TouchVoiceGroupHomeScreenState();
}

class _TouchVoiceGroupHomeScreenState extends State<TouchVoiceGroupHomeScreen>
    with SingleTickerProviderStateMixin {
  static const _tabLabels = ['Related', 'Popular', 'Discover', 'New'];

  late final TabController _tabController;

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

    return Container(
      width: double.infinity,
      height: topInset + 56.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImagePath.bottomNavTouchVoiceBg),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.15),
              Colors.black.withOpacity(0.45),
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
            ],
          ),
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
  });

  final int index;
  final String label;
  final TabController controller;

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
                          color: const Color(0xFFFFD76A).withOpacity(0.55),
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
