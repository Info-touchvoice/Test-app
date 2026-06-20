// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:tiki/utils/constants/app_constants.dart';
// import 'package:tiki/utils/constants/typography.dart';
// import 'package:tiki/utils/theme/colors_constant.dart';
// import '../../../../../../../view_model/live_controller.dart';

// class AudioLiveTopBar extends StatefulWidget {
//   AudioLiveTopBar();

//   @override
//   State<AudioLiveTopBar> createState() => _AudioLiveTopBarState();
// }

// class _AudioLiveTopBarState extends State<AudioLiveTopBar> {
//   final LiveViewModel liveViewModel = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<LiveViewModel>(builder: (controller) {
//       return Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 height: 40.h,
//                 width: 140.w,
//                 padding: const EdgeInsets.symmetric(vertical: 3),
//                 margin: const EdgeInsets.only(
//                   top: 0,
//                 ),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   color: AppColors.grey300,
//                 ),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       child: Row(
//                         children: [
//                           const CircleAvatar(
//                             radius: 23,
//                             backgroundColor: AppColors.grey300,
//                             backgroundImage:
//                                 AssetImage(AppImagePath.emptyRoomUser),
//                           ),
//                           const SizedBox(width: 8),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Enrique Pemala',
//                                 style: sfProDisplayMedium.copyWith(
//                                   fontSize: 13,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Row(
//                                 children: [
//                                   Image.asset(AppImagePath.diamondIcon,
//                                       width: 14, height: 14),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     '8811M',
//                                     style: sfProDisplayMedium.copyWith(
//                                       fontSize: 12,
//                                       color: AppColors.yellowColor,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // const Spacer(
//               //   flex: 2,
//               // ),
//               SizedBox(
//                 width: 38.w,
//               ),

//               Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Stack(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.only(left: 28),
//                         child: Image.asset(AppImagePath.topPerson3,
//                             width: 36, height: 36),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.only(left: 15),
//                         child: Image.asset(AppImagePath.topPerson2,
//                             width: 36, height: 36),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.only(left: 3),
//                         child: Image.asset(AppImagePath.topPerson1,
//                             width: 36, height: 36),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(width: 8),
//               CircleAvatar(
//                 radius: 16,
//                 backgroundColor: AppColors.grey300,
//                 child:
//                     Image.asset(AppImagePath.shareIcon, width: 22, height: 22),
//               ),
//               const SizedBox(width: 8),
//               CircleAvatar(
//                 radius: 16,
//                 backgroundColor: AppColors.grey300,
//                 child: Text(
//                   "387",
//                   style: sfProDisplayMedium.copyWith(
//                       color: Colors.white, fontSize: 12),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               GestureDetector(
//                 onTap: () => controller.closeAlert(context),
//                 child: const CircleAvatar(
//                   radius: 16,
//                   backgroundColor: AppColors.grey300,
//                   child: Icon(Icons.close, color: Colors.white, size: 20),
//                 ),
//               ),
//               // const SizedBox(width: 10),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 13, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: Color(0XFFFDA949),
//                         borderRadius: BorderRadius.circular(19),
//                       ),
//                       child: Row(
//                         children: [
//                           Image.asset(AppImagePath.gemStone1,
//                               width: 10, height: 10),
//                           const SizedBox(width: 4),
//                           Text(
//                             'Top Score',
//                             style: sfProDisplayMedium.copyWith(
//                                 color: Colors.white, fontSize: 13),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Spacer(),
//                     Container(
//                       padding: const EdgeInsets.only(
//                           left: 12, right: 8, top: 6, bottom: 6),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(19),
//                         color: AppColors.grey300,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'For You',
//                             style: sfProDisplayMedium.copyWith(
//                                 color: Colors.white, fontSize: 13),
//                           ),
//                           const SizedBox(width: 5),
//                           const Icon(Icons.arrow_forward_ios_outlined,
//                               size: 13, color: Colors.white),

//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tiki/utils/constants/app_constants.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/theme/colors_constant.dart';

import '../../../../../../../view_model/live_controller.dart';
import '../../../../../helpers/quick_actions.dart';
import '../../../../../ui/gradient_text_widget.dart';
import '../../../../../utils/gradient_wrapper.dart';
import '../../../../../utils/routes/app_routes.dart';
import '../../single_live_streaming/single_audience_live/widgets/audience_detail_sheet.dart';
import '../../single_live_streaming/single_audience_live/widgets/audience_list_sheet.dart';
import '../../single_live_streaming/single_audience_live/widgets/gift_wish_sheet.dart';
import '../../widgets/gifters_avatar.dart';
import '../../widgets/wishList_streamer_sheet.dart';
import '../../zegocloud/zim_zego_sdk/internal/business/business_define.dart';

class MultiLiveTopBar extends StatefulWidget {
  MultiLiveTopBar();

  @override
  State<MultiLiveTopBar> createState() => _MultiLiveTopBarState();
}

class _MultiLiveTopBarState extends State<MultiLiveTopBar> {
  final LiveViewModel liveViewModel = Get.find();

  @override
  void initState() {
    liveViewModel.subscribeLiveStreamingModel();
    super.initState();
  }

