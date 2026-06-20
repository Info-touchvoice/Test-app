import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/view/screens/live/audio_live_streaming/room_settings/hilo_room_setting_constants.dart';

enum JoinedPasswordMode { public, passwordRestrictions }

class JoinedPasswordResult {
  final JoinedPasswordMode mode;
  final String? pin;

  const JoinedPasswordResult({required this.mode, this.pin});
}

class HiloRoomJoinedPasswordDialog {
  /// Step 1: Public vs Password Restrictions. Step 2: 4-digit PIN if needed.
  static Future<JoinedPasswordResult?> show(
    BuildContext context, {
    required bool isCurrentlyPrivate,
    String? currentPin,
  }) async {
    final mode = await showDialog<JoinedPasswordMode>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _JoinedPasswordModeDialog(
        initialMode: isCurrentlyPrivate
            ? JoinedPasswordMode.passwordRestrictions
            : JoinedPasswordMode.public,
      ),
    );
    if (mode == null || !context.mounted) return null;

    if (mode == JoinedPasswordMode.public) {
      return const JoinedPasswordResult(mode: JoinedPasswordMode.public);
    }

    final pin = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _JoinedPasswordPinDialog(initialPin: currentPin),
    );
    if (pin == null || pin.length != 4) return null;
    return JoinedPasswordResult(
      mode: JoinedPasswordMode.passwordRestrictions,
      pin: pin,
    );
  }
}

class _JoinedPasswordModeDialog extends StatefulWidget {
  final JoinedPasswordMode initialMode;

  const _JoinedPasswordModeDialog({required this.initialMode});

  @override
  State<_JoinedPasswordModeDialog> createState() =>
      _JoinedPasswordModeDialogState();
}

class _JoinedPasswordModeDialogState extends State<_JoinedPasswordModeDialog> {
  late JoinedPasswordMode _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialMode;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFF3A364F),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Joined Password',
              style: sfProDisplayMedium.copyWith(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.h),
            _RadioOption(
              label: 'Public',
              selected: _selected == JoinedPasswordMode.public,
              onTap: () => setState(
                () => _selected = JoinedPasswordMode.public,
              ),
            ),
            SizedBox(height: 12.h),
            _RadioOption(
              label: 'Password Restrictions',
              selected: _selected == JoinedPasswordMode.passwordRestrictions,
              onTap: () => setState(
                () => _selected = JoinedPasswordMode.passwordRestrictions,
              ),
            ),
            SizedBox(height: 22.h),
            _GradientConfirmButton(
              label: 'Confirm',
              onTap: () => Navigator.pop(context, _selected),
            ),
            SizedBox(height: 10.h),
            _OutlinedCancelButton(
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _JoinedPasswordPinDialog extends StatefulWidget {
  final String? initialPin;

  const _JoinedPasswordPinDialog({this.initialPin});

  @override
  State<_JoinedPasswordPinDialog> createState() =>
      _JoinedPasswordPinDialogState();
}

class _JoinedPasswordPinDialogState extends State<_JoinedPasswordPinDialog> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialPin != null && widget.initialPin!.length == 4) {
      _controller.text = widget.initialPin!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String get _pin => _controller.text;

  bool get _isValid => _pin.length == 4;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFF3A364F),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Joined Password',
              style: sfProDisplayMedium.copyWith(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () => _focusNode.requestFocus(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      final filled = index < _pin.length;
                      return Container(
                        width: 52.w,
                        height: 52.w,
                        margin: EdgeInsets.symmetric(horizontal: 6.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2640),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: filled
                                ? HiloRoomSettingColors.customBar
                                : Colors.white24,
                          ),
                        ),
                        child: filled
                            ? Text(
                                '•',
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      );
                    }),
                  ),
                  Opacity(
                    opacity: 0,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      autofocus: true,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),
            _GradientConfirmButton(
              label: 'Confirm',
              onTap: _isValid ? () => Navigator.pop(context, _pin) : null,
            ),
            SizedBox(height: 10.h),
            _OutlinedCancelButton(
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RadioOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: 22.w,
            height: 22.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? HiloRoomSettingColors.customBar
                    : Colors.white54,
                width: 2,
              ),
              color: selected ? HiloRoomSettingColors.customBar : Colors.transparent,
            ),
            child: selected
                ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: sfProDisplayRegular.copyWith(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientConfirmButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _GradientConfirmButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return SizedBox(
      width: double.infinity,
      height: 44.h,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22.r),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.r),
              gradient: enabled
                  ? const LinearGradient(
                      colors: [Color(0xFF9036FF), Color(0xFFB44DFF)],
                    )
                  : null,
              color: enabled ? null : Colors.white12,
            ),
            child: Center(
              child: Text(
                label,
                style: sfProDisplayMedium.copyWith(
                  fontSize: 15.sp,
                  color: enabled ? Colors.white : Colors.white38,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlinedCancelButton extends StatelessWidget {
  final VoidCallback onTap;

  const _OutlinedCancelButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.r),
          ),
        ),
        child: Text(
          'Cancel',
          style: sfProDisplayMedium.copyWith(
            fontSize: 15.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
