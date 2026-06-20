import 'package:flutter/material.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/theme/colors_constant.dart';

class TagsChip extends StatelessWidget {
  final String text;
  final EdgeInsets padding;
  final bool isSelected;
  final VoidCallback onSelect;

  const TagsChip({
    required this.text,
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    this.isSelected = false,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isSelected ? null : AppColors.card,
          gradient: isSelected
              ? AppColors.secondaryGradient(stops: [0.0, 1.0])
              : null,
          border: Border.all(
              color: isSelected ? Colors.transparent : AppColors.divider,
              width: 1.5),
        ),
        child: Text(
          text,
          style: sfProDisplayBold.copyWith(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
