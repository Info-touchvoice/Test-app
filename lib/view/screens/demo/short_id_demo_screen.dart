import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../model/short_id_model.dart';
import '../../../utils/theme/colors_constant.dart';
import '../../widgets/base_scaffold.dart';
import '../../widgets/short_id_badge.dart';

class ShortIdDemoScreen extends StatelessWidget {
  const ShortIdDemoScreen({Key? key}) : super(key: key);

  static const _demoNames = {
    ShortIdType.normal: 'Normal User',
    ShortIdType.short: 'Short ID User',
    ShortIdType.legend: 'Legend Voice',
    ShortIdType.premium: 'Premium Host',
    ShortIdType.founder: 'Founder One',
    ShortIdType.event: 'Event Guest',
  };

  @override
  Widget build(BuildContext context) {
    final Color primaryText = AppColors.primaryText(context);
    final Color secondaryText = AppColors.secondaryText(context);

    return BaseScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Short ID Badge Demo'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        children: [
          Text(
            'Static Touch Voice ID samples',
            style: TextStyle(
              color: primaryText,
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Firebase is not connected here. These badges use local sample data only.',
            style: TextStyle(
              color: secondaryText,
              fontSize: 13.sp,
              height: 1.35,
            ),
          ),
          SizedBox(height: 24.h),
          ...ShortIdModel.samples.map(
            (shortId) => Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: _ShortIdDemoCard(
                shortId: shortId,
                name: _demoNames[shortId.type] ?? shortId.type.label,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortIdDemoCard extends StatelessWidget {
  final ShortIdModel shortId;
  final String name;

  const _ShortIdDemoCard({
    required this.shortId,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryText = AppColors.primaryText(context);
    final Color secondaryText = AppColors.secondaryText(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cardBg
            : AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.strokeColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  shortId.type.label,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ShortIdBadge(shortId: shortId),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                child: Text(
                  name.substring(0, 1),
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              ShortIdBadge.compact(shortId: shortId),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Display text: ${shortId.displayText}',
            style: TextStyle(
              color: secondaryText,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
