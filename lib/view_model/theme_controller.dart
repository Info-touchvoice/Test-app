import 'package:get/get.dart';
import 'package:tiki/utils/theme/theme_helper.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  RxBool darkTheme = false.obs;

  @override
  void onInit() {
    super.onInit();
    Get.changeTheme(ThemeHelper.lightTheme);
    darkTheme.value = false;
  }

  void toggleTheme() {
    final bool useLight = Get.isDarkMode;
    Get.changeTheme(useLight ? ThemeHelper.lightTheme : ThemeHelper.darkTheme);
    darkTheme.value = !useLight;
    update();
  }
}
