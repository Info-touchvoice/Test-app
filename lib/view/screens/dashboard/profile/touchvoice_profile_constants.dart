import 'package:flutter/material.dart';

class TouchVoiceProfileColors {
  static const headerTop = Color(0xFF2A2A2E);
  static const headerBottom = Color(0xFF121214);
  static const bodyBg = Color(0xFFFFFFFF);
  static const titleText = Color(0xFF1A1A1A);
  static const subText = Color(0xFF999999);
  static const tabActive = Color(0xFF000000);
  static const tabInactive = Color(0xFFC8C8C8);
  static const brandPurple = Color(0xFF9036FF);
  static const newBadgeBlue = Color(0xFF3B82F6);
  static const ageBadgeBlue = Color(0xFF4A9EFF);
  static const sectionDivider = Color(0xFFF0F0F0);
  static const diamondBadge = Color(0xFFFF9800);
  static const heartBadge = Color(0xFFE91E8C);
  static const starBadge = Color(0xFF5BC0FF);
}

class TouchVoiceProfileLayout {
  /// Dark header zone height (reference ~top 42% of screen).
  static const bannerHeight = 248.0;
  static const avatarSize = 80.0;
  static const avatarOverlap = 38.0;
  static const whiteCardOverlap = 36.0;
  static const horizontalPadding = 20.0;
  static const statsTopPadding = 52.0;

  static double get headerTotalHeight => bannerHeight;
}

class TouchVoiceProfileAssets {
  static const base = 'assets/png/touchvoice_profile/';

  static const topCover = '${base}bg_profile_top_cover.png';
  static const familyBg = '${base}family_rank_my_bg.webp';
  static const relationshipBg = '${base}cp_my_bg.webp';
  static const medalBg = '${base}my_medal_bg.webp';
}
