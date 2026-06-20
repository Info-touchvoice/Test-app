import 'package:flutter/material.dart';
import 'package:tiki/utils/theme/colors_constant.dart';

class GradientWrapper extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final bool applyGradient;

  const GradientWrapper({
    Key? key,
    required this.child,
    this.gradient,
    this.applyGradient = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!applyGradient) return child;

    return ShaderMask(
      shaderCallback: (bounds) {
        return (gradient ?? AppColors.secondaryGradient(stops: [0.0, 1.0]))
            .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      },
      blendMode: BlendMode
          .srcIn, // Keeps only the shape of the child visible with gradient
      child: child,
    );
  }
}

class GradientCircularBorder extends StatelessWidget {
  final Widget child;
  final double borderWidth;
  final Gradient? gradient;
  final double size; // total diameter of the circle
  final Color? backgroundColor;

  const GradientCircularBorder({
    Key? key,
    required this.child,
    this.gradient,
    this.borderWidth = 3.0,
    this.size = 60,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient ?? AppColors.secondaryGradient(stops: [0.0, 1.0]),
      ),
      child: Padding(
        padding: EdgeInsets.all(borderWidth),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor ?? Colors.transparent,
          ),
          child: child,
        ),
      ),
    );
  }
}
