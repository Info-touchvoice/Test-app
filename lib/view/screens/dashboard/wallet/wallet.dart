import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/routes/app_routes.dart';
import 'package:tiki/view/screens/dashboard/wallet/hilo_wallet_constants.dart';
import 'package:tiki/view/screens/dashboard/wallet/wallet_exchange_screen.dart';
import 'package:tiki/view/screens/dashboard/wallet/widgets/hilo_wallet_plan_grid.dart';
import 'package:tiki/view_model/userViewModel.dart';
import 'package:tiki/view_model/wallet_controller.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final WalletController _wallet;

  @override
  void initState() {
    super.initState();
    _wallet = Get.put(WalletController());
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _wallet.selectedTab.value = _tabController.index;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPurple = _tabController.index == 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isPurple ? Brightness.light : Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: isPurple ? HiloWalletColors.purpleDark : Colors.white,
          body: Column(
            children: [
              _header(isPurple),
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    gradient: isPurple
                        ? const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              HiloWalletColors.purpleLight,
                              HiloWalletColors.purpleDark,
                            ],
                          )
                        : null,
                    color: isPurple ? null : Colors.white,
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _diamondTab(),
                      _beansTab(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _header(bool isPurple) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: top + 8.h, left: 8.w, right: 12.w, bottom: 8.h),
      color: isPurple ? Colors.transparent : Colors.white,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isPurple ? Colors.white : HiloWalletColors.textDark,
              size: 20.sp,
            ),
          ),
          Expanded(
            child: _tabBar(isPurple),
          ),
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.transactionHistory),
            icon: Image.asset(
              isPurple
                  ? HiloWalletAssets.recordIconWhite
                  : HiloWalletAssets.recordIcon,
              width: 22.w,
              height: 22.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabBar(bool isPurple) {
    const tabs = ['Diamonds', 'Beans'];
    return TabBar(
      controller: _tabController,
      onTap: (i) => _wallet.selectedTab.value = i,
      indicator: const BoxDecoration(),
      dividerColor: Colors.transparent,
      labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
      tabs: List.generate(tabs.length, (i) {
        final selected = _tabController.index == i;
        return Tab(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: sfProDisplaySemiBold.copyWith(
              fontSize: selected ? 15.sp : 14.sp,
              color: isPurple
                  ? (selected ? Colors.white : Colors.white.withOpacity(0.55))
                  : (selected
                      ? HiloWalletColors.tabSelected
                      : HiloWalletColors.textMuted),
            ),
            child: Text(tabs[i]),
          ),
        );
      }),
    );
  }

  Widget _diamondTab() {
    return GetBuilder<UserViewModel>(
      builder: (userVm) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _balanceHero(
                amount: userVm.coins,
                icon: HiloWalletAssets.diamondBig,
                label: 'Diamond Balance',
                light: true,
              ),
              SizedBox(height: 24.h),
              Text(
                'Recharge',
                style: sfProDisplaySemiBold.copyWith(
                  fontSize: 15.sp,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              SizedBox(height: 14.h),
              Obx(
                () => HiloWalletPlanGrid(
                  plans: _wallet.diamondPlans,
                  currency: WalletPlanCurrency.diamond,
                  isLoading: _wallet.isLoadingPlans.value,
                  onTap: (p) => _wallet.purchasePlan(p, context),
                ),
              ),
              SizedBox(height: 20.h),
              _vipPromo(),
            ],
          ),
        );
      },
    );
  }

  Widget _beansTab() {
    return GetBuilder<UserViewModel>(
      builder: (userVm) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
          child: Column(
            children: [
              _currencyCard(
                amount: userVm.beans,
                icon: HiloWalletAssets.beansBig,
                title: 'Beans Balance',
                subtitle: 'Get beans by receiving gifts',
              ),
              SizedBox(height: 28.h),
              _outlineButton(
                label: 'Exchange Diamonds to Beans',
                onTap: () => Get.to(() => const WalletExchangeScreen()),
              ),
              SizedBox(height: 20.h),
              Text(
                'Convert your diamonds into beans for gifts and social features.',
                textAlign: TextAlign.center,
                style: sfProDisplayRegular.copyWith(
                  fontSize: 12.sp,
                  color: HiloWalletColors.textMuted,
                  height: 1.45,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _balanceHero({
    required int amount,
    required String icon,
    required String label,
    required bool light,
  }) {
    return Row(
      children: [
        Image.asset(icon, width: 52.w, height: 52.w),
        SizedBox(width: 14.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatBalance(amount),
              style: sfProDisplayBold.copyWith(
                fontSize: 32.sp,
                color: light ? Colors.white : HiloWalletColors.textDark,
                height: 1.1,
              ),
            ),
            Text(
              label,
              style: sfProDisplayRegular.copyWith(
                fontSize: 13.sp,
                color: light
                    ? Colors.white.withOpacity(0.75)
                    : HiloWalletColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _currencyCard({
    required int amount,
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        image: const DecorationImage(
          image: AssetImage(HiloWalletAssets.balanceCardBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          Image.asset(icon, width: 48.w, height: 48.w),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatBalance(amount),
                  style: sfProDisplayBold.copyWith(
                    fontSize: 28.sp,
                    color: HiloWalletColors.textDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  title,
                  style: sfProDisplaySemiBold.copyWith(
                    fontSize: 13.sp,
                    color: HiloWalletColors.textDark,
                  ),
                ),
                Text(
                  subtitle,
                  style: sfProDisplayRegular.copyWith(
                    fontSize: 11.sp,
                    color: HiloWalletColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vipPromo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.diamond_outlined, color: Colors.white, size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'VIP members get daily diamond rewards',
              style: sfProDisplayMedium.copyWith(
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.95),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _outlineButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: HiloWalletColors.brandPurple, width: 1.5),
        ),
        child: Text(
          label,
          style: sfProDisplaySemiBold.copyWith(
            fontSize: 14.sp,
            color: HiloWalletColors.brandPurple,
          ),
        ),
      ),
    );
  }

  String _formatBalance(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(2)}M';
    if (n >= 10000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

class KeypadModel {
  final String digit;
  final String char;
  KeypadModel({required this.digit, required this.char});
}

class CoinsModel {
  final int coins;
  final double amount;
  CoinsModel({required this.coins, required this.amount});
}
