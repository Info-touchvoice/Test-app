import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_setting_constants.dart';

enum HiloRoomTextField {
  name,
  introduction,
  announcement,
  autoWelcome,
}

class HiloRoomTextEditScreen extends StatefulWidget {
  final HiloRoomTextField field;
  final String initialValue;
  final int maxLength;

  const HiloRoomTextEditScreen({
    Key? key,
    required this.field,
    required this.initialValue,
    this.maxLength = 500,
  }) : super(key: key);

  static Future<String?> open(
    BuildContext context, {
    required HiloRoomTextField field,
    required String initialValue,
    int maxLength = 500,
  }) {
    return Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => HiloRoomTextEditScreen(
          field: field,
          initialValue: initialValue,
          maxLength: maxLength,
        ),
      ),
    );
  }

  String get _title {
    switch (field) {
      case HiloRoomTextField.name:
        return 'Name';
      case HiloRoomTextField.introduction:
        return 'Introduction';
      case HiloRoomTextField.announcement:
        return 'Announcement';
      case HiloRoomTextField.autoWelcome:
        return 'Automatic Welcome';
    }
  }

  @override
  State<HiloRoomTextEditScreen> createState() => _HiloRoomTextEditScreenState();
}

class _HiloRoomTextEditScreenState extends State<HiloRoomTextEditScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.pop(context, _controller.text.trim());
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
          widget._title,
          style: sfProDisplayMedium.copyWith(
            fontSize: 15.sp,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              'Save',
              style: sfProDisplayMedium.copyWith(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: HiloRoomSettingColors.rowBg,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: TextField(
              controller: _controller,
              maxLines: widget.field == HiloRoomTextField.name ? 2 : 6,
              maxLength: widget.maxLength,
              style: sfProDisplayRegular.copyWith(
                fontSize: 13.sp,
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_controller.text.characters.length}/${widget.maxLength}',
                style: sfProDisplayRegular.copyWith(
                  fontSize: 12.sp,
                  color: HiloRoomSettingColors.hint,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
