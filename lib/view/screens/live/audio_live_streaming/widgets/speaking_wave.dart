import 'package:flutter/material.dart';

enum SpeakingWaveShape { circle, roundedRect }

/// A "voice activity" ripple animation that wraps a widget.
/// When [isSpeaking] is false, it just returns [child].
class SpeakingWave extends StatefulWidget {
  final bool isSpeaking;
  final double? size;
  final Color color;
  final Widget child;
  final SpeakingWaveShape shape;
  final double borderRadius;
  final int ringCount;
  final double maxScaleDelta;
  final double maxOpacity;
  final double strokeWidth;
  final bool glow;
  final double glowOpacity;
  final double glowBlurRadius;
  final double glowSpreadRadius;
  final Clip clipBehavior;

  const SpeakingWave({
    Key? key,
    required this.isSpeaking,
    this.size,
    required this.color,
    required this.child,
    this.shape = SpeakingWaveShape.circle,
    this.borderRadius = 12,
    this.ringCount = 3,
    this.maxScaleDelta = 0.55,
    this.maxOpacity = 0.75,
    this.strokeWidth = 3,
    this.glow = true,
    this.glowOpacity = 0.35,
    this.glowBlurRadius = 16,
    this.glowSpreadRadius = 2,
    this.clipBehavior = Clip.none,
  }) : super(key: key);

  @override
  State<SpeakingWave> createState() => _SpeakingWaveState();
}

class _SpeakingWaveState extends State<SpeakingWave>
    with SingleTickerProviderStateMixin {
  AnimationController? _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (widget.isSpeaking) {
      _ctrl!.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant SpeakingWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    final ctrl = _ctrl;
    if (ctrl == null) return;
    if (oldWidget.isSpeaking != widget.isSpeaking) {
      if (widget.isSpeaking) {
        ctrl.repeat();
      } else {
        ctrl.stop();
        ctrl.value = 0.0;
      }
    }
  }

  @override
  void dispose() {
    _ctrl?.dispose();
    _ctrl = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isSpeaking || _ctrl == null) return widget.child;

    final int rings = widget.ringCount < 1 ? 1 : widget.ringCount;
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < rings; i++) {
      children.add(
        Positioned.fill(
          child: _Ring(
            animation: _ctrl!,
            phase: i / rings,
            color: widget.color,
            shape: widget.shape,
            borderRadius: widget.borderRadius,
            maxScaleDelta: widget.maxScaleDelta,
            maxOpacity: widget.maxOpacity,
            strokeWidth: widget.strokeWidth,
            glow: widget.glow,
            glowOpacity: widget.glowOpacity,
            glowBlurRadius: widget.glowBlurRadius,
            glowSpreadRadius: widget.glowSpreadRadius,
          ),
        ),
      );
    }
    children.add(widget.child);

    final stack = Stack(
      alignment: Alignment.center,
      clipBehavior: widget.clipBehavior,
      children: children,
    );

    if (widget.size != null) {
      return SizedBox(width: widget.size, height: widget.size, child: stack);
    }
    return stack;
  }
}

class _Ring extends StatelessWidget {
  final AnimationController animation;
  final double phase;
  final Color color;
  final SpeakingWaveShape shape;
  final double borderRadius;
  final double maxScaleDelta;
  final double maxOpacity;
  final double strokeWidth;
  final bool glow;
  final double glowOpacity;
  final double glowBlurRadius;
  final double glowSpreadRadius;

  const _Ring({
    required this.animation,
    required this.phase,
    required this.color,
    required this.shape,
    required this.borderRadius,
    required this.maxScaleDelta,
    required this.maxOpacity,
    required this.strokeWidth,
    required this.glow,
    required this.glowOpacity,
    required this.glowBlurRadius,
    required this.glowSpreadRadius,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        // 0..1 progress with phase shift
        final t = (animation.value + phase) % 1.0;
        final scale = 1.0 + (t * maxScaleDelta);
        final opacity = (1.0 - t).clamp(0.0, 1.0);

        return Opacity(
          opacity: maxOpacity * opacity,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                shape: shape == SpeakingWaveShape.circle ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: shape == SpeakingWaveShape.roundedRect ? BorderRadius.circular(borderRadius) : null,
                border: Border.all(
                  color: color.withOpacity(0.85),
                  width: strokeWidth,
                ),
                boxShadow: glow
                    ? [
                        BoxShadow(
                          color: color.withOpacity(glowOpacity),
                          blurRadius: glowBlurRadius,
                          spreadRadius: glowSpreadRadius,
                        ),
                      ]
                    : const [],
              ),
            ),
          ),
        );
      },
    );
  }
}

