import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/view/widgets/popular.dart';
import 'package:tiki/view_model/nearby_controller.dart';

import '../../../parse/UserModel.dart';
import '../../../utils/theme/colors_constant.dart';
import '../../widgets/nearby.dart';

class LiveHomeView extends StatefulWidget {
  final UserModel? currentUser;

  LiveHomeView({Key? key, this.currentUser}) : super(key: key);

  @override
  State<LiveHomeView> createState() => _LiveHomeViewState();
}

class _LiveHomeViewState extends State<LiveHomeView> {
  final HomeLiveViewModel homeLiveViewModel = Get.find();

  @override
  void initState() {
    super.initState();
    homeLiveViewModel.subscribeLiveStreamingModel();
  }

  @override
  void dispose() {
    homeLiveViewModel.unSubscribeLiveStreamingModel();
    super.dispose();
  }

  Color? colorSelected(bool isSelected) {
    return isSelected ? AppColors.primaryColor : null;
  }

  Color? textColorSelected(bool isSelected, BuildContext context) {
    return AppColors.textPrimaryColor;
  }

  Color borderColorSelected(bool isSelected, BuildContext context) {
    return isSelected ? AppColors.primaryColor : AppColors.borderColor;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeLiveViewModel>(
        init: homeLiveViewModel,
        builder: (controller) {
          // This widget is hosted inside a parent ListView (HomeView). Using
          // Expanded/Flexible here can cause "unbounded height" layout exceptions
          // and render as blank. Just return the content directly.
          return controller.isNearbySelected.value ? Nearby() : Popular();
        });
  }

  Widget toggleButton() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                if (homeLiveViewModel.isNearbySelected.value == false) {
                  homeLiveViewModel.switchToggle(false);
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: ScreenUtil().setHeight(30),
                width: ScreenUtil().setWidth(40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorSelected(
                        homeLiveViewModel.isNearbySelected.value == true),
                    border: Border.all(
                      // color: Colors.white70
                      color: borderColorSelected(
                          homeLiveViewModel.isNearbySelected.value, context),
                    )),
                child: Text(
                  'All',
                  style: TextStyle(
                      color: textColorSelected(
                          homeLiveViewModel.isNearbySelected.value == true,
                          context),
                      fontSize: 14.sp),
                ),
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(20)),
            InkWell(
              onTap: () {
                if (homeLiveViewModel.isNearbySelected.value == true) {
                  homeLiveViewModel.switchToggle(true);
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: ScreenUtil().setHeight(30),
                width: ScreenUtil().setWidth(80),
                decoration: BoxDecoration(
                    color: colorSelected(
                        homeLiveViewModel.isNearbySelected.value == false),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      // color: Colors.white70
                      color: borderColorSelected(
                          !homeLiveViewModel.isNearbySelected.value, context),
                    )),
                child: Text(
                  "Trending",
                  style: TextStyle(
                      color: textColorSelected(
                          homeLiveViewModel.isNearbySelected.value == false,
                          context),
                      fontSize: 14.sp),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
