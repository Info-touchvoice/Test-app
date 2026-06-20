import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiki/view_model/audio_home_view_model.dart';

import '../../../parse/UserModel.dart';
import '../../widgets/home_audio_widget.dart';

class HomeAudioView extends StatefulWidget {
  final UserModel? currentUser;

  HomeAudioView({Key? key, this.currentUser}) : super(key: key);

  @override
  State<HomeAudioView> createState() => _HomeAudioViewState();
}

class _HomeAudioViewState extends State<HomeAudioView> {
  final AudioHomeViewModel audioViewModel = Get.find();

  @override
  void initState() {
    audioViewModel.loadLive();
    audioViewModel.subscribeLiveStreamingModel();
    super.initState();
  }

  @override
  void dispose() {
    audioViewModel.unSubscribeLiveStreamingModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioHomeViewModel>(
        init: audioViewModel,
        builder: (controller) {
          // Hosted inside a parent ListView (HomeView) -> avoid Expanded.
          return HomeAudioWidget();
        });
  }
}
