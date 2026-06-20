import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';
import 'package:tiki/view/widgets/region_widgets.dart';
import 'package:tiki/view/widgets/trending_widget.dart';

import '../../../parse/UserModel.dart';
import '../../../view_model/ranking_controller.dart';
import '../../../view_model/tab_bar_controller.dart';
import '../../../view_model/trending_controller.dart';
import '../../widgets/toggle_button_list.dart';
import '../../widgets/trophy_toggle_button_list.dart';
import '../ranking/trophy/coins.dart';

class Explore extends StatelessWidget {
  final UserModel? currentUser;

  Explore({Key? key, this.currentUser}) : super(key: key);

  final TrendingViewModel trendingViewModel = Get.put(TrendingViewModel());
  final TabBarViewModel tabBarViewModel = Get.put(TabBarViewModel());
  final RankingViewModel rankingViewModel = Get.find();

  Future<void> _refreshData() async {
    if (rankingViewModel.showTrophyScreen.value) {
      rankingViewModel.setRanking();
    } else {
      await trendingViewModel.loadLive();
      if (trendingViewModel.chosenCountry.value.isNotEmpty) {
        trendingViewModel.updateListForChosenCountry(
            trendingViewModel.chosenCountry.value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    rankingViewModel.showTrophyScreen.value = false;
    return BaseScaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          if (rankingViewModel.showTrophyScreen.value == true) {
            return SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: TrophyToggleButtonList(
                selected: rankingViewModel.selectedId.value,
                callback: (index) {
                  rankingViewModel.selectedId.value = index;
                  rankingViewModel.setRanking();
                },
                categories: rankingViewModel.categories,
              ),
            );
          } else {
            return Column(
              children: [
                SizedBox(height: 5.h),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10.w),
                      Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ToggleButtonList(
                    selected: 0,
                    explore: true,
                    callback: (index) {},
                    categories: ["Explore"],
                  ),
                ),
              ],
            );
          }
        }),
        Expanded(
          child: Obx(() {
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  if (rankingViewModel.showTrophyScreen.value)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 100,
                      ),
                      child: GlobalRanking(),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: trendingViewModel.chosenCountry.value.isEmpty
                                ? 16.h
                                : 20.h,
                          ),
                          if (trendingViewModel.chosenCountry.value.isEmpty)
                            RegionWidget(),
                          GestureDetector(
                            onTap: () {
                              trendingViewModel.chosenCountry.value = '';
                              trendingViewModel.chosenCountryFlag.value = '';
                            },
                            child: Row(
                              children: [
                                Text(
                                  trendingViewModel.chosenCountry.value.isEmpty
                                      ? "Trending"
                                      : trendingViewModel.chosenCountry.value,
                                  style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp),
                                ),
                                SizedBox(width: 12.w),
                                if (trendingViewModel
                                    .chosenCountryFlag.value.isNotEmpty)
                                  SvgPicture.asset(
                                    trendingViewModel.chosenCountryFlag.value,
                                    height: 19.h,
                                    width: 26.13.w,
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: trendingViewModel.chosenCountry.value.isNotEmpty
                                ? 20.h
                                : 0,
                          ),
                          TrendingWidget(),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ],
    ));
  }
}
