import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/helpers/quick_help.dart';
import 'package:tiki/parse/LiveStreamingModel.dart';
import 'package:tiki/services/my_audio_group_service.dart';
import 'package:tiki/services/room_settings_store.dart';
import 'package:tiki/utils/constants/app_constants.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/gradient_switch.dart';
import 'package:tiki/utils/permission/choose_photo_permission.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/audio_room_layout_helper.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_joined_password_dialog.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_action_records_screen.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_setting_constants.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_text_edit_screen.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_blocked_list_screen.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_mic_picker_screen.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_support_screen.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_theme_screen.dart';
import 'package:tiki/view_model/live_controller.dart';

class HiloRoomSettingScreen extends StatefulWidget {
  const HiloRoomSettingScreen({Key? key}) : super(key: key);

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HiloRoomSettingScreen()),
    );
  }

  @override
  State<HiloRoomSettingScreen> createState() => _HiloRoomSettingScreenState();
}

class _HiloRoomSettingScreenState extends State<HiloRoomSettingScreen> {
  final LiveViewModel _vm = Get.find();
  late RoomSettingsData _settings;
  bool _loading = true;

  LiveStreamingModel get _live => _vm.liveStreamingModel;

  String get _roomName {
    final title = _live.getTitle?.trim();
    if (title != null && title.isNotEmpty) return title;
    return _live.getAuthor?.getFullName ?? 'Touch Voice';
  }

