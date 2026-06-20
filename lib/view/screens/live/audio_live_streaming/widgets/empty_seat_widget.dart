import 'package:flutter/material.dart';

class EmptySeat extends StatelessWidget {
  final int seatNumber;
  final double iconSize;
  final double nameFontSize;
  final double labelGap;
  final bool isLocked;

  const EmptySeat(
    this.seatNumber, {
    required this.iconSize,
    required this.nameFontSize,
    required this.labelGap,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: iconSize,
          width: iconSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isLocked
                  ? const Color(0x44FFFFFF)
                  : const Color(0x55FFFFFF),
              shape: BoxShape.circle,
              border: isLocked
                  ? Border.all(color: Colors.white38, width: 1)
                  : null,
            ),
            child: Center(
              child: Icon(
                isLocked ? Icons.lock_rounded : Icons.mic_none_rounded,
                size: iconSize * (isLocked ? 0.5 : 0.48),
                color: isLocked ? Colors.white : Colors.white70,
              ),
            ),
          ),
        ),
        SizedBox(height: labelGap),
        Text(
          seatNumber.toString(),
          maxLines: 1,
          overflow: TextOverflow.clip,
          strutStyle: StrutStyle(
            fontSize: nameFontSize,
            height: 1,
            forceStrutHeight: true,
          ),
          style: TextStyle(
            color: Colors.white60,
            fontSize: nameFontSize,
            height: 1,
          ),
        ),
      ],
    );
  }
}
