import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/theme/colors_constant.dart';
import '../../../../../view_model/communityController.dart';

/// 3D-style tabs: my videos | saved reels | liked reels.
class ProfileReelsTabBar extends StatelessWidget {
  const ProfileReelsTabBar({Key? key}) : super(key: key);

  static const _tabs = [
    _TabData(
      indexKey: 'all',
      asset: AppImagePath.icMenu,
      selectedColor: Color(0xFF9036FF),
    ),
    _TabData(
      indexKey: 'saved',
      asset: AppImagePath.icBookmark,
      selectedColor: Color(0xFFFFB020),
    ),
    _TabData(
      indexKey: 'liked',
      asset: AppImagePath.icHeartAdd,
      selectedColor: Color(0xFFFF4D8D),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunityController>(builder: (controller) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _tabs.map((tab) {
            final index = _indexFor(controller, tab.indexKey);
            final selected = controller.selectedIndex == index;
            return GestureDetector(
              onTap: () => controller.selectIndex = index,
              behavior: HitTestBehavior.opaque,
              child: _icon3d(
                asset: tab.asset,
                selected: selected,
                accent: tab.selectedColor,
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  int _indexFor(CommunityController controller, String key) {
    switch (key) {
      case 'saved':
        return controller.savedReelsIndex;
      case 'liked':
        return controller.likeReelsIndex;
      default:
        return controller.allReelsIndex;
    }
  }

  Widget _icon3d({
    required String asset,
    required bool selected,
    required Color accent,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 52.w,
      height: 52.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: selected
              ? [accent.withOpacity(0.28), accent.withOpacity(0.1)]
              : [const Color(0xFFF9FAFB), const Color(0xFFE5E7EB)],
        ),
        border: Border.all(
          color: selected
              ? accent.withOpacity(0.55)
              : Colors.white.withOpacity(0.85),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: selected
                ? accent.withOpacity(0.38)
                : Colors.black.withOpacity(0.1),
            blurRadius: selected ? 12 : 8,
            offset: Offset(0, selected ? 6 : 4),
          ),
          const BoxShadow(
            color: Color(0xCCFFFFFF),
            blurRadius: 4,
            offset: Offset(-2, -2),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          asset,
          width: 24.w,
          height: 24.w,
          fit: BoxFit.contain,
          color: selected ? accent : AppColors.grey500,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

class _TabData {
  const _TabData({
    required this.indexKey,
    required this.asset,
    required this.selectedColor,
  });

  final String indexKey;
  final String asset;
  final Color selectedColor;
}
