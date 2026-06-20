import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiki/view/screens/live/multi_live_streaming/widgets/multi_live_view/multi_live_view.dart';
import 'package:tiki/view/screens/live/multi_live_streaming/widgets/multi_live_view/youtube_view.dart';
import 'package:tiki/view_model/animation_controller.dart';
import 'package:tiki/view_model/live_controller.dart';

import '../../../../view_model/whisper_list_controller.dart';
import '../../../../view_model/youtube_controller.dart';
import '../widgets/audio_live_top_bar.dart';
import '../widgets/bottom_card.dart';
import '../widgets/chat_text_field.dart';

class MultiLiveWidget extends StatelessWidget {
  MultiLiveWidget();

  @override
  Widget build(BuildContext context) {
    final AnimationViewModel animationViewModel = Get.find();
    WhisperListViewModel whisperListViewModel = Get.put(WhisperListViewModel());
    YoutubeController youtubeController = Get.put(YoutubeController());
    LiveViewModel liveViewModel = Get.find();
    return Stack(
      children: [
        Positioned.fill(
          child: GetBuilder<LiveViewModel>(builder: (liveViewModel) {
            return Column(
              children: [
                SizedBox(height: 45),
                AudioLiveTopBar(),
                if (!(liveViewModel.liveStreamingModel.getYoutube ?? false))
                  Expanded(child: MultiGuestView()),
                if (liveViewModel.liveStreamingModel.getYoutube == true)
                  Expanded(child: YoutubeView()),
                BottomCard()
              ],
            );
          }),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Obx(() {
            if (liveViewModel.chatField.value == true)
              return ChatTextField();
            else
              return SizedBox();
          }),
        )
      ],
    );
  }
}
