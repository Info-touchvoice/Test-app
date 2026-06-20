import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/view/screens/dashboard/profile_dashboard_screen.dart';
import 'package:tiki/view/screens/reels/reels_home_screen.dart';
import 'package:tiki/view/screens/reels/feed/videoutils/video.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';
import 'package:tiki/view_model/ranking_controller.dart';
import 'package:tiki/view_model/userViewModel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tiki/services/banner_popup_service.dart';

import '../../parse/UserModel.dart';
import '../../utils/Utils.dart';
import '../../utils/constants/app_constants.dart';
import '../../view_model/chat_list_controller.dart';
import '../../view_model/communityController.dart';
import '../../view_model/global_live_stream_controller.dart';
import '../../view_model/home_nav_controller.dart';
import '../../view_model/storeController.dart';
import '../../view_model/subscription_model.dart';
import 'chat/chat_display_screen.dart';
import 'games/touchvoice_games_constants.dart';
import 'games/touchvoice_games_home_screen.dart';
import 'home/home_screen/home_screen.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  static const _navHome = 0;
  static const _navMemories = 1;
  static const _navGames = 2;
  static const _navChat = 3;
  static const _navProfile = 4;

  int _selectedIndex = _navHome;
  UserModel? currentUser;
  late final List<Widget> _screens;
  late UserViewModel userViewModel = Get.find();
  RankingViewModel rankingViewModel = Get.put(RankingViewModel());
  ChatListViewModel chatListViewModel = Get.put(ChatListViewModel());
  StoreController storeController = Get.put(StoreController());
  SubscriptionViewModel subscriptionViewModel =
      Get.put(SubscriptionViewModel());
  final CommunityController<VideoInfo> communityController =
      Get.put(CommunityController<VideoInfo>(), permanent: true);
  GlobalLiveStreamViewModel globalLiveStreamViewModel =
      Get.put(GlobalLiveStreamViewModel());
  HomeNavController homeNav = Get.put(HomeNavController());
  bool _didRunOneTimeSetup = false;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    currentUser = userViewModel.currentUser;

    _screens = [
      HomeView(),
      ReelsHomeScreen(),
      const TouchVoiceGamesHomeScreen(),
      const ChatView(),
      const ProfileDashBoardScreen(),
    ];

    userViewModel.getFollowers();

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _didRunOneTimeSetup) return;
      _didRunOneTimeSetup = true;

      final device = userViewModel.currentUser.getDevice;
      if (device == null || device.isEmpty) {
        // ignore: unawaited_futures
        userViewModel.getDeviceName(context);
      }

      // ignore: unawaited_futures
      BannerPopupService.showOnAppStartIfNeeded();
    });
  }

  void _onItemTapped(int index) {
    if (index == _navHome) {
      homeNav.goToRelatedTab();
    }
    if (index == _navProfile) {
      userViewModel.showFullDetailView = false;
    }
    setState(() {
      rankingViewModel.showTrophyScreen.value = false;
      _selectedIndex = index;
    });
  }

  static const Color _navGold = Color(0xFFFFD76A);
  static const Color _navGoldLight = Color(0xFFFFF0C2);
  static const Color _navInactive = Color(0xB3FFFFFF);

  String? _navAssetIcon(int index, bool isSelected) {
    if (index == _navHome) {
      return isSelected
          ? AppImagePath.hiloNavHomeSelected
          : AppImagePath.hiloNavHomeUnselected;
    }
    return null;
  }

  String _navSvgFallback(int index) {
    switch (index) {
      case _navHome:
        return AppImagePath.bottomNavHomeIcon;
      case _navMemories:
        return AppImagePath.bottomNavExploreIcon;
      case _navChat:
        return AppImagePath.bottomNavChatIcon;
      case _navProfile:
      default:
        return AppImagePath.bottomNavProfileIcon;
    }
  }

  Widget _navIconWidget(int index, bool isSelected) {
    final size = isSelected ? 32.w : 26.w;

    Widget icon;
    if (index == _navMemories) {
      icon = _memoriesReelIcon(isSelected, size);
    } else {
      final asset = _navAssetIcon(index, isSelected);
      icon = asset != null
          ? Image.asset(
              asset,
              width: size,
              height: size,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, __, ___) =>
                  _navSvgIcon(index, isSelected, size),
            )
          : _navSvgIcon(index, isSelected, size);
    }

    if (!isSelected) return icon;

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: _navGold.withOpacity(0.35),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: icon,
    );
  }

  Widget _memoriesReelIcon(bool isSelected, double size) {
    final color = isSelected ? _navGold : _navInactive;
    final frameW = size * 0.62;
    final frameH = size * 0.88;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: frameW,
            height: frameH,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * 0.14),
              border: Border.all(color: color, width: 2),
            ),
          ),
          Icon(
            Icons.play_arrow_rounded,
            color: color,
            size: size * 0.42,
          ),
        ],
      ),
    );
  }

  Widget _navSvgIcon(int index, bool isSelected, double size) {
    return SvgPicture.asset(
      _navSvgFallback(index),
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(
        isSelected ? _navGold : _navInactive,
        BlendMode.srcIn,
      ),
    );
  }

  Color _navLabelColor(bool isSelected) =>
      isSelected ? _navGoldLight : _navInactive;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: BaseScaffold(
          resizeToAvoidBottomInset: false,
          topSafeArea: _selectedIndex == _navMemories ||
              _selectedIndex == _navHome ||
              _selectedIndex == _navProfile
              ? true
              : null,
          body: Stack(
            children: [
              _screens[_selectedIndex],
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomNav(context),
              ),
            ],
          ),
        ));
  }

  Widget _buildBottomNav(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImagePath.bottomNavTouchVoiceBg),
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
        border: Border(
          top: BorderSide(color: _navGold.withOpacity(0.35), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.2),
              Colors.black.withOpacity(0.55),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SizedBox(
            height: 74.h,
            child: Row(
              children: [
                Expanded(child: buildNavItem(_navHome, 'Home')),
                Expanded(child: buildNavItem(_navMemories, 'Memories')),
                Expanded(child: _buildGamesNavItem()),
                Expanded(child: buildNavItem(_navChat, 'Chat')),
                Expanded(child: buildNavItem(_navProfile, 'Profile')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGamesNavItem() {
    final isSelected = _selectedIndex == _navGames;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onItemTapped(_navGames),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: isSelected ? 50.w : 44.w,
            height: isSelected ? 50.w : 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isSelected
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFF0C2),
                        Color(0xFFFFD76A),
                        Color(0xFFC8942A),
                      ],
                    )
                  : null,
              color: isSelected ? null : Colors.black.withOpacity(0.25),
              border: Border.all(
                color: isSelected ? _navGoldLight : _navGold.withOpacity(0.45),
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: _navGold.withOpacity(0.5),
                        blurRadius: 14,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            padding: EdgeInsets.all(isSelected ? 8.w : 7.w),
            child: Image.asset(
              isSelected
                  ? TouchVoiceGamesAssets.navGameSelected
                  : TouchVoiceGamesAssets.navGameUnselected,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Game',
            style: SafeGoogleFont(
              'SFProDisplay',
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: _navLabelColor(isSelected),
              shadows: isSelected
                  ? [
                      Shadow(
                        color: _navGold.withOpacity(0.6),
                        blurRadius: 6,
                      ),
                    ]
                  : null,
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget buildNavItem(int index, String label) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 38.h,
            child: Center(child: _navIconWidget(index, isSelected)),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: SafeGoogleFont(
              'SFProDisplay',
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: _navLabelColor(isSelected),
              shadows: isSelected
                  ? [
                      Shadow(
                        color: _navGold.withOpacity(0.6),
                        blurRadius: 6,
                      ),
                    ]
                  : null,
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

/// Legacy bottom-nav shape used by [BaseScaffold] when `bottomNavigationBar` is true.
class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff252626)
      ..style = PaintingStyle.fill;
    final path = Path()..moveTo(0, 20);

    final borderPaint = Paint()
      ..color = const Color(0xff454646)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    path.quadraticBezierTo(size.width * 0.40, 5, size.width * 0.34, 7);
    path.quadraticBezierTo(size.width * 0.40, 2, size.width * 0.40, 20);
    path.arcToPoint(
      Offset(size.width * 0.60, 20),
      radius: const Radius.circular(10.0),
      clockwise: false,
    );

    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 4);
    path.quadraticBezierTo(size.width * 0.60, 2, size.width, 20);
    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);
    path.close();
    canvas.drawShadow(path, Colors.black.withOpacity(0.10), 20, true);

    canvas.drawPath(path, borderPaint);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
