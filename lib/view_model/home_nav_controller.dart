import 'package:get/get.dart';

class HomeNavController extends GetxController {
  bool homeLiveView = false;
  int groupTabIndex = 0;

  set setHomeLiveView(bool value) {
    homeLiveView = value;
    update();
  }

  bool get showHomeLiveView => homeLiveView;

  void goToRelatedTab() {
    groupTabIndex = 0;
    update();
  }

  void setGroupTabIndex(int index) {
    if (groupTabIndex != index) {
      groupTabIndex = index;
      update();
    }
  }
}
