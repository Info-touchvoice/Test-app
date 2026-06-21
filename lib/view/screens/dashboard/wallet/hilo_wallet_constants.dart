import 'package:flutter/material.dart';
import 'package:tiki/utils/theme/colors_constant.dart';

class HiloWalletColors {
  static const purpleLight = AppColors.primaryPurple;
  static const purpleDark = AppColors.background;
  static const brandPurple = AppColors.primaryPurple;
  static const tabSelected = AppColors.primaryBlue;
  static const diamondOrange = AppColors.diamondBlue;
  static const goldPinkStart = AppColors.buttonGradientStart;
  static const goldPinkEnd = AppColors.buttonGradientEnd;
  static const textDark = AppColors.textPrimaryColor;
  static const textMuted = AppColors.textSecondaryColor;
  static const divider = AppColors.dividerColor;
  static const cardBg = AppColors.cardBackground;
}

class HiloWalletAssets {
  static const base = 'assets/png/hilo_wallet/';
  static const diamondBig = '${base}recharge_diamond_big.webp';
  static const beansBig = '${base}big_bill_beans.webp';
  static const beansSmall = '${base}bill_beans.webp';
  static const diamondSmall = '${base}bill_diamond.png';
  static const goldIcon = '${base}gem_icon.webp';
  static const balanceCardBg = '${base}icon_beans_bg.webp';
  static const goldRechargeBg = '${base}gold_recharge_bg.webp';
  static const exchangeBg = '${base}exchange_bg.webp';
  static const recordIcon = '${base}wallet_record.webp';
  static const recordIconWhite = '${base}wallet_record_w.webp';
}

class HiloWalletLayout {
  /// Beans received per 1 diamond exchanged.
  static const beansPerDiamond = 10;
  static const minDiamondExchange = 10;
}
