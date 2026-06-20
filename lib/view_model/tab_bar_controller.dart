import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class TabBarViewModel extends GetxController {
  List<String> categories = ["audio"];

  RxInt selectedId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    selectedId.value = 0;
  }
}
