import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/short_id_model.dart';

class ShortIdBadge extends StatelessWidget {
  final ShortIdModel shortId;
  final bool compact;
  final bool showIcon;

  const ShortIdBadge({
    Key? key,
    required this.shortId,
    this.compact = false,
    this.showIcon = true,
  }) : super(key: key);

  const ShortIdBadge.compact({
    Key? key,
    required this.shortId,
    this.showIcon = true,
  })  : compact = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final visual = _ShortIdBadgeVisualData.fromType(shortId.type);
    final double iconSize = compact ? 9.w : 13.w;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 5.w : 8.w,
        vertical: compact ? 2.h : 4.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: visual.colors,
        ),
        borderRadius: BorderRadius.circular(compact ? 8.r : 14.r),
        border: Border.all(
          color: visual.borderColor.withOpacity(0.85),
          width: compact ? 0.6 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: visual.shadowColor.withOpacity(compact ? 0.18 : 0.28),
            blurRadius: compact ? 4 : 8,
            offset: Offset(0, compact ? 1 : 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              visual.icon,
              size: iconSize,
              color: visual.iconColor,
            ),
            SizedBox(width: compact ? 2.w : 4.w),
          ],
          Text(
            shortId.displayText,
            style: TextStyle(
              color: visual.textColor,
              fontSize: compact ? 8.sp : 10.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortIdBadgeVisualData {
  final List<Color> colors;
  final Color borderColor;
  final Color shadowColor;
  final Color iconColor;
  final Color textColor;
  final IconData icon;

  const _ShortIdBadgeVisualData({
    required this.colors,
    required this.borderColor,
    required this.shadowColor,
    required this.iconColor,
    required this.textColor,
    required this.icon,
  });

  factory _ShortIdBadgeVisualData.fromType(ShortIdType type) {
    switch (type) {
      case ShortIdType.normal:
        return const _ShortIdBadgeVisualData(
          colors: [Color(0xFF1176F6), Color(0xFF064CB8)],
          borderColor: Color(0xFF8AC5FF),
          shadowColor: Color(0xFF1176F6),
          iconColor: Colors.white,
          textColor: Colors.white,
          icon: Icons.tag,
        );
      case ShortIdType.short:
        return const _ShortIdBadgeVisualData(
          colors: [Color(0xFF17C6E2), Color(0xFF1476C9)],
          borderColor: Color(0xFFB4F5FF),
          shadowColor: Color(0xFF17C6E2),
          iconColor: Colors.white,
          textColor: Colors.white,
          icon: Icons.bolt,
        );
      case ShortIdType.legend:
        return const _ShortIdBadgeVisualData(
          colors: [Color(0xFFFFE08A), Color(0xFFC78207)],
          borderColor: Color(0xFFFFF2B8),
          shadowColor: Color(0xFFFFC949),
          iconColor: Color(0xFF5B3300),
          textColor: Color(0xFF3B2500),
          icon: Icons.workspace_premium,
        );
      case ShortIdType.premium:
        return const _ShortIdBadgeVisualData(
          colors: [Color(0xFFB66DFF), Color(0xFF5A22B8)],
          borderColor: Color(0xFFE7C5FF),
          shadowColor: Color(0xFFB66DFF),
          iconColor: Colors.white,
          textColor: Colors.white,
          icon: Icons.diamond,
        );
      case ShortIdType.founder:
        return const _ShortIdBadgeVisualData(
          colors: [Color(0xFFE01E37), Color(0xFFFFB23E)],
          borderColor: Color(0xFFFFD890),
          shadowColor: Color(0xFFE01E37),
          iconColor: Colors.white,
          textColor: Colors.white,
          icon: Icons.local_fire_department,
        );
      case ShortIdType.event:
        return const _ShortIdBadgeVisualData(
          colors: [Color(0xFFFF9D2E), Color(0xFFFF5E2E)],
          borderColor: Color(0xFFFFD4A3),
          shadowColor: Color(0xFFFF7D2E),
          iconColor: Colors.white,
          textColor: Colors.white,
          icon: Icons.event,
        );
    }
  }
}
