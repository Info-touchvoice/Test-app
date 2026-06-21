import 'package:flutter/material.dart';

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
    startColor: Color(0xFF3B0764),
    endColor: Color(0xFF7E22CE),
    accentColor: Color(0xFFFFD76A),
  );

  static const oceanBlue = TouchVoiceHomeHeaderTheme(
    id: 'ocean_blue',
    name: 'Ocean Blue',
    startColor: Color(0xFF0F172A),
    endColor: Color(0xFF2563EB),
    accentColor: Color(0xFF7DD3FC),
  );

  static const emeraldGreen = TouchVoiceHomeHeaderTheme(
    id: 'emerald_green',
    name: 'Emerald Green',
    startColor: Color(0xFF064E3B),
    endColor: Color(0xFF10B981),
    accentColor: Color(0xFFA7F3D0),
  );

  static const sunsetOrange = TouchVoiceHomeHeaderTheme(
    id: 'sunset_orange',
    name: 'Sunset Orange',
    startColor: Color(0xFF7C2D12),
    endColor: Color(0xFFF97316),
    accentColor: Color(0xFFFFD76A),
  );

  static const midnightBlack = TouchVoiceHomeHeaderTheme(
    id: 'midnight_black',
    name: 'Midnight Black',
    startColor: Color(0xFF111827),
    endColor: Color(0xFF374151),
    accentColor: Color(0xFFE5E7EB),
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
