import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../view_model/nearby_controller.dart';
import 'build_card.dart';
import 'nothing_widget.dart';

class Nearby extends StatefulWidget {
  const Nearby({Key? key}) : super(key: key);

  @override
  State<Nearby> createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  final HomeLiveViewModel homeLiveViewModel = Get.find();

  @override
  void initState() {
    homeLiveViewModel.loadNearbyLives();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep this widget NON-scrollable; the parent (HomeView) owns scrolling and
    // pull-to-refresh. This avoids nested-scroll + layout issues that can show
    // a blank body until navigation rebuilds.
    return GetBuilder<HomeLiveViewModel>(builder: (controller) {
      if (controller.nearbyLiveModelList.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NothingIsHere(),
          ],
        );
      }

      return Padding(
        padding: EdgeInsets.only(top: 6.h, bottom: 55.h),
        child: GridView.count(
          padding: EdgeInsets.only(bottom: 65.h),
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.w,
          shrinkWrap: true,
          children:
              List.generate(controller.nearbyLiveModelList.length, (index) {
            final item = controller.nearbyLiveModelList[index];
            return BuildCard(
              cFlag: item.flag,
              cName: item.country,
              imagePath: item.image,
              liveModel: item.liveModel,
              count: item.achievementCount,
              name: item.name,
              avatar: item.avatar,
            );
          }),
        ),
      );
    });
  }
}
