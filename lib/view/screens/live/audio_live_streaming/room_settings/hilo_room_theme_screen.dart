import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/services/room_settings_store.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_custom_theme_screen.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_setting_constants.dart';
import 'package:tiki/view_model/live_controller.dart';

class HiloRoomThemeScreen extends StatefulWidget {
  final RoomSettingsData settings;

  const HiloRoomThemeScreen({Key? key, required this.settings}) : super(key: key);

  static Future<void> open(BuildContext context, RoomSettingsData settings) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HiloRoomThemeScreen(settings: settings),
      ),
    );
  }

  @override
  State<HiloRoomThemeScreen> createState() => _HiloRoomThemeScreenState();
}

class _HiloRoomThemeScreenState extends State<HiloRoomThemeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final LiveViewModel _vm = Get.find();

  String? get _selectedPreset => widget.settings.activePresetTheme;
  String? get _selectedCustom => widget.settings.activeCustomThemeUrl;

  Future<void> _applyPreset(String asset) async {
    widget.settings.activePresetTheme = asset;
    widget.settings.activeCustomThemeUrl = null;
    _vm.liveStreamingModel.setBackgroundImage = null;
    await _vm.liveStreamingModel.save();
    _vm.applyRoomThemeSettings(widget.settings);
    await _save();
  }

  Future<void> _applyCustom(String url) async {
    widget.settings.activeCustomThemeUrl = url;
    widget.settings.activePresetTheme = null;
    _vm.applyRoomThemeSettings(widget.settings);
    await _save();
  }

  Future<void> _save() async {
    await RoomSettingsStore.save(_vm.liveStreamingModel.objectId, widget.settings);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HiloRoomSettingColors.toolbarBg,
      appBar: AppBar(
        backgroundColor: HiloRoomSettingColors.toolbarBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: TabBar(
          controller: _tabController,
          indicatorColor: Colors.transparent,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0x66FFFFFF),
          labelStyle: sfProDisplayMedium.copyWith(fontSize: 15.sp),
          unselectedLabelStyle: sfProDisplayRegular.copyWith(fontSize: 15.sp),
          tabs: const [
            Tab(text: 'Theme'),
            Tab(text: 'My'),
          ],
        ),
        actions: [
          if (_tabController.index == 1)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                await HiloRoomCustomThemeScreen.open(context, widget.settings);
                setState(() {});
              },
            )
          else
            SizedBox(width: 48.w),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PresetGrid(
            selected: _selectedPreset,
            onSelect: _applyPreset,
          ),
          _MyThemesGrid(
            urls: widget.settings.myThemeUrls,
            selected: _selectedCustom,
            onSelect: _applyCustom,
            onAdd: () async {
              await HiloRoomCustomThemeScreen.open(context, widget.settings);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}

class _PresetGrid extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;

  const _PresetGrid({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(12.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 0.62,
      ),
      itemCount: HiloRoomSettingAssets.hdPresetThemes.length,
      itemBuilder: (_, index) {
        final url = HiloRoomSettingAssets.hdPresetThemes[index];
        final isSelected = selected == url;
        return GestureDetector(
          onTap: () => onSelect(url),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: CachedNetworkImage(
                  imageUrl: url,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
              if (isSelected)
                Positioned(
                  right: 10.w,
                  bottom: 10.h,
                  child: Container(
                    width: 21.w,
                    height: 21.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      color: HiloRoomSettingColors.customBar,
                    ),
                    child: Icon(Icons.check, size: 14.sp, color: Colors.white),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MyThemesGrid extends StatelessWidget {
  final List<String> urls;
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onAdd;

  const _MyThemesGrid({
    required this.urls,
    required this.selected,
    required this.onSelect,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_photo_alternate_outlined,
                size: 48.sp, color: HiloRoomSettingColors.hint),
            SizedBox(height: 12.h),
            Text(
              'Tap + to upload a custom background',
              style: sfProDisplayRegular.copyWith(
                fontSize: 13.sp,
                color: HiloRoomSettingColors.hint,
              ),
            ),
            SizedBox(height: 16.h),
            OutlinedButton(
              onPressed: onAdd,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
              ),
              child: const Text('Custom'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(12.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 0.62,
      ),
      itemCount: urls.length,
      itemBuilder: (_, index) {
        final url = urls[index];
        final isSelected = selected == url;
        return GestureDetector(
          onTap: () => onSelect(url),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: CachedNetworkImage(
                  imageUrl: url,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
              if (isSelected)
                Positioned(
                  right: 10.w,
                  bottom: 10.h,
                  child: Container(
                    width: 21.w,
                    height: 21.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      color: HiloRoomSettingColors.customBar,
                    ),
                    child: Icon(Icons.check, size: 14.sp, color: Colors.white),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
