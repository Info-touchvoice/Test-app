import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/view_model/audio_home_view_model.dart';

import '../../model/popular_card_model.dart';
import 'build_card.dart';
import 'nothing_widget.dart';

class HomeAudioWidget extends StatefulWidget {
  HomeAudioWidget({Key? key}) : super(key: key);

  @override
  State<HomeAudioWidget> createState() => _HomeAudioWidgetState();
}

class _HomeAudioWidgetState extends State<HomeAudioWidget> {
  final AudioHomeViewModel viewModel = Get.find();

  @override
  void initState() {
    viewModel.loadLive();
    viewModel.subscribeLiveStreamingModel();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    viewModel.unSubscribeLiveStreamingModel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioHomeViewModel>(
      builder: (controller) {
        List<PopularModel> modelList = controller.audioLiveModelList;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: modelList.isNotEmpty
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            if (modelList.isNotEmpty)
              GridView.count(
                padding: EdgeInsets.only(bottom: 65.h),
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.w,
                shrinkWrap: true,
                children: List.generate(modelList.length, (index) {
                  return BuildCard(
                      cFlag: modelList[index].flag,
                      cName: modelList[index].countryCode,
                      imagePath: modelList[index].image,
                      count: modelList[index].achievementCount,
                      name: modelList[index].name,
                      avatar: modelList[index].avatar,
                      liveModel: modelList[index].liveModel);
                }),
              ),
            if (modelList.isEmpty) NothingIsHere()
          ],
        );
      },
    );
  }
}
