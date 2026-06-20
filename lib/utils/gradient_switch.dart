import 'package:flutter/material.dart';
import 'package:tiki/utils/theme/colors_constant.dart';

class GradientCupertinoSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const GradientCupertinoSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  State<GradientCupertinoSwitch> createState() =>
      _GradientCupertinoSwitchState();
}

class _GradientCupertinoSwitchState extends State<GradientCupertinoSwitch>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final bool isOn = widget.value;

    return GestureDetector(
      onTap: () => widget.onChanged(!isOn),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 52,
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isOn
              ? AppColors.secondaryGradient(stops: const [0.0, 1.0])
              : null,
          color: isOn ? null : const Color(0xffcecece),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          curve: Curves.easeInOut,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
