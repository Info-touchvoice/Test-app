import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../parse/UserModel.dart';
import '../../../view_model/trending_home_view_model.dart';
import '../../widgets/home_trending_widget.dart';

class HomeTrendingView extends StatefulWidget {
  final UserModel? currentUser;

  HomeTrendingView({Key? key, this.currentUser}) : super(key: key);

  @override
  State<HomeTrendingView> createState() => _HomeTrendingViewState();
}

class _HomeTrendingViewState extends State<HomeTrendingView> {
  final TrendingHomeViewModel trendingViewModel = Get.find();

  @override
  void initState() {
    trendingViewModel.loadLive();
    trendingViewModel.subscribeLiveStreamingModel();
    super.initState();
  }

  @override
  void dispose() {
    trendingViewModel.unSubscribeLiveStreamingModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrendingHomeViewModel>(
        init: trendingViewModel,
        builder: (controller) {
          // Hosted inside a parent ListView (HomeView) -> avoid Expanded.
          return HomeTrendingWidget();
        });
  }
}
