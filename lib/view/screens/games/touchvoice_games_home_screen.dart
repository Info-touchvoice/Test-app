import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/constants/typography.dart';
import '../../../view_model/userViewModel.dart';
import 'touchvoice_games_constants.dart';

/// Hilo-style games hub (layout inspired by APK, TouchVoice branding).
class TouchVoiceGamesHomeScreen extends StatelessWidget {
  const TouchVoiceGamesHomeScreen({Key? key}) : super(key: key);

  static const _quickGames = [
    _QuickGame(
      banner: TouchVoiceGamesAssets.ludoBanner,
      title: TouchVoiceGamesAssets.ludoTitle,
      players: '72,940',
    ),
    _QuickGame(
      banner: TouchVoiceGamesAssets.unoBanner,
      title: TouchVoiceGamesAssets.unoTitle,
      players: '70,180',
    ),
  ];

  static const _secondaryGames = [
    _GridGame('Snakes', TouchVoiceGamesAssets.gridSnakesBanner, isBanner: true),
    _GridGame('Carrom', TouchVoiceGamesAssets.gridCarromArt, isBanner: false),
  ];

  @override
  Widget build(BuildContext context) {
    final diamonds =
        Get.find<UserViewModel>().currentUser.getCoins.toString();

    return ColoredBox(
      color: TouchVoiceGamesColors.screenBg,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            TouchVoiceGamesAssets.bg,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: EdgeInsets.only(bottom: 90.h),
              children: [
                _diamondBar(diamonds),
                _quickPlayRow(),
                _secondaryGameRow(),
                _playWithFriendsHeader(),
                _noFriendsPlaying(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _diamondBar(String amount) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 15.w, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 23.h,
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                TouchVoiceGamesAssets.diamond,
                width: 16.w,
                height: 14.h,
                filterQuality: FilterQuality.high,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Text(
                  amount,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Image.asset(
                TouchVoiceGamesAssets.addDiamond,
                width: 15.w,
                height: 15.w,
                filterQuality: FilterQuality.high,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickPlayRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.w, 24.h, 15.w, 0),
      child: Row(
        children: [
          for (var i = 0; i < _quickGames.length; i++) ...[
            if (i > 0) SizedBox(width: 10.w),
            Expanded(child: _quickCard(_quickGames[i])),
          ],
        ],
      ),
    );
  }

  Widget _quickCard(_QuickGame game) {
    return AspectRatio(
      aspectRatio: 22 / 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              game.banner,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
            Positioned(
              right: 13.w,
              top: 17.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    game.title,
                    height: 18.h,
                    filterQuality: FilterQuality.high,
                  ),
                  SizedBox(height: 9.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        TouchVoiceGamesAssets.playerCount,
                        width: 14.w,
                        height: 14.w,
                        filterQuality: FilterQuality.high,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        game.players,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secondaryGameRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 0),
      child: Row(
        children: [
          for (var i = 0; i < _secondaryGames.length; i++) ...[
            if (i > 0) SizedBox(width: 10.w),
            Expanded(child: _secondaryGameCard(_secondaryGames[i])),
          ],
        ],
      ),
    );
  }

  Widget _secondaryGameCard(_GridGame game) {
    return AspectRatio(
      aspectRatio: 106 / 137,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: game.isBanner
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    game.art,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Text(
                        game.label,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          shadows: const [
                            Shadow(color: Colors.black54, blurRadius: 4),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      TouchVoiceGamesColors.carromOrangeLight,
                      TouchVoiceGamesColors.carromOrange,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Image.asset(
                          game.art,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Text(
                        game.label,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _playWithFriendsHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.w, 24.h, 15.w, 0),
      child: Text(
        'Play with friends',
        style: sfProDisplayMedium.copyWith(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _noFriendsPlaying() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.w, 24.h, 15.w, 0),
      child: Center(
        child: Text(
          'No friend playing',
          style: sfProDisplayRegular.copyWith(
            fontSize: 14.sp,
            color: TouchVoiceGamesColors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _QuickGame {
  final String banner;
  final String title;
  final String players;

  const _QuickGame({
    required this.banner,
    required this.title,
    required this.players,
  });
}

class _GridGame {
  final String label;
  final String art;
  final bool isBanner;

  const _GridGame(this.label, this.art, {required this.isBanner});
}