  String get _defaultIntro => '$_roomName Room';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final data = await RoomSettingsStore.load(
      _live.objectId,
      _live,
      defaultIntro: _defaultIntro,
    );
    setState(() {
      _settings = data;
      _loading = false;
    });
  }

  Future<void> _persist({bool updateLive = true}) async {
    if (updateLive) {
      _live.setGoalTitle = _settings.roomIntroduction;
      _live.setStickerTitle = _settings.autoWelcome;
      _live.setCoHostAvailable = _settings.touristsOnMic;
      await _live.save();
      _vm.update();
    }
    await RoomSettingsStore.save(_live.objectId, _settings);
    setState(() {});
  }

  String get _joinedPasswordLabel {
    if (_live.getPrivate == true) return 'Password Restrictions';
    return 'Public';
  }

  Future<void> _editTextField(HiloRoomTextField field) async {
    String initial;
    int maxLen = 500;
    switch (field) {
      case HiloRoomTextField.name:
        initial = _roomName;
        maxLen = 40;
        break;
      case HiloRoomTextField.introduction:
        initial = _settings.roomIntroduction.isNotEmpty
            ? _settings.roomIntroduction
            : _defaultIntro;
        break;
      case HiloRoomTextField.announcement:
        initial = _live.getRoomAnnouncement?.trim().isNotEmpty == true
            ? _live.getRoomAnnouncement!.trim()
            : MyAudioGroupService.defaultRoomWelcome;
        break;
      case HiloRoomTextField.autoWelcome:
        initial = _settings.autoWelcome;
        break;
    }

    final result = await HiloRoomTextEditScreen.open(
      context,
      field: field,
      initialValue: initial,
      maxLength: maxLen,
    );
    if (result == null) return;

    switch (field) {
      case HiloRoomTextField.name:
        _live.setTitle = result;
        _vm.title.value = result;
        await _live.save();
        _vm.update();
        break;
      case HiloRoomTextField.introduction:
        _settings.roomIntroduction = result;
        await _persist();
        break;
      case HiloRoomTextField.announcement:
        _live.setRoomAnnouncement = result;
        _vm.roomAnnouncement.value = result;
        await _live.save();
        _vm.update();
        break;
      case HiloRoomTextField.autoWelcome:
        _settings.autoWelcome = result;
        await _persist();
        break;
    }
  }

  Future<void> _pickAvatar() async {
    await PermissionHandler.checkPermission(
      false,
      context,
      liveStreamingFile: true,
    );
    setState(() {});
  }

  Future<void> _pickJoinedPassword() async {
    final result = await HiloRoomJoinedPasswordDialog.show(
      context,
      isCurrentlyPrivate: _live.getPrivate == true,
      currentPin: _live.getPrivateKey,
    );
    if (result == null) return;

    if (result.mode == JoinedPasswordMode.public) {
      _live.setPrivate = false;
      _live.setPrivateKey = '';
    } else {
      final pin = result.pin;
      if (pin == null || pin.length != 4) return;
      _live.setPrivate = true;
      _live.setPrivateKey = pin;
    }
    await _live.save();
    setState(() {});
  }

  Future<void> _openMicPicker() async {
    final current = _live.getAudioSeats ??
        AudioRoomLayoutHelper.clampCoHostCount(_settings.micCount);
    final result = await HiloRoomMicPickerScreen.open(
      context,
      initialCount: current,
    );
    if (result != null) {
      _settings.micCount = result;
      await _loadSettings();
    }
  }

  int get _micCount =>
      _live.getAudioSeats ?? _settings.micCount;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: HiloRoomSettingColors.bodyBg,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final avatarUrl = _live.getImage?.url ?? _live.getAuthor?.getAvatar?.url;

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
          'Room Setting',
          style: sfProDisplayMedium.copyWith(
            fontSize: 15.sp,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          _SectionHeader(
            title: 'Avatar',
            trailing: _SquareAvatar(url: avatarUrl),
            onTap: _pickAvatar,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
            child: Row(
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
          ),
          SizedBox(height: 8.h),
          _ValueRow(
            label: 'Name',
            value: _roomName,
            onTap: () => _editTextField(HiloRoomTextField.name),
          ),
          _divider(),
          _ValueRow(
            label: 'Room Introduction',
            value: _settings.roomIntroduction.isNotEmpty
                ? _settings.roomIntroduction
                : _defaultIntro,
            onTap: () => _editTextField(HiloRoomTextField.introduction),
          ),
          _divider(),
          _ValueRow(
            label: 'Room Announcement',
            value: _live.getRoomAnnouncement?.trim().isNotEmpty == true
                ? _live.getRoomAnnouncement!.trim()
                : MyAudioGroupService.defaultRoomWelcome,
            onTap: () => _editTextField(HiloRoomTextField.announcement),
          ),
          _divider(),
          _ValueRow(
            label: 'Automatic Welcome',
            value: _settings.autoWelcome.isNotEmpty
                ? _settings.autoWelcome
                : 'Welcome message',
            onTap: () => _editTextField(HiloRoomTextField.autoWelcome),
          ),
          _divider(),
          _ArrowRow(label: 'Theme', onTap: () async {
            await HiloRoomThemeScreen.open(context, _settings);
            await _loadSettings();
          }),
          _divider(),
          _ValueRow(
            label: 'Mic',
            value: '$_micCount',
            onTap: _openMicPicker,
          ),
          SizedBox(height: 15.h),
          _ValueRow(
            label: 'Joined Password',
            value: _joinedPasswordLabel,
            onTap: _pickJoinedPassword,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15.w, 10.h, 36.w, 0),
            child: Text(
              HiloRoomSettingAssets.passwordTip,
              style: sfProDisplayRegular.copyWith(
                fontSize: 12.sp,
                color: HiloRoomSettingColors.hint,
                height: 1.35,
              ),
            ),
          ),
          SizedBox(height: 15.h),
          _ArrowRow(
            label: 'Room support',
            onTap: () => HiloRoomSupportScreen.open(context),
          ),
          SizedBox(height: 8.h),
          _SwitchRow(
            label: 'Tourists on mic',
            value: _settings.touristsOnMic,
            onChanged: (v) async {
              _settings.touristsOnMic = v;
              await _persist();
            },
          ),
          _divider(),
          _SwitchRow(
            label: 'Tourists send text',
            value: _settings.touristsSendText,
            onChanged: (v) async {
              _settings.touristsSendText = v;
              await _persist(updateLive: false);
            },
          ),
          _divider(),
          _SwitchRow(
            label: 'Tourists send pictures',
            value: _settings.touristsSendPictures,
            onChanged: (v) async {
              _settings.touristsSendPictures = v;
              await _persist(updateLive: false);
            },
          ),
          SizedBox(height: 8.h),
          _ArrowRow(
            label: 'Blocklist',
            onTap: () => HiloRoomBlockedListScreen.open(context),
          ),
          _divider(),
          _ArrowRow(
            label: 'Action records',
            onTap: () => HiloRoomActionRecordsScreen.open(context),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _divider() => Container(height: 0.5, color: HiloRoomSettingColors.divider);
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SectionHeader({
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: HiloRoomSettingColors.rowBg,
        height: 53.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: [
            Text(
              title,
              style: sfProDisplayRegular.copyWith(
                fontSize: 13.sp,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _SquareAvatar extends StatelessWidget {
  final String? url;

  const _SquareAvatar({this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        width: 34.w,
        height: 34.w,
        color: const Color(0xFF1A1530),
        child: url != null && url!.isNotEmpty
            ? CachedNetworkImage(imageUrl: url!, fit: BoxFit.cover)
            : Icon(Icons.person, color: Colors.white54, size: 20.sp),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDiamond;
  final VoidCallback onTap;

  const _ValueRow({
    required this.label,
    required this.value,
    required this.onTap,
    this.showDiamond = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: HiloRoomSettingColors.rowBg,
        height: 53.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: [
            Text(
              label,
              style: sfProDisplayRegular.copyWith(
                fontSize: 13.sp,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            if (showDiamond) ...[
              Image.asset(AppImagePath.diamondIcon, width: 14.w, height: 14.w),
              SizedBox(width: 3.w),
            ],
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: sfProDisplayRegular.copyWith(
                  fontSize: 13.sp,
                  color: showDiamond
                      ? HiloRoomSettingColors.diamond
                      : Colors.white,
                ),
              ),
            ),
            SizedBox(width: 9.w),
            Icon(Icons.chevron_right, size: 16.sp, color: HiloRoomSettingColors.hint),
          ],
        ),
      ),
    );
  }
}

class _ArrowRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ArrowRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: HiloRoomSettingColors.rowBg,
        height: 53.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: [
            Text(
              label,
              style: sfProDisplayRegular.copyWith(
                fontSize: 13.sp,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, size: 16.sp, color: HiloRoomSettingColors.hint),
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HiloRoomSettingColors.rowBg,
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 5.w, 14.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: sfProDisplayRegular.copyWith(
                fontSize: 13.sp,
                color: Colors.white,
              ),
            ),
          ),
          GradientCupertinoSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
