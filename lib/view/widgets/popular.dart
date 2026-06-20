import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/view_model/nearby_controller.dart';

import 'build_card.dart';
import 'nothing_widget.dart';

class Popular extends StatefulWidget {
  const Popular({Key? key}) : super(key: key);

  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> {
  final HomeLiveViewModel homeLiveViewModel = Get.find();

  @override
  void initState() {
    homeLiveViewModel.loadPopularLives();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep this widget NON-scrollable; the parent (HomeView) owns scrolling and
    // pull-to-refresh.
    return GetBuilder<HomeLiveViewModel>(builder: (controller) {
      if (controller.popularModelList.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NothingIsHere(),
          ],
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: GridView.count(
          padding: EdgeInsets.only(bottom: 65.h),
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.w,
          shrinkWrap: true,
          children: List.generate(controller.popularModelList.length, (index) {
            final item = controller.popularModelList[index];
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
