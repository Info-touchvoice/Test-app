import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../parse/UserModel.dart';
import '../../../../view_model/audio_home_view_model.dart';
import '../../../../view_model/ranking_controller.dart';
import '../../../../view_model/tab_bar_controller.dart';
import '../../../widgets/base_scaffold.dart';
import '../group/touchvoice_group_home_screen.dart';

class HomeView extends StatefulWidget {
  final UserModel? currentUser;

  HomeView({Key? key, this.currentUser}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TabBarViewModel tabBarViewModel = Get.put(TabBarViewModel());
  final AudioHomeViewModel audioHomeViewModel = Get.put(AudioHomeViewModel());
  final RankingViewModel rankingViewModel = Get.find();

  @override
  void initState() {
    super.initState();
    audioHomeViewModel.loadLive();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      safeArea: true,
      body: TouchVoiceGroupHomeScreen(currentUser: widget.currentUser),
    );
  }
}

