import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tiki/helpers/quick_actions.dart';
import 'package:tiki/view/widgets/nothing_widget.dart';
import 'package:tiki/view_model/ranking_controller.dart';
import 'package:tiki/view_model/userViewModel.dart';

import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/string_helper.dart';
import '../../../../../utils/theme/colors_constant.dart';

class MainCoinsView extends StatelessWidget {
  MainCoinsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RankingViewModel rankingViewModel = Get.find();
    UserViewModel userViewModel = Get.find();
    if (rankingViewModel.ranking.isNotEmpty)
      return Column(
        children: [
          GetBuilder<UserViewModel>(
              init: userViewModel,
              builder: (userViewModel) {
                return Container(
                  height: 120.h,
                  child: Stack(clipBehavior: Clip.none, children: [
                    Container(
                      width: 350.w,
                      height: 120.h,
                      decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? Color(0xff242424)
                              : Color(0xffF3F5F7),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Color(0xff313134))),
                    ),

/*================for rank person 2 ====================================== */
                    Positioned(
                        left: 20,
                        top: -60,
                        child: Stack(clipBehavior: Clip.none, children: [
                          Container(
                            width: 68.w,
                            height: 68.h,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Color(0xff838BD0), width: 4)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.r),
                              child: rankingViewModel.ranking.length >= 2
                                  ? Image.network(
                                      rankingViewModel.ranking[1].getGifter!
                                          .getAvatar!.url!,
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                              bottom: -15,
                              left: 23.w,
                              child: Image.asset(AppImagePath.icRank2,
                                  height: 28.h, width: 25.w)),
                        ])),
                    Positioned(
                        top: 30.h,
                        child: Container(
                          width: 115.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (rankingViewModel.ranking.length >= 2)
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  child: FittedBox(
                                    child: Text(
                                      trimToTwoWords(
                                          "${rankingViewModel.ranking[1].getGifter!.getFullName}"),
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              SizedBox(
                                height: 10.h,
                              ),
                              if (rankingViewModel.ranking.length >= 2)
                                Center(
                                  child: Container(
                                    width: 39.w,
                                    height: 12.h,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(19.r),
                                        color: Color(0xff9c4ae6)),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Image.asset(AppImagePath.gemstones),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        if (rankingViewModel.ranking.length >=
                                            2)
                                          Text(
                                            "LV.${rankingViewModel.ranking[1].getGifter!.getLevel}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 8.sp),
                                          ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              SizedBox(
                                height: 10.h,
                              ),
                              if (rankingViewModel.ranking.length >= 2)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Image.asset(
                                      AppImagePath.coinsIcon,
                                      height: 12.44.h,
                                      width: 8.15.w,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      QuickActions.formatValue(rankingViewModel
                                          .ranking[1].getGifter!.getCoins),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                          color: AppColors.yellowBtnColor),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        )),
                    if (rankingViewModel.ranking.length >= 2)
                      Positioned(
                          left: 25.w,
                          bottom: -16,
                          child: GestureDetector(
                            onTap: () {
                              userViewModel.followOrUnFollow(rankingViewModel
                                  .ranking[1].getGifter!.objectId!);
                            },
                            child: Container(
                              width: 62.w,
                              height: 32.h,
                              decoration: BoxDecoration(
                                  color: AppColors.yellowBtnColor,
                                  borderRadius: BorderRadius.circular(30.r)),
                              child: Center(
                                child: Icon(
                                  userViewModel.followingUser(rankingViewModel
                                          .ranking[1].getGifter!)
                                      ? Icons.check
                                      : Icons.add,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )),

/*================================for rank person 3 ====================== */

                    Positioned(
                        right: 20,
                        top: -60,
                        child: Stack(clipBehavior: Clip.none, children: [
                          Container(
                              width: 68.w,
                              height: 68.h,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Color(0xffD7590B), width: 4)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.r),
                                child: rankingViewModel.ranking.length >= 3
                                    ? Image.network(
                                        rankingViewModel.ranking[2].getGifter!
                                            .getAvatar!.url!,
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              )),
                          Positioned(
                              bottom: -15,
                              left: 23.w,
                              child: Image.asset(AppImagePath.icRank3,
                                  height: 28.h, width: 25.w))
                        ])),
                    Positioned(
                        top: 30.h,
                        right: 0,
                        child: SizedBox(
                          width: 100.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (rankingViewModel.ranking.length >= 3)
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  child: FittedBox(
                                    child: Text(
                                      trimToTwoWords(
                                          "${rankingViewModel.ranking[2].getGifter!.getFirstName}"),
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              SizedBox(
                                height: 10.h,
                              ),
                              if (rankingViewModel.ranking.length >= 3)
                                Container(
                                  width: 39.w,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(19.r),
                                      color: Color(0xff9c4ae6)),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Image.asset(AppImagePath.gemstones),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        "LV.${rankingViewModel.ranking[2].getGifter!.getLevel}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 8.sp),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                    ],
                                  ),
                                ),
                              SizedBox(
                                height: 10.h,
                              ),
                              if (rankingViewModel.ranking.length >= 3)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Image.asset(
                                      AppImagePath.coinsIcon,
                                      height: 12.44.h,
                                      width: 8.15.w,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    if (rankingViewModel.ranking.length >= 3)
                                      Text(
                                        QuickActions.formatValue(
                                            rankingViewModel.ranking[2]
                                                .getGifter!.getCoins),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.sp,
                                            color: AppColors.yellowBtnColor),
                                      ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        )),
                    if (rankingViewModel.ranking.length >= 3)
                      Positioned(
                          right: 20,
                          bottom: -16,
                          child: GestureDetector(
                            onTap: () {
                              userViewModel.followOrUnFollow(rankingViewModel
                                  .ranking[2].getGifter!.objectId!);
                            },
                            child: Container(
                              width: 62.w,
                              height: 32.h,
                              decoration: BoxDecoration(
                                  color: AppColors.yellowBtnColor,
                                  borderRadius: BorderRadius.circular(30.r)),
                              child: Center(
                                child: Icon(
                                  userViewModel.followingUser(rankingViewModel
                                          .ranking[2].getGifter!)
                                      ? Icons.check
                                      : Icons.add,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )),

/*================================for rank person 1 ====================== */

                    Positioned(
                        right: 50,
                        left: 50,
                        top: -50,
                        child: Center(
                          child: Stack(clipBehavior: Clip.none, children: [
                            Container(
                              width: 116.h,
                              height: 133.h,
                              decoration: BoxDecoration(
                                  color: Get.isDarkMode
                                      ? Color(0xff242424)
                                      : Color(0xffF3F5F7),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.r),
                                      topRight: Radius.circular(30.r)),
                                  border: Border.all(
                                      color: AppColors.yellowBtnColor)),
                            ),
                            Positioned(
                                left: 15,
                                top: -41,
                                right: 15,
                                child:
                                    Stack(clipBehavior: Clip.none, children: [
                                  Container(
                                    width: 82.w,
                                    height: 82.w,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Color(0xffFFCC00),
                                            width: 4)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50.r),
                                      child:
                                          rankingViewModel.ranking.length >= 1
                                              ? Image.network(
                                                  rankingViewModel
                                                      .ranking[0]
                                                      .getGifter!
                                                      .getAvatar!
                                                      .url!,
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                    ),
                                  ),
                                  Positioned(
                                      bottom: -15,
                                      left: 30.5.w,
                                      child: Image.asset(AppImagePath.icRank1,
                                          height: 28.h, width: 25.w)),
                                ])),
                            Positioned(
                                top: -82,
                                left: 13,
                                right: 17,
                                child: SvgPicture.asset(AppImagePath.icKing,
                                    height: 30.h, width: 25.w)),
                            Positioned(
                                top: 60.h,
                                child: Container(
                                  width: 113.w,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (rankingViewModel.ranking.length >= 1)
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w),
                                          child: FittedBox(
                                            child: Text(
                                              trimToTwoWords(
                                                  "${rankingViewModel.ranking[0].getGifter!.getFullName}"),
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      if (rankingViewModel.ranking.length >= 1)
                                        Container(
                                          width: 39.w,
                                          height: 12.h,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(19.r),
                                              color: Color(0xff9c4ae6)),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Image.asset(
                                                  AppImagePath.gemstones),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Text(
                                                "LV.${rankingViewModel.ranking[0].getGifter!.getLevel}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 8.sp),
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                            ],
                                          ),
                                        ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      if (rankingViewModel.ranking.length >= 1)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Image.asset(
                                              AppImagePath.coinsIcon,
                                              height: 12.44.h,
                                              width: 8.15.w,
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Text(
                                              QuickActions.formatValue(
                                                  rankingViewModel.ranking[0]
                                                      .getGifter!.getCoins),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.sp,
                                                  color:
                                                      AppColors.yellowBtnColor),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                )),
                            if (rankingViewModel.ranking.length >= 1)
                              Positioned(
                                  bottom: -20,
                                  left: 25,
                                  right: 25,
                                  child: GestureDetector(
                                    onTap: () {
                                      userViewModel.followOrUnFollow(
                                          rankingViewModel
                                              .ranking[0].getGifter!.objectId!);
                                    },
                                    child: Container(
                                      width: 62.w,
                                      height: 32.h,
                                      decoration: BoxDecoration(
                                          color: AppColors.yellowBtnColor,
                                          borderRadius:
                                              BorderRadius.circular(30.r)),
                                      child: Center(
                                        child: Icon(
                                          userViewModel.followingUser(
                                                  rankingViewModel
                                                      .ranking[0].getGifter!)
                                              ? Icons.check
                                              : Icons.add,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ))
                          ]),
                        )),
                  ]),
                );
              }),
        ],
      );
    return NothingIsHere();
  }
}
