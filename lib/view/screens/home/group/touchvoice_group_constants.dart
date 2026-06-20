import 'package:flutter/material.dart';

/// Visual tokens for TouchVoice Group tab (`fragment_home_room.xml`).
class TouchVoiceGroupColors {
  static const brandPurple = Color(0xFF9036FF);
  static const filterActive = Color(0xFF8829FE);
  static const filterInactive = Color(0xFF636B80);
  static const titleText = Color(0xFF333333);
  static const subText = Color(0xFF999999);
  static const sectionTitle = Color(0xFF5F5F5F);
  static const bodyBg = Color(0xFFFFFFFF);
  static const divider = Color(0xFFF5F5F5);
  static const subTabBar = Color(0x1AF4EBFF);
}

class TouchVoiceGroupAssets {
  static const base = 'assets/png/touchvoice_group/';

  static const headerBg = '${base}ic_group_top_bg_all.webp';
  static const search = '${base}icon_group_search_all.webp';
  static const createGroup = '${base}icon_create_group.webp';
  /// Auto-rotating audio room promo banners (network).
  static const audioRoomBannerUrls = [
    'https://images.unsplash.com/photo-1590602847861-f357a9332bbc?w=900&q=80',
    'https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=900&q=80',
    'https://images.unsplash.com/photo-1478737270239-2f02ca77fc67?w=900&q=80',
  ];

  /// Discover > Activities placeholder (network).
  static const discoverActivitiesPhotoUrl =
      'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=900&q=80';

  /// Discover > Event banners (from Hilo 4.16.0 APK assets).
  static const eventBannerPopular = '${base}popular_bg.webp';
  static const eventBannerLudo = '${base}ludo_quick_bg.webp';
  static const eventBannerUno = '${base}uno_quick_bg.webp';
  static const eventBannerAssets = [
    eventBannerPopular,
    eventBannerLudo,
    eventBannerUno,
  ];
  static const rankPower = '${base}icon_popular_rank_power_bg1.webp';
  static const rankFamous = '${base}popular_rank_famous_bg.webp';
  static const rankCp = '${base}icon_popular_rank_cp_bg1.webp';
  static const ludoQuick = '${base}ludo_quick_bg.webp';
  static const unoQuick = '${base}uno_quick_bg.webp';
  static const sheepQuick = '${base}sheep_quick_bg.webp';
  static const matchQuick = '${base}match_quick_bg.webp';
  static const gameHandle = '${base}game_handle_icon.webp';
  static const videoMatchArrow = '${base}ic_video_match_right.png';
  static const roomPlaceholder = '${base}group_placeholde.webp';
  static const onMic = '${base}ic_on_mic.webp';
  static const rocketGreen = '${base}icon_rocket_green_room_list.webp';
  static const discoverCountryBg = '${base}ic_discover_country_bg.webp';
  static const discoverCountryStar = '${base}ic_discover_country_star.png';
  static const discoverGiftBg = '${base}ic_discover_gift_bg.webp';
  static const discoverBroadcastBg = '${base}ic_discover_global_broad_cast_bg.webp';
  static const discoverActivity = '${base}discover_create_activities.webp';
}
