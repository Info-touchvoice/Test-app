import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/theme/colors_constant.dart';
import 'package:tiki/view/screens/live/zegocloud/zim_zego_sdk/internal/business/business_define.dart';
import 'package:tiki/view_model/global_live_stream_controller.dart';

import '../../../../utils/constants/app_constants.dart';
import '../../../../view_model/live_controller.dart';
import '../../../../view_model/live_messages_controller.dart';

class ForYou extends StatelessWidget {
  ForYou();

  @override
  Widget build(BuildContext context) {
    GlobalLiveStreamViewModel globalViewModel = Get.find();
    RxBool isEmpty = false.obs;
    isEmpty.value = checkStreamingTypeMismatch(globalViewModel);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Drawer(
          width: 170,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 135,
                  height: 80,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.orangeContainer,
                        AppColors.progressLinearOrangeColor1,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('For You',
                          style: sfProDisplayBold.copyWith(fontSize: 18)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(AppImagePath.lightningIcon,
                              width: 36, height: 36),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ...List.generate(globalViewModel.liveStreamingModelList.length,
                    (index) {
                  if (globalViewModel.liveStreamingModelList[index].liveModel
                          .getStreamingType ==
                      Get.find<LiveViewModel>()
                          .liveStreamingModel
                          .getStreamingType)
                    return GestureDetector(
                      onTap: () {
                        Get.back();
                        Get.find<LiveViewModel>()
                            .unSubscribeLiveStreamingModel();
                        Get.find<LiveMessagesViewModel>()
                            .unSubscribeLiveMessageModels();
                        if (Get.find<LiveViewModel>().role == ZegoLiveRole.host)
                          Get.find<LiveViewModel>()
                              .endLiveStreamingAndJoinOtherSession(
                                  context,
                                  globalViewModel
                                      .liveStreamingModelList[index].liveModel);
                        else
                          Get.find<LiveViewModel>()
                              .joinOtherStreamerLiveSession(globalViewModel
                                  .liveStreamingModelList[index].liveModel);
                      },
                      child: Container(
                        height: 125,
                        width: 125,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(globalViewModel
                                .liveStreamingModelList[index].image),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: AppColors.black.withOpacity(0.4),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Text(
                                      '${globalViewModel.liveStreamingModelList[index].name.split(' ')[0]}',
                                      style: sfProDisplaySemiBold.copyWith(
                                          fontSize: 12),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        Image.asset(
                                          AppImagePath.exploreIcon,
                                          width: 10,
                                          height: 10,
                                          color:
                                              AppColors.white.withOpacity(0.7),
                                        ),
                                        Text(
                                          '${globalViewModel.liveStreamingModelList[index].liveModel.getViewersId!.length ?? 0}',
                                          style: sfProDisplayRegular.copyWith(
                                            fontSize: 10,
                                            color: AppColors.white
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  return SizedBox();
                }),
                if (globalViewModel.liveStreamingModelList.isEmpty ||
                    isEmpty.value)
                  Column(
                    children: [
                      SizedBox(
                        height: 250.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "*  ",
                            style:
                                sfProDisplayBlack.copyWith(color: Colors.red),
                          ),
                          Text(
                            "Nothing is here",
                            style: sfProDisplayMedium.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: -18,
          child: GestureDetector(
            onTap: () {
              Scaffold.of(context).closeEndDrawer();
            },
            child: const CircleAvatar(
              radius: 15,
              child: Icon(Icons.close, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  bool checkStreamingTypeMismatch(GlobalLiveStreamViewModel globalViewModel) {
    int counter = 0;
    int listLength = globalViewModel.liveStreamingModelList.length;

    for (int i = 0; i < listLength; i++) {
      if (globalViewModel
              .liveStreamingModelList[i].liveModel.getStreamingType !=
          Get.find<LiveViewModel>().liveStreamingModel.getStreamingType) {
        counter++;
      }
    }

    return counter == listLength;
  }
}
