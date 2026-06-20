import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/constants/typography.dart';
import '../../../../../utils/routes/app_routes.dart';
import '../../../../../utils/theme/colors_constant.dart';
import '../../../../../view_model/userViewModel.dart';

class DashboardGrid extends StatelessWidget {
  const DashboardGrid({
    Key? key,
    required this.items,
    required this.onTap,
  }) : super(key: key);

  final List<Map<String, String>> items;
  final List<Function()> onTap;

  @override
  Widget build(BuildContext context) {
    final Color primaryText = AppColors.primaryText(context);
    final bool isLight = Theme.of(context).brightness == Brightness.light;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.wallet),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 9.5.w),
                padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 15.h),
                decoration: BoxDecoration(
                  color: isLight
                      ? AppColors.lightShadeColor.withOpacity(0.6)
                      : const Color(0x1A130F1D),
                  border: Border.all(
                    color: isLight
                        ? AppColors.strokeWhite
                        : AppColors.white20,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                ),
                child: Row(
                  children: [
                    _assetIcon(
                      AppImagePath.dashboardWalletIconSvg,
                      width: 32.w,
                      height: 32.w,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "My Wallet",
                      style: sfProDisplayMedium.copyWith(
                        color: primaryText,
                        fontSize: 16.sp,
                      ),
                    ),
                    Spacer(),
                    Image.asset('assets/png/hilo_wallet/recharge_diamond_big.webp',
                        width: 22.w, height: 22.w),
                    SizedBox(width: 8.w),
                    GetBuilder<UserViewModel>(builder: (controller) {
                      final coins = controller.coins;
                      return Text(
                        coins.toString(),
                        style: sfProDisplayMedium.copyWith(
                          color: primaryText,
                          fontSize: 16.sp,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 68.h,
              child: IgnorePointer(
                ignoring: false, // allows tap inside
                child: Container(
                  width: MediaQuery.of(context).size.width - 20,
                  padding: EdgeInsets.all(22.r),
                  decoration: BoxDecoration(
                      color: isLight
                          ? AppColors.white100
                          : const Color(0xFF140325),
                      border: Border.all(
                          color: isLight
                              ? AppColors.strokeWhite
                              : AppColors.white10),
                      borderRadius:
                          BorderRadius.all(Radius.circular(20.r))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildItem(context, 0, primaryText),
                          _buildItem(context, 1, primaryText),
                          _buildItem(context, 2, primaryText),
                          _buildItem(context, 3, primaryText),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildItem(context, 4, primaryText),
                          _buildItem(context, 5, primaryText),
                          _buildItem(context, 6, primaryText),
                          if (items.length > 7)
                            _buildItem(context, 7, primaryText)
                          else
                            SizedBox(width: 52.w),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, Color primaryText) {
    return GestureDetector(
      onTap: () {
        onTap[index]();
      },
      behavior: HitTestBehavior.opaque, // <— important

      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 9.61.h, horizontal: 6.94.w),
            height: 52.w,
            width: 52.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: AppColors.white07,
            ),
            child: _assetIcon(
              items[index]['image']!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            items[index]['label']!,
            style: sfProDisplayRegular.copyWith(
                fontSize: 12.sp, color: primaryText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _assetIcon(
    String assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
  }) {
    if (assetPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
      );
    }

    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
    );
  }
}
