import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/constants/typography.dart';
import '../../../../../utils/theme/colors_constant.dart';

const _kGlobeFrontScale = 0.42;

class GlobeMember {
  final String name;
  final String avatarUrl;

  const GlobeMember(this.name, this.avatarUrl);
}

/// Hilo-style invisible 3D globe with floating user avatars (PlanetsView port).
class TouchVoicePlanetsGlobe extends StatefulWidget {
  const TouchVoicePlanetsGlobe({
    Key? key,
    required this.members,
    this.height,
  }) : super(key: key);

  final List<GlobeMember> members;
  final double? height;

  @override
  State<TouchVoicePlanetsGlobe> createState() => _TouchVoicePlanetsGlobeState();
}

class _TouchVoicePlanetsGlobeState extends State<TouchVoicePlanetsGlobe>
    with SingleTickerProviderStateMixin {
  static const _radiusPercent = 0.8;
  static const _scaleFactor = 0.6;
  static const _scrollSpeed = 3.0;
  static const _tiltX = 22.0;
  static const _dragSens = 0.62;
  static const _autoDegPerSec = _scrollSpeed * 5;
  static const _friction = 0.85;
  static const _velSmooth = 0.22;

  late final AnimationController _controller;
  late List<_SpherePoint> _spherePoints;

  double _angleX = _tiltX;
  double _angleY = 0;
  double _velX = 0;
  double _velY = _autoDegPerSec;
  bool _dragging = false;
  Offset _lastDrag = Offset.zero;
  DateTime _lastMoveTime = DateTime.now();
  double _lastFrameSeconds = 0;

  @override
  void initState() {
    super.initState();
    _spherePoints = _fibonacciSphere(_memberCount);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _controller.addListener(_onFrame);
  }

  @override
  void didUpdateWidget(covariant TouchVoicePlanetsGlobe oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.members.length != widget.members.length) {
      _spherePoints = _fibonacciSphere(_memberCount);
    }
  }

  int get _memberCount => math.max(1, widget.members.length);

  @override
  void dispose() {
    _controller
      ..removeListener(_onFrame)
      ..dispose();
    super.dispose();
  }

  void _onFrame() {
    if (!mounted || !TickerMode.of(context)) return;

    final elapsed = _controller.lastElapsedDuration?.inMicroseconds ?? 0;
    final elapsedSeconds = elapsed / 1000000;
    final dt = _lastFrameSeconds == 0
        ? 0.016
        : (elapsedSeconds - _lastFrameSeconds).clamp(0.0, 0.05);
    _lastFrameSeconds = elapsedSeconds;

    if (!_dragging) {
      _angleX += _velX * dt;
      _angleY += _velY * dt;

      final decay = math.exp(-_friction * dt);
      _velX *= decay;
      _velY *= decay;

      final blend = 1 - math.exp(-1.8 * dt);
      _velY += (_autoDegPerSec - _velY) * blend;

      // Keep a fixed tilt — globe spins mostly on Y like a ball.
      _angleX += (_tiltX - _angleX) * (1 - math.exp(-2.4 * dt));
      if (_velX.abs() < 0.5) _velX = 0;
    }

    setState(() {});
  }

  List<_SpherePoint> _fibonacciSphere(int n) {
    final count = math.max(1, n);
    final pts = <_SpherePoint>[];
    for (var i = 1; i <= count; i++) {
      final phi = math.acos((2 * i - 1) / count - 1);
      final theta = math.sqrt(count * math.pi) * phi;
      pts.add(_SpherePoint(
        ox: math.cos(theta) * math.sin(phi),
        oy: math.sin(theta) * math.sin(phi),
        oz: math.cos(phi),
      ));
    }
    return pts;
  }

  _SineCosine _sineCosine(double ax, double ay) {
    final rx = ax * math.pi / 180;
    final ry = ay * math.pi / 180;
    return _SineCosine(
      sinX: math.sin(rx),
      cosX: math.cos(rx),
      sinY: math.sin(ry),
      cosY: math.cos(ry),
    );
  }

  _RotatedPoint _rotatePoint(_RotatedPoint p, _SineCosine s) {
    var y = p.y * s.cosX + p.z * (-s.sinX);
    var z = p.y * s.sinX + p.z * s.cosX;
    var x = p.x * s.cosY + z * s.sinY;
    z = -p.x * s.sinY + z * s.cosY;
    return _RotatedPoint(x: x, y: y, z: z);
  }

  _ProjectedPoint _project(
    _SpherePoint p,
    double cx,
    double cy,
    double radius,
  ) {
    final safeRadius = math.max(radius, 40.0);
    final s = _sineCosine(_angleX, _angleY);
    final r = _rotatePoint(
      _RotatedPoint(
        x: p.ox * safeRadius,
        y: p.oy * safeRadius,
        z: p.oz * safeRadius,
      ),
      s,
    );
    final depth = r.z;
    final rawScale = (2 * safeRadius) / (depth + 2 * safeRadius);
    final scale = rawScale * _scaleFactor;
    final depthNorm = depth / safeRadius;
    final alpha = depthNorm > 0.25
        ? math.max(0.12, (1 - depthNorm) * 0.55)
        : math.max(0.18, (1 - (depth - safeRadius) / (2 * safeRadius)) * 2.2);
    return _ProjectedPoint(
      sx: cx + r.x,
      sy: cy + r.y + depth * 0.06,
      scale: math.max(0.08, scale),
      alpha: alpha.clamp(0.0, 1.0),
      depth: depth,
    );
  }

  void _onPanStart(DragStartDetails details) {
    _dragging = true;
    _lastDrag = details.localPosition;
    _lastMoveTime = DateTime.now();
  }

  void _onPanUpdate(DragUpdateDetails details, double radius) {
    if (!_dragging) return;
    final now = DateTime.now();
    final moveDt = math.max(
      now.difference(_lastMoveTime).inMicroseconds / 1000000,
      0.008,
    );
    _lastMoveTime = now;

    final dx = details.localPosition.dx - _lastDrag.dx;
    final dy = details.localPosition.dy - _lastDrag.dy;
    _lastDrag = details.localPosition;

    final r = math.max(radius, 60.0);
    final rotY = (-dx / r) * 165 * _dragSens;
    final rotX = (dy / r) * 165 * _dragSens;

    _angleY += rotY;
    _angleX += rotX;

    final instantVelY = rotY / moveDt;
    final instantVelX = rotX / moveDt;
    _velY = _velY * (1 - _velSmooth) + instantVelY * _velSmooth;
    _velX = _velX * (1 - _velSmooth) + instantVelX * _velSmooth;
  }

  void _onPanEnd(DragEndDetails details) {
    _dragging = false;
  }

  @override
  Widget build(BuildContext context) {
    final globeHeight = widget.height ?? 365.h;

    if (widget.members.isEmpty) {
      return _globeShell(
        height: globeHeight,
        child: Center(
          child: Text(
            'No members online',
            style: sfProDisplayRegular.copyWith(
              fontSize: 13.sp,
              color: AppColors.textSecondaryColor,
            ),
          ),
        ),
      );
    }

    return _globeShell(
      height: globeHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenW = MediaQuery.of(context).size.width;
          final w = constraints.maxWidth > 0
              ? constraints.maxWidth
              : screenW;
          final h = constraints.maxHeight > 0
              ? constraints.maxHeight
              : globeHeight;
          final cx = w / 2;
          final cy = h * 0.54;
          final radius = math.min(w, h) * _radiusPercent * 0.5;

          final projected = <_GlobeRenderItem>[];
          final count = math.min(widget.members.length, _spherePoints.length);
          for (var i = 0; i < count; i++) {
            projected.add(_GlobeRenderItem(
              member: widget.members[i],
              projected: _project(_spherePoints[i], cx, cy, radius),
            ));
          }
          projected.sort((a, b) => a.projected.depth.compareTo(b.projected.depth));

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: _onPanStart,
            onPanUpdate: (d) => _onPanUpdate(d, radius),
            onPanEnd: _onPanEnd,
            child: SizedBox(
              width: w,
              height: h,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  for (final item in projected)
                    _GlobeAvatarItem(
                      member: item.member,
                      projected: item.projected,
                      pulse: _controller,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _globeShell({required double height, required Widget child}) {
    return Center(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: child,
      ),
    );
  }
}

class _GlobeAvatarItem extends StatelessWidget {
  const _GlobeAvatarItem({
    required this.member,
    required this.projected,
    required this.pulse,
  });

  final GlobeMember member;
  final _ProjectedPoint projected;
  final AnimationController pulse;

  static const _ringColor = AppColors.diamondBlue;
  static const _nameColor = AppColors.textPrimaryColor;

  @override
  Widget build(BuildContext context) {
    final scale = projected.scale.clamp(0.08, 1.2);
    final isFront = scale >= _kGlobeFrontScale;
    final baseSize = 70.w;
    final avatarSize = 48.w;
    final left = projected.sx - baseSize / 2;
    final top = projected.sy + baseSize * scale * 0.12 - baseSize / 2;
    final opacity = (isFront ? 1.0 : projected.alpha).clamp(0.0, 1.0);
    final showName = isFront;

    return Positioned(
      left: left,
      top: top,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          alignment: Alignment.center,
          filterQuality: FilterQuality.high,
          child: SizedBox(
            width: baseSize,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: baseSize,
                  height: baseSize,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      if (isFront)
                        AnimatedBuilder(
                          animation: pulse,
                          builder: (context, child) {
                            final t = pulse.value.clamp(0.0, 1.0);
                            final ringScale = 0.85 + t * 0.4;
                            final ringOpacity = (0.7 * (1 - t)).clamp(0.0, 1.0);
                            return Transform.scale(
                              scale: ringScale,
                              child: Container(
                                width: baseSize,
                                height: baseSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _ringColor.withOpacity(ringOpacity),
                                    width: 3,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      _GlobeAvatarCircle(
                        size: avatarSize,
                        imageUrl: member.avatarUrl,
                      ),
                    ],
                  ),
                ),
                if (showName) ...[
                  SizedBox(height: 2.h),
                  Text(
                    member.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: sfProDisplayMedium.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: _nameColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlobeAvatarCircle extends StatelessWidget {
  const _GlobeAvatarCircle({
    required this.size,
    required this.imageUrl,
  });

  final double size;
  final String imageUrl;

  static const _ringColor = AppColors.diamondBlue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _ringColor, width: 2),
        color: AppColors.cardBackground,
      ),
      child: ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: size,
            height: size,
            placeholder: (_, __) => Icon(
              Icons.person,
              color: AppColors.textSecondaryColor,
              size: size * 0.45,
            ),
            errorWidget: (_, __, ___) => Icon(
              Icons.person,
              color: AppColors.textSecondaryColor,
              size: size * 0.45,
            ),
          ),
        ),
      ),
    );
  }
}

class _SpherePoint {
  final double ox;
  final double oy;
  final double oz;

  const _SpherePoint({
    required this.ox,
    required this.oy,
    required this.oz,
  });
}

class _RotatedPoint {
  final double x;
  final double y;
  final double z;

  const _RotatedPoint({
    required this.x,
    required this.y,
    required this.z,
  });
}

class _SineCosine {
  final double sinX;
  final double cosX;
  final double sinY;
  final double cosY;

  const _SineCosine({
    required this.sinX,
    required this.cosX,
    required this.sinY,
    required this.cosY,
  });
}

class _ProjectedPoint {
  final double sx;
  final double sy;
  final double scale;
  final double alpha;
  final double depth;

  const _ProjectedPoint({
    required this.sx,
    required this.sy,
    required this.scale,
    required this.alpha,
    required this.depth,
  });
}

class _GlobeRenderItem {
  final GlobeMember member;
  final _ProjectedPoint projected;

  const _GlobeRenderItem({
    required this.member,
    required this.projected,
  });
}

/// 20 demo members for the New tab globe preview.
class TouchVoiceGlobeDemoMembers {
  TouchVoiceGlobeDemoMembers._();

  static const members = [
    GlobeMember('Hana', 'https://i.pravatar.cc/96?img=20'),
    GlobeMember('Amira', 'https://i.pravatar.cc/96?img=32'),
    GlobeMember('Nour', 'https://i.pravatar.cc/96?img=15'),
    GlobeMember('Zara', 'https://i.pravatar.cc/96?img=5'),
    GlobeMember('Yasmin', 'https://i.pravatar.cc/96?img=38'),
    GlobeMember('Kira', 'https://i.pravatar.cc/96?img=9'),
    GlobeMember('Maya', 'https://i.pravatar.cc/96?img=26'),
    GlobeMember('Layla', 'https://i.pravatar.cc/96?img=47'),
    GlobeMember('Sofia', 'https://i.pravatar.cc/96?img=11'),
    GlobeMember('Lina', 'https://i.pravatar.cc/96?img=44'),
    GlobeMember('Rania', 'https://i.pravatar.cc/96?img=12'),
    GlobeMember('Dina', 'https://i.pravatar.cc/96?img=23'),
    GlobeMember('Sara', 'https://i.pravatar.cc/96?img=31'),
    GlobeMember('Leila', 'https://i.pravatar.cc/96?img=36'),
    GlobeMember('Mona', 'https://i.pravatar.cc/96?img=41'),
    GlobeMember('Aisha', 'https://i.pravatar.cc/96?img=48'),
    GlobeMember('Noor', 'https://i.pravatar.cc/96?img=52'),
    GlobeMember('Mira', 'https://i.pravatar.cc/96?img=57'),
    GlobeMember('Jana', 'https://i.pravatar.cc/96?img=63'),
    GlobeMember('Tala', 'https://i.pravatar.cc/96?img=68'),
  ];
}
