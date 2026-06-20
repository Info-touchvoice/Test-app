import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:tiki/view/screens/reels/reels_home_screen.dart';
import 'package:tiki/view_model/home_nav_controller.dart';

import '../home_screen/home_screen.dart';

class HomeNavScreen extends StatelessWidget {
  const HomeNavScreen();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeNavController>(builder: (controller) {
      if (controller.showHomeLiveView) {
        return HomeView();
      } else {
        return ReelsHomeScreen();
      }
    });
  }
}
