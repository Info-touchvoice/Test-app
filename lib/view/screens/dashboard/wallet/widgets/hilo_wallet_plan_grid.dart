import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiki/helpers/quick_help.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/theme/colors_constant.dart';
import 'package:tiki/view/screens/dashboard/wallet/hilo_wallet_constants.dart';
import 'package:tiki/view_model/wallet_controller.dart';

class HiloWalletPlanGrid extends StatelessWidget {
  const HiloWalletPlanGrid({
    Key? key,
    required this.plans,
    required this.currency,
    required this.onTap,
    this.isLoading = false,
  }) : super(key: key);

  final List<WalletPlanItem> plans;
  final WalletPlanCurrency currency;
  final void Function(WalletPlanItem plan) onTap;
  final bool isLoading;

  String get _icon {
    switch (currency) {
      case WalletPlanCurrency.beans:
        return HiloWalletAssets.beansSmall;
      case WalletPlanCurrency.gold:
        return HiloWalletAssets.goldIcon;
      case WalletPlanCurrency.diamond:
        return HiloWalletAssets.diamondSmall;
    }
  }

  Color get _accent {
    switch (currency) {
      case WalletPlanCurrency.gold:
        return HiloWalletColors.diamondOrange;
      case WalletPlanCurrency.beans:
        return HiloWalletColors.brandPurple;
      case WalletPlanCurrency.diamond:
        return HiloWalletColors.diamondOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: QuickHelp.appLoading());
    }
    if (plans.isEmpty) {
      return Center(
        child: Text(
          'No packs available',
          style: sfProDisplayRegular.copyWith(color: HiloWalletColors.textMuted),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.82,
      ),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return GestureDetector(
          onTap: () => onTap(plan),
          child: Container(
            decoration: BoxDecoration(
              color: HiloWalletColors.cardBg,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: HiloWalletColors.divider),
              boxShadow: AppColors.softShadow(
                color: Colors.black,
                opacity: 0.20,
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ),
            child: Stack(
              children: [
                if (plan.bonusLabel != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        gradient: currency == WalletPlanCurrency.gold
                            ? const LinearGradient(
                                colors: [
                                  HiloWalletColors.goldPinkStart,
                                  HiloWalletColors.goldPinkEnd,
                                ],
                              )
                            : null,
                        color: currency == WalletPlanCurrency.gold
                            ? null
                            : HiloWalletColors.brandPurple,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(14.r),
                          bottomLeft: Radius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        plan.bonusLabel!,
                        style: sfProDisplaySemiBold.copyWith(
                          fontSize: 8.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(_icon, width: 28.w, height: 28.w),
                      SizedBox(height: 6.h),
                      Text(
                        _formatAmount(plan.amount),
                        style: sfProDisplayBold.copyWith(
                          fontSize: 16.sp,
                          color: _accent,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        decoration: BoxDecoration(
                          gradient: currency == WalletPlanCurrency.gold
                              ? const LinearGradient(
                                  colors: [
                                    HiloWalletColors.goldPinkStart,
                                    HiloWalletColors.goldPinkEnd,
                                  ],
                                )
                              : null,
                          color: currency == WalletPlanCurrency.gold
                              ? null
                              : HiloWalletColors.brandPurple.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          plan.priceLabel,
                          style: sfProDisplaySemiBold.copyWith(
                            fontSize: 10.sp,
                            color: currency == WalletPlanCurrency.gold
                                ? Colors.white
                                : HiloWalletColors.brandPurple,
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
      },
    );
  }

  String _formatAmount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 10000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}
