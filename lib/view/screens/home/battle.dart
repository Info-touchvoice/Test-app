import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tiki/view_model/battle_live_controller.dart';

import '../../../generated/assets.dart';
import '../../../utils/constants/status.dart';
import '../../../utils/theme/colors_constant.dart';
import '../../widgets/nothing_widget.dart';

class Battle extends StatefulWidget {
  Battle({Key? key}) : super(key: key);

  @override
  State<Battle> createState() => _BattleState();
}

class _BattleState extends State<Battle> {
  final BattleLiveViewModel battleLiveViewModel = Get.find();

  @override
  void initState() {
    super.initState();
    battleLiveViewModel.loadLive();
    // battleLiveViewModel.startTimer();
  }

  @override
  void dispose() {
    // battleLiveViewModel.cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildBattleContent(),
      ],
    );
  }

  Widget _buildBattleContent() {
    return GetBuilder<BattleLiveViewModel>(builder: (controller) {
      if (controller.status == Status.Loading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      
      if (controller.battleModelList.isEmpty) {
        return NothingIsHere();
      }
      
      // Keep this widget NON-scrollable; the parent (HomeView) owns scrolling and
      // pull-to-refresh. Use a shrink-wrapped ListView.
      return ListView.builder(
        padding: EdgeInsets.only(top: 5.h, bottom: 65.h),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.battleModelList.length,
        itemBuilder: (context, index) {
          final item = controller.battleModelList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.8, vertical: 16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildBattleInfo(
                  hostName: item.hostName,
                  player2Name: item.player2Name,
                  hostBgImage: item.hostBgImage,
                  player2BgImage: item.player2BgImage,
                  team1Score: item.team1Score,
                  team2Score: item.team2Score,
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildBattleInfo({
    required String hostName,
    required String player2Name,
    required String hostBgImage,
    required String player2BgImage,
    required int team1Score,
    required int team2Score,
  }) {
    return SizedBox(
      width: 340.w,
      child: Stack(
        children: [
          _buildBackGroundImages(hostBgImage, player2BgImage),
          _buildHostName(hostName),
          _buildPlayer2Name(player2Name),
          _buildVsImage(),
          _buildProgressBar(
            team1Score: team1Score,
            team2Score: team2Score,
          )
        ],
      ),
    );
  }

  Widget _buildHostName(String name) {
    return Positioned(
      bottom: 25.h,
      left: 9.w,
      child: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildPlayer2Name(String name) {
    return Positioned(
      bottom: 25.h,
      right: 9.w,
      child: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildBackGroundImages(
      String leftBackgroundImage, String rightBackgroundImage) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
          child: SizedBox(
              width: 170.w,
              child: Image.network(
                leftBackgroundImage,
                fit: BoxFit.cover,
              )),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
          child: SizedBox(
              width: 170.w,
              child: Image.network(
                rightBackgroundImage,
                fit: BoxFit.cover,
              )),
        ),
      ],
    );
  }

  Widget _buildVsImage() {
    return Positioned(
      left: 153.h,
      top: 70.45.w,
      child: Image.asset(Assets.pngVs),
    );
  }

  Widget _buildProgressBar({
    required int team1Score,
    required int team2Score,
  }) {
    return Positioned(
      bottom: 0.7.h,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        child: Container(
            decoration: BoxDecoration(color: AppColors.darkPurple),
            height: 16.h,
            width: 340.w,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                  child: LinearPercentIndicator(
                    animation: true,
                    animateFromLastPercent: true,
                    padding: EdgeInsets.zero,
                    width: 340.w,
                    lineHeight: 16.h,
                    percent: 0.5,
                    clipLinearGradient: true,
                    animationDuration: 500,
                    backgroundColor: Colors.transparent,
                    linearGradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: AppColors.orangeGradientColor),
                  ),
                ),
                Positioned(
                  left: 16.w,
                  top: 2.5.h,
                  child: Text(
                    team1Score.toString(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffffffff),
                    ),
                  ),
                ),
                Positioned(
                  right: 16.w,
                  top: 2.5.h,
                  child: Text(
                    team2Score.toString(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffffffff),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
