import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/view/screens/dashboard/wallet/hilo_wallet_constants.dart';
import 'package:tiki/view_model/userViewModel.dart';
import 'package:tiki/view_model/wallet_controller.dart';

class WalletExchangeScreen extends StatefulWidget {
  const WalletExchangeScreen({Key? key}) : super(key: key);

  @override
  State<WalletExchangeScreen> createState() => _WalletExchangeScreenState();
}

class _WalletExchangeScreenState extends State<WalletExchangeScreen> {
  final TextEditingController _diamondInput = TextEditingController();
  final WalletController wallet = Get.find<WalletController>();
  final UserViewModel userVm = Get.find<UserViewModel>();

  int get _beansPreview {
    final diamonds = int.tryParse(_diamondInput.text) ?? 0;
    return diamonds * HiloWalletLayout.beansPerDiamond;
  }

  @override
  void dispose() {
    _diamondInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: HiloWalletColors.textDark, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Diamond Exchange',
          style: sfProDisplaySemiBold.copyWith(
            fontSize: 17.sp,
            color: HiloWalletColors.textDark,
          ),
        ),
      ),
      body: GetBuilder<UserViewModel>(
        builder: (_) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _balanceCard(
                  label: 'Diamond balance',
                  amount: userVm.coins,
                  icon: HiloWalletAssets.diamondBig,
                  accent: HiloWalletColors.diamondOrange,
                ),
                SizedBox(height: 20.h),
                _exchangeField(
                  label: 'Diamonds to exchange',
                  icon: HiloWalletAssets.diamondSmall,
                  controller: _diamondInput,
                  hint:
                      'Min ${HiloWalletLayout.minDiamondExchange}, multiple of ${HiloWalletLayout.minDiamondExchange}',
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: 16.h),
                Center(
                  child: Icon(Icons.swap_vert_rounded,
                      color: HiloWalletColors.brandPurple, size: 32.sp),
                ),
                SizedBox(height: 16.h),
                _balanceCard(
                  label: 'You will receive',
                  amount: _beansPreview,
                  icon: HiloWalletAssets.beansBig,
                  accent: HiloWalletColors.brandPurple,
                  subtitle:
                      'Rate: 1 diamond = ${HiloWalletLayout.beansPerDiamond} beans',
                ),
                SizedBox(height: 12.h),
                _balanceCard(
                  label: 'Beans balance',
                  amount: userVm.beans,
                  icon: HiloWalletAssets.beansSmall,
                  accent: HiloWalletColors.brandPurple,
                  compact: true,
                ),
                SizedBox(height: 28.h),
                _presetChips(),
                SizedBox(height: 32.h),
                GestureDetector(
                  onTap: _submit,
                  child: Container(
                    height: 52.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          HiloWalletColors.brandPurple,
                          HiloWalletColors.purpleDark,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(26.r),
                      boxShadow: [
                        BoxShadow(
                          color: HiloWalletColors.brandPurple.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Exchange',
                      style: sfProDisplayBold.copyWith(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Beans are used for gifts and social features. Diamonds must be exchanged in multiples of ${HiloWalletLayout.minDiamondExchange}.',
                  textAlign: TextAlign.center,
                  style: sfProDisplayRegular.copyWith(
                    fontSize: 12.sp,
                    color: HiloWalletColors.textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _balanceCard({
    required String label,
    required int amount,
    required String icon,
    required Color accent,
    String? subtitle,
    bool compact = false,
  }) {
    return Container(
      padding: EdgeInsets.all(compact ? 14.w : 18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        image: const DecorationImage(
          image: AssetImage(HiloWalletAssets.exchangeBg),
          fit: BoxFit.cover,
          opacity: 0.12,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withOpacity(0.08),
            Colors.white,
          ],
        ),
        border: Border.all(color: accent.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Image.asset(icon, width: compact ? 36.w : 44.w, height: compact ? 36.w : 44.w),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: sfProDisplayRegular.copyWith(
                    fontSize: 13.sp,
                    color: HiloWalletColors.textMuted,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _format(amount),
                  style: sfProDisplayBold.copyWith(
                    fontSize: compact ? 22.sp : 26.sp,
                    color: HiloWalletColors.textDark,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: sfProDisplayRegular.copyWith(
                      fontSize: 11.sp,
                      color: HiloWalletColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _exchangeField({
    required String label,
    required String icon,
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: sfProDisplayMedium.copyWith(
            fontSize: 14.sp,
            color: HiloWalletColors.textDark,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7FA),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: HiloWalletColors.divider),
          ),
          child: Row(
            children: [
              Image.asset(icon, width: 28.w, height: 28.w),
              SizedBox(width: 10.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: onChanged,
                  style: sfProDisplayBold.copyWith(fontSize: 22.sp),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: sfProDisplayRegular.copyWith(
                      fontSize: 22.sp,
                      color: HiloWalletColors.textMuted.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          hint,
          style: sfProDisplayRegular.copyWith(
            fontSize: 11.sp,
            color: HiloWalletColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _presetChips() {
    final presets = [10, 50, 100, 500, 1000]
        .where((v) => v <= userVm.coins)
        .take(4)
        .toList();
    if (presets.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 10.w,
      runSpacing: 8.h,
      alignment: WrapAlignment.center,
      children: presets
          .map(
            (v) => ActionChip(
              label: Text('$v diamonds'),
              backgroundColor: HiloWalletColors.cardBg,
              side: BorderSide(
                  color: HiloWalletColors.brandPurple.withOpacity(0.3)),
              onPressed: () {
                _diamondInput.text = '$v';
                setState(() {});
              },
            ),
          )
          .toList(),
    );
  }

  Future<void> _submit() async {
    final diamonds = int.tryParse(_diamondInput.text) ?? 0;
    final ok = await wallet.exchangeDiamondsForBeans(diamonds, context);
    if (ok && mounted) Get.back();
  }

  String _format(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 10000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}
