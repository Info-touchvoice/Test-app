import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/view/screens/trending/create/create_reel_screen.dart';
import 'package:tiki/view/widgets/custom_buttons.dart';

import '../../../../../helpers/quick_help.dart';
import '../../../../../parse/UserModel.dart';
import '../../../../../utils/Utils.dart';
import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/constants/status.dart';
import '../../../../../utils/theme/colors_constant.dart';
import '../../../../../view_model/communityController.dart';
import '../../../../../view_model/userViewModel.dart';
import '../../../reels/feed/videoutils/video.dart';
import '../../../reels/reels_single_screen.dart';

class ProfileReelsSection extends StatefulWidget {
  const ProfileReelsSection({Key? key, this.memoriesOnly = false}) : super(key: key);

  /// When true, shows only the user's own videos (Memories tab).
  final bool memoriesOnly;

  @override
  State<ProfileReelsSection> createState() => _ProfileReelsSectionState();
}

class _ProfileReelsSectionState extends State<ProfileReelsSection> {
  CommunityController communityController = Get.find();

  late UserModel userModel;

  @override
  void initState() {
    userModel = Get.find<UserViewModel>().currentUser;
    communityController.fetchCurrentUserAllReels(userModel);
    if (!widget.memoriesOnly) {
      communityController.fetchLikedReels(userModel);
      communityController.fetchSavedReels(userModel);
    } else {
      communityController.selectIndex = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunityController>(builder: (controller) {
      Status status;
      List<VideoInfo> gridItems;
      if (widget.memoriesOnly ||
          communityController.selectedIndex == controller.allReelsIndex) {
        status = controller.allReelsStatus;
        gridItems = controller.userReels;
      } else if (communityController.selectedIndex ==
          controller.likeReelsIndex) {
        status = controller.likedReelsStatus;
        gridItems = controller.likedReels;
      } else {
        status = controller.savedReelsStatus;
        gridItems = controller.savedReels;
      }

      if (status == Status.Loading) {
        return Center(
            child: Padding(
          padding: EdgeInsets.only(top: 34.h),
          child: CircularProgressIndicator(),
        ));
      } else if (gridItems.isEmpty) {
        return Center(
            child: Padding(
          padding: EdgeInsets.only(top: 34.h),
          child: PrimaryButton(
            height: 44.h,
            width: 159.w,
            borderRadius: 50.r,
            gradient: AppColors.secondaryGradient(stops: [0.0, 1.0]),
            bgColor: AppColors.primaryColor,
            onTap: () {
              QuickHelp.goToNavigatorScreen(
                context,
                CreateReelScreen(),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppImagePath.icCloud),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  "Upload",
                  textAlign: TextAlign.center,
                  style: SafeGoogleFont(
                    'SFProDisplay',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ));
      }

      return GridView.builder(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: gridItems.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 items per row
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Get.to(ReelsSingleScreen(
              currentUser: Get.find<UserViewModel>().currentUser,
              post: gridItems[index].postModel,
            )),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.3)),
                image: DecorationImage(
                  image: NetworkImage(
                    gridItems[index].postModel!.getVideoThumbnail!.url!,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Row(
                      children: [
                        Image.asset(
                          AppImagePath.play,
                          height: 12.h,
                          width: 12.w,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${gridItems[index].postModel!.getViews}",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
