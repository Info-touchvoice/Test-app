import 'package:flutter/material.dart';

import '../utils/theme/colors_constant.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient? gradient;
  final Color? color;
  final bool useGradient;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const GradientText({
    Key? key,
    required this.text,
    this.style,
    this.gradient,
    this.color,
    this.useGradient = true,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!useGradient) {
      // Just show normal text with solid color
      return Text(
        text,
        style: style?.copyWith(color: color ?? style?.color),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    // Gradient text
    return ShaderMask(
      shaderCallback: (bounds) {
        return (gradient ?? AppColors.secondaryGradient(stops: [0.0, 1.0]))
            .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      },
      child: Text(
        text,
        style: style?.copyWith(color: Colors.white) ??
            const TextStyle(color: Colors.white),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
