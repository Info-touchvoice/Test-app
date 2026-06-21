import 'package:flutter/material.dart';
import 'package:tiki/utils/theme/colors_constant.dart';

class TouchVoiceHomeHeaderTheme {
  const TouchVoiceHomeHeaderTheme({
    required this.id,
    required this.name,
    required this.startColor,
    required this.endColor,
    required this.accentColor,
  });

  final String id;
  final String name;
  final Color startColor;
  final Color endColor;
  final Color accentColor;

  static const royalPurple = TouchVoiceHomeHeaderTheme(
    id: 'royal_purple',
    name: 'Royal Purple',
    startColor: AppColors.primaryPurple,
    endColor: AppColors.primaryBlue,
    accentColor: AppColors.vipGold,
  );

  static const oceanBlue = TouchVoiceHomeHeaderTheme(
    id: 'ocean_blue',
    name: 'Ocean Blue',
    startColor: AppColors.secondaryBackground,
    endColor: AppColors.primaryBlue,
    accentColor: AppColors.diamondBlue,
  );

  static const emeraldGreen = TouchVoiceHomeHeaderTheme(
    id: 'emerald_green',
    name: 'Emerald Green',
    startColor: AppColors.secondaryBackground,
    endColor: AppColors.success,
    accentColor: AppColors.success,
  );

  static const sunsetOrange = TouchVoiceHomeHeaderTheme(
    id: 'sunset_orange',
    name: 'Sunset Orange',
    startColor: AppColors.secondaryBackground,
    endColor: AppColors.vipGold,
    accentColor: AppColors.vipGold,
  );

  static const midnightBlack = TouchVoiceHomeHeaderTheme(
    id: 'midnight_black',
    name: 'Midnight Black',
    startColor: AppColors.background,
    endColor: AppColors.secondaryBackground,
    accentColor: AppColors.textPrimaryColor,
  );

  static const defaultTheme = royalPurple;

  static const available = [
    royalPurple,
    oceanBlue,
    emeraldGreen,
    sunsetOrange,
    midnightBlack,
  ];

  static TouchVoiceHomeHeaderTheme resolve(String? value) {
    final normalized = _normalize(value);
    for (final theme in available) {
      if (_normalize(theme.id) == normalized ||
          _normalize(theme.name) == normalized) {
        return theme;
      }
    }

    return defaultTheme;
  }

  static String _normalize(String? value) {
    return (value ?? '')
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[\s-]+'), '_');
  }
}
