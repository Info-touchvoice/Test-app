import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/helpers/quick_help.dart';
import 'package:tiki/services/room_settings_store.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/audio_room_layout_helper.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_setting_constants.dart';
import 'package:tiki/view_model/live_controller.dart';
import 'package:tiki/view_model/zego_controller.dart';

class HiloRoomMicPickerScreen extends StatefulWidget {
  final int initialCount;

  const HiloRoomMicPickerScreen({Key? key, required this.initialCount})
      : super(key: key);

  static Future<int?> open(BuildContext context, {required int initialCount}) {
    return Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (_) => HiloRoomMicPickerScreen(initialCount: initialCount),
      ),
    );
  }

  @override
  State<HiloRoomMicPickerScreen> createState() => _HiloRoomMicPickerScreenState();
}

class _HiloRoomMicPickerScreenState extends State<HiloRoomMicPickerScreen> {
  late int _selected;
  final LiveViewModel _vm = Get.find();

  String? get _previewBackground {
    if (_vm.presetThemeUrl != null && _vm.presetThemeUrl!.isNotEmpty) {
      return _vm.presetThemeUrl;
    }
    if (_vm.backgroundImage?.url != null) return _vm.backgroundImage!.url;
    if (_vm.customThemeUrl != null) return _vm.customThemeUrl;
    return null;
  }

  @override
  void initState() {
    super.initState();
    _selected = AudioRoomLayoutHelper.clampCoHostCount(widget.initialCount);
  }

  Future<void> _confirm() async {
    final count = AudioRoomLayoutHelper.clampCoHostCount(_selected);
    _vm.liveStreamingModel.setAudioSeats = count;
    await _vm.liveStreamingModel.save();

    final settings = await RoomSettingsStore.load(
      _vm.liveStreamingModel.objectId,
      _vm.liveStreamingModel,
      defaultIntro: '${_vm.liveStreamingModel.getTitle ?? 'Room'} Room',
    );
    settings.micCount = count;
    await RoomSettingsStore.save(_vm.liveStreamingModel.objectId, settings);
    _vm.update();

    if (Get.isRegistered<ZegoController>()) {
      Get.find<ZegoController>().updateAudioSeatCount(count);
    }
    _vm.applyRoomThemeSettings(settings);

    if (mounted) {
      Navigator.pop(context, count);
      QuickHelp.showAppNotificationAdvanced(
        context: context,
        title: 'Mic seats updated',
        message: 'Your room now shows $count seat${count == 1 ? '' : 's'}.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HiloRoomSettingColors.bodyBg,
      appBar: AppBar(
        backgroundColor: HiloRoomSettingColors.toolbarBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Number of Mic',
          style: sfProDisplayMedium.copyWith(fontSize: 15.sp, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 0),
              child: Column(
                children: [
                  _MicNumberGrid(
                    selected: _selected,
                    onSelected: (v) => setState(() => _selected = v),
                  ),
                  SizedBox(height: 24.h),
                  _SeatPreview(
                    seatCount: _selected,
                    backgroundUrl: _previewBackground,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 12.h),
              child: SizedBox(
                width: double.infinity,
                height: 44.h,
                child: ElevatedButton(
                  onPressed: _confirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HiloRoomSettingColors.customBar,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Confirm',
                    style: sfProDisplayMedium.copyWith(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MicNumberGrid extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelected;

  const _MicNumberGrid({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 1.55,
      ),
      itemCount: AudioRoomLayoutHelper.maxCoHostSeats,
      itemBuilder: (_, index) {
        final number = index + 1;
        final isSelected = number == selected;
        return GestureDetector(
          onTap: () => onSelected(number),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? HiloRoomSettingColors.customBar
                  : const Color(0xFF3A364F),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '$number',
              style: sfProDisplayMedium.copyWith(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SeatPreview extends StatelessWidget {
  final int seatCount;
  final String? backgroundUrl;

  const _SeatPreview({required this.seatCount, this.backgroundUrl});

  @override
  Widget build(BuildContext context) {
    final count = AudioRoomLayoutHelper.clampCoHostCount(seatCount);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 280.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1530),
          border: Border.all(color: Colors.white12),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (backgroundUrl != null)
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: CachedNetworkImage(
                  imageUrl: backgroundUrl!,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              )
            else
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2A2340), Color(0xFF151320)],
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final metrics = AudioRoomLayoutHelper.gridMetricsFor(
                    seatCount: count,
                    maxWidth: constraints.maxWidth,
                    maxHeight: constraints.maxHeight,
                  );
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(metrics.rows, (rowIndex) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: rowIndex < metrics.rows - 1
                              ? metrics.mainSpacing
                              : 0,
                        ),
                        child: Row(
                          children: List.generate(metrics.columns, (colIndex) {
                            final index = rowIndex * metrics.columns + colIndex;
                            if (index >= count) {
                              return Expanded(
                                child: SizedBox(height: metrics.rowHeight),
                              );
                            }
                            return Expanded(
                              child: SizedBox(
                                height: metrics.rowHeight,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: metrics.iconSize,
                                      width: metrics.iconSize,
                                      decoration: const BoxDecoration(
                                        color: Color(0x662C2931),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.mic_none_rounded,
                                        size: metrics.iconSize * 0.48,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    SizedBox(height: metrics.labelGap),
                                    Text(
                                      '${index + 1}',
                                      style: sfProDisplayRegular.copyWith(
                                        fontSize: metrics.nameFontSize,
                                        color: Colors.white70,
                                        height: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
