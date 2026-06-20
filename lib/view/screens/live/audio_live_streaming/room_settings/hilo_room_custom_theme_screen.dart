import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/helpers/quick_help.dart';
import 'package:tiki/services/room_settings_store.dart';
import 'package:tiki/utils/constants/app_constants.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/permission/choose_photo_permission.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_setting_constants.dart';
import 'package:tiki/view_model/live_controller.dart';
import 'package:tiki/view_model/userViewModel.dart';

class HiloRoomCustomThemeScreen extends StatefulWidget {
  final RoomSettingsData settings;

  const HiloRoomCustomThemeScreen({Key? key, required this.settings})
      : super(key: key);

  static Future<void> open(BuildContext context, RoomSettingsData settings) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HiloRoomCustomThemeScreen(settings: settings),
      ),
    );
  }

  @override
  State<HiloRoomCustomThemeScreen> createState() => _HiloRoomCustomThemeScreenState();
}

class _HiloRoomCustomThemeScreenState extends State<HiloRoomCustomThemeScreen> {
  bool _uploading = false;
  final LiveViewModel _vm = Get.find();

  Future<void> _pickImage() async {
    await PermissionHandler.checkPermission(false, context, backgroundImage: true);
    final bg = _vm.liveStreamingModel.getBackgroundImage;
    if (bg?.url != null) {
      setState(() {});
    }
  }

  Future<void> _confirmCustom() async {
    final userVm = Get.find<UserViewModel>();
    final cost = HiloRoomSettingAssets.customThemeDiamondCost;

    if (!userVm.checkCoins(cost)) {
      QuickHelp.showAppNotificationAdvanced(
        context: context,
        title: 'Not enough diamonds',
        message: 'You need $cost diamonds to upload a custom background.',
        isError: true,
      );
      return;
    }

    setState(() => _uploading = true);
    try {
      if (_vm.liveStreamingModel.getBackgroundImage?.url == null) {
        await _pickImage();
      }

      final url = _vm.liveStreamingModel.getBackgroundImage?.url;
      if (url == null || url.isEmpty) {
        QuickHelp.showAppNotificationAdvanced(
          context: context,
          title: 'Upload failed',
          message: 'Please choose an image first.',
          isError: true,
        );
        return;
      }

      userVm.deductBalance(cost, save: true);

      if (!widget.settings.myThemeUrls.contains(url)) {
        widget.settings.myThemeUrls.insert(0, url);
      }
      widget.settings.activeCustomThemeUrl = url;
      widget.settings.activePresetTheme = null;
      _vm.backgroundImage = _vm.liveStreamingModel.getBackgroundImage;
      await RoomSettingsStore.save(_vm.liveStreamingModel.objectId, widget.settings);
      await _vm.liveStreamingModel.save();
      _vm.update();

      if (mounted) {
        Navigator.pop(context);
        QuickHelp.showAppNotificationAdvanced(
          context: context,
          title: 'Custom theme active',
          message:
              'Background active for ${HiloRoomSettingAssets.customThemeDays} days.',
        );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final previewUrl = _vm.liveStreamingModel.getBackgroundImage?.url;

    return Scaffold(
      backgroundColor: HiloRoomSettingColors.toolbarBg,
      appBar: AppBar(
        backgroundColor: HiloRoomSettingColors.toolbarBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Custom',
          style: sfProDisplayMedium.copyWith(
            fontSize: 15.sp,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                children: [
                  SizedBox(height: 56.h),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 163.w,
                      height: 289.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Colors.white54,
                          width: 1.5,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                      ),
                      child: previewUrl != null && previewUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                previewUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add,
                                    size: 42.sp, color: Colors.white70),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(height: 34.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.shield_outlined,
                          size: 16.sp, color: HiloRoomSettingColors.hint),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          HiloRoomSettingAssets.avatarPolicyText,
                          style: sfProDisplayRegular.copyWith(
                            fontSize: 11.sp,
                            color: HiloRoomSettingColors.hint,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: HiloRoomSettingColors.customBar,
            padding: EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h + MediaQuery.of(context).padding.bottom),
            child: Row(
              children: [
                Image.asset(AppImagePath.diamondIcon, width: 16.w, height: 13.h),
                SizedBox(width: 7.w),
                Text(
                  '${HiloRoomSettingAssets.customThemeDiamondCost}/${HiloRoomSettingAssets.customThemeDays}days',
                  style: sfProDisplayRegular.copyWith(
                    fontSize: 13.sp,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: _uploading ? null : _confirmCustom,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    minimumSize: Size(78.w, 26.h),
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                  ),
                  child: _uploading
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Custom',
                          style: sfProDisplayMedium.copyWith(fontSize: 13.sp),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
