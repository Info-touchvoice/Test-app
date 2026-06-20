import 'package:flutter/material.dart';

class HiloWalletColors {
  static const purpleLight = Color(0xFFB35BFF);
  static const purpleDark = Color(0xFF651AF1);
  static const brandPurple = Color(0xFF9036FF);
  static const tabSelected = Color(0xFFB244FF);
  static const diamondOrange = Color(0xFFFF9A41);
  static const goldPinkStart = Color(0xFFC34FFD);
  static const goldPinkEnd = Color(0xFFFF4E93);
  static const textDark = Color(0xFF333333);
  static const textMuted = Color(0xFF999999);
  static const divider = Color(0xFFF0F0F0);
  static const cardBg = Color(0xFFF8F5FF);
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