  @override
  void dispose() {
    liveViewModel.unSubscribeLiveStreamingModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveViewModel>(builder: (controller) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: liveViewModel.isMultiGuest ? 10.w : 0),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 0,
                          right: liveViewModel.role == ZegoLiveRole.audience
                              ? 0
                              : 6,
                          top: 3,
                          bottom: 3),
                      constraints: BoxConstraints(minWidth: 120.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.divider,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                backgroundColor: AppColors.grey500,
                                builder: (context) => AudienceDetailSheet(
                                    liveViewModel
                                        .liveStreamingModel.getAuthor!),
                              );
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 17,
                                  backgroundColor: AppColors.divider,
                                  backgroundImage: NetworkImage(
                                    liveViewModel.liveStreamingModel.getAuthor!
                                        .getAvatar!.url!,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '🦊 ${liveViewModel.role == ZegoLiveRole.audience ? liveViewModel.liveStreamingModel.getAuthor!.getFirstName : liveViewModel.liveStreamingModel.getAuthor!.getFullName}',
                                      style: sfProDisplayMedium.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        GradientWrapper(
                                          child: Image.asset(
                                              AppImagePath.diamondIcon,
                                              width: 14,
                                              height: 14),
                                        ),
                                        const SizedBox(width: 4),
                                        GradientText(
                                          text: liveViewModel.liveStreamingModel
                                              .getAuthor!.getCoins
                                              .toString(),
                                          style: sfProDisplayMedium.copyWith(
                                            fontSize: 12,
                                            color: AppColors.yellowColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (liveViewModel.role == ZegoLiveRole.audience)
                            const SizedBox(width: 5),
                          if (liveViewModel.role == ZegoLiveRole.audience)
                            Image.asset(AppImagePath.badge,
                                width: 28, height: 28),
                          SizedBox(
                              width: liveViewModel.role == ZegoLiveRole.audience
                                  ? 5
                                  : 12),
                          if (liveViewModel.role == ZegoLiveRole.audience)
                            Container(
                              width: 40,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.yellowColor,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 10, right: 8),
                    //   child: Image.asset(AppImagePath.profileBorder, width: 60, height: 60),
                    // ),
                  ],
                ),
                const Spacer(),
                GiftAvatar(
                  avatar1: liveViewModel.hostGiftersAvatar.length >= 1
                      ? liveViewModel.hostGiftersAvatar[0]
                      : null,
                  avatar2: liveViewModel.hostGiftersAvatar.length >= 2
                      ? liveViewModel.hostGiftersAvatar[1]
                      : null,
                  avatar3: liveViewModel.hostGiftersAvatar.length >= 3
                      ? liveViewModel.hostGiftersAvatar[2]
                      : null,
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    isScrollControlled: true,
                    backgroundColor: AppColors.grey500,
                    builder: (context) => Wrap(
                      children: [
                        AudienceListSheet(),
                      ],
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 1.2.h),
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.divider,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          AppImagePath.icViews,
                          width: 12.56.w,
                          height: 12.56.w,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          liveViewModel.liveStreamingModel.getViewersId!.length
                              .toString(),
                          style: sfProDisplayMedium.copyWith(
                              color: Colors.white, fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    liveViewModel.closeAlert(context);
                  },
                  child: const CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.divider,
                    child: Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.topFan,
                            arguments:
                                liveViewModel.liveStreamingModel.getAuthor);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0XFFFDA949),
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: Row(
                          children: [
                            Image.asset(AppImagePath.gemStone1,
                                width: 10, height: 10),
                            const SizedBox(width: 4),
                            Text(
                              'Top Score',
                              style: sfProDisplayMedium.copyWith(
                                  color: Colors.white, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19),
                          color: AppColors.divider,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'For You',
                              style: sfProDisplayMedium.copyWith(
                                  color: Colors.white, fontSize: 13),
                            ),
                            const SizedBox(width: 5),
                            const Icon(Icons.arrow_forward_ios_outlined,
                                size: 13, color: Colors.white),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                if (liveViewModel.role == ZegoLiveRole.audience)
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        isScrollControlled: true,
                        backgroundColor: AppColors.wishSheetColor,
                        builder: (context) => Wrap(
                          children: [
                            liveViewModel.role == ZegoLiveRole.host
                                ? WishListStreamerSheet()
                                : GiftWishSheet(),
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.r),
                            height: 40.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: AppColors.divider,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImagePath.icLogo,
                                  height: 28.h,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(width: 3.w),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Gift Goals',
                                      style: sfProDisplayBold.copyWith(
                                        fontSize: 11.sp,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Row(
                                      children: [
                                        LinearPercentIndicator(
                                          animation: true,
                                          animateFromLastPercent: true,
                                          padding: const EdgeInsets.all(0),
                                          lineHeight: 5.0,
                                          width: 55.w,
                                          animationDuration: 2500,
                                          percent: QuickActions
                                              .wishListProgressValue(
                                                  liveViewModel),
                                          barRadius: const Radius.circular(10),
                                          linearGradient:
                                              AppColors.secondaryGradient(
                                                  stops: [0, 1]),
                                          backgroundColor: AppColors.greyColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (liveViewModel.role != ZegoLiveRole.audience &&
                    liveViewModel.liveStreamingModel.getDisableWishList ==
                        false)
                  Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            isScrollControlled: true,
                            backgroundColor: AppColors.wishSheetColor,
                            builder: (context) => Wrap(
                              children: [
                                liveViewModel.role == ZegoLiveRole.host
                                    ? WishListStreamerSheet()
                                    : GiftWishSheet(),
                              ],
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: AppColors.divider,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Image.asset(
                                    AppImagePath.icLogo,
                                    fit: BoxFit.cover,
                                    height: 22.h,
                                  ),
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Gift Goals',
                                        style: sfProDisplayBold.copyWith(
                                          fontSize: 10.5.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Add',
                                            style: sfProDisplayBold.copyWith(
                                              fontSize: 9.5.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            size: 13.5.w,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
