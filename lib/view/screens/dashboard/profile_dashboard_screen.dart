import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/constants/app_constants.dart';
import 'package:tiki/utils/routes/app_routes.dart';
import 'package:tiki/view/screens/dashboard/profile/widget/dashboard_grid.dart';
import 'package:tiki/view/screens/dashboard/profile/widget/touchvoice_profile_body.dart';
import 'package:tiki/view/screens/dashboard/profile/widget/touchvoice_profile_header.dart';
import 'package:tiki/view/screens/dashboard/profile/widget/user_detail_widget.dart';
import 'package:tiki/view_model/userViewModel.dart';

class ProfileDashBoardScreen extends StatefulWidget {
  const ProfileDashBoardScreen({Key? key}) : super(key: key);

  @override
  State<ProfileDashBoardScreen> createState() => _ProfileDashBoardScreenState();
}

class _ProfileDashBoardScreenState extends State<ProfileDashBoardScreen> {
  late UserViewModel userViewModel;

  static final List<Map<String, String>> _dashboardItems = [
    {
      'image': AppImagePath.dashboardTransactionIconSvg,
      'label': 'Transaction',
    },
    {'image': AppImagePath.dashboardBagIconSvg, 'label': 'Bag'},
    {'image': AppImagePath.dashboardLevelIconSvg, 'label': 'Level'},
    {'image': AppImagePath.dashboardTopFansIconSvg, 'label': 'Top Fans'},
    {
      'image': AppImagePath.dashboardSubscriptionIconSvg,
      'label': 'Subscription',
    },
    {
      'image': AppImagePath.dashboardSubscriberIconSvg,
      'label': 'Subscriber',
    },
    {'image': AppImagePath.dashboardStoreIconSvg, 'label': 'Store'},
    {'image': AppImagePath.dashboardSettingsIconSvg, 'label': 'Settings'},
  ];

  List<VoidCallback> get _dashboardOnTap => [
        () => Get.toNamed(AppRoutes.transactionHistory),
        () => Get.toNamed(AppRoutes.bag),
        () => Get.toNamed(AppRoutes.level),
        () => Get.toNamed(AppRoutes.topFans),
        () => Get.toNamed(AppRoutes.subscription),
        () => Get.toNamed(AppRoutes.subscribers),
        () => Get.toNamed(AppRoutes.store),
        () => Get.toNamed(
              AppRoutes.settingScreen,
              arguments: {'otherProfile': false},
            ),
      ];

  @override
  void initState() {
    userViewModel = Get.find();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserViewModel>(
      init: userViewModel,
      builder: (vm) {
        final user = vm.currentUser;

        if (!vm.showFullDetailView) {
          return _buildCompactDashboard(user);
        }

        return _buildHiloProfile(user, vm);
      },
    );
  }

  Widget _buildCompactDashboard(user) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 48.h, bottom: 90.h),
      child: Column(
        children: [
          UserDetailsWidget(userModel: user),
          SizedBox(height: 20.h),
          SizedBox(
            height: 260.h,
            child: DashboardGrid(
              items: _dashboardItems,
              onTap: _dashboardOnTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHiloProfile(user, UserViewModel vm) {
    return ColoredBox(
      color: Colors.white,
      child: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: TouchVoiceProfileHeader(user: user)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 90.h),
                  child: TouchVoiceProfileBody(user: user),
                ),
              ),
            ],
          ),
          TouchVoiceProfileTopActions(
            onBack: () => vm.showFullDetailView = false,
          ),
        ],
      ),
    );
  }
}
