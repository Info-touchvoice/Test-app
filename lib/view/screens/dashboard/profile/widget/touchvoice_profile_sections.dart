import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/constants/typography.dart';
import '../touchvoice_profile_constants.dart';

/// Empty Hilo-style profile sections (backend wiring later).
class TouchVoiceProfileSections extends StatelessWidget {
  const TouchVoiceProfileSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Family', 'Family Center >'),
        _assetBanner(TouchVoiceProfileAssets.familyBg, height: 88.h),
        SizedBox(height: 18.h),
        _sectionHeader('Relationship(0/10)', 'CP Zone >', showHelp: true),
        _assetBanner(TouchVoiceProfileAssets.relationshipBg, height: 88.h),
        SizedBox(height: 10.h),
        _emptyCard(height: 100.h, color: const Color(0xFFF3E8FF)),
        SizedBox(height: 18.h),
        _sectionHeader('Game Level', 'More >'),
        _emptyBanner(
          height: 72.h,
          gradient: const [Color(0xFFFF8C00), Color(0xFFFFD700)],
          label: 'Diamond',
        ),
        SizedBox(height: 18.h),
        _sectionHeader('Supporter(0)', 'Rank >'),
        SizedBox(
          height: 56.h,
          child: Row(
            children: List.generate(
              4,
              (i) => Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: TouchVoiceProfileColors.sectionDivider,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 18.h),
        Text(
          'Medal',
          style: sfProDisplayMedium.copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: TouchVoiceProfileColors.titleText,
          ),
        ),
        SizedBox(height: 10.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (_, __) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              image: const DecorationImage(
                image: AssetImage(TouchVoiceProfileAssets.medalBg),
                fit: BoxFit.cover,
                opacity: 0.25,
              ),
              color: TouchVoiceProfileColors.sectionDivider,
            ),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _sectionHeader(String title, String action, {bool showHelp = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Text(
            title,
            style: sfProDisplayMedium.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: TouchVoiceProfileColors.titleText,
            ),
          ),
          if (showHelp) ...[
            SizedBox(width: 4.w),
            Icon(
              Icons.help_outline,
              size: 14.sp,
              color: TouchVoiceProfileColors.subText,
            ),
          ],
          const Spacer(),
          Text(
            action,
            style: sfProDisplayRegular.copyWith(
              fontSize: 12.sp,
              color: TouchVoiceProfileColors.subText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _assetBanner(String asset, {required double height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Image.asset(
        asset,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        opacity: const AlwaysStoppedAnimation(0.35),
      ),
    );
  }

  Widget _emptyBanner({
    required double height,
    required List<Color> gradient,
    String? label,
  }) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: gradient.map((c) => c.withOpacity(0.35)).toList(),
        ),
      ),
      alignment: Alignment.center,
      child: label != null
          ? Text(
              label,
              style: sfProDisplayMedium.copyWith(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white.withOpacity(0.5),
              ),
            )
          : null,
    );
  }

  Widget _emptyCard({required double height, required Color color}) {
    return Container(
      width: 140.w,
      height: height,
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
    );
  }
}
