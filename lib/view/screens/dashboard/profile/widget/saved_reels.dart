import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/view/widgets/custom_buttons.dart';

import '../../../../../parse/UserModel.dart';
import '../../../../../utils/Utils.dart';
import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/theme/colors_constant.dart';
import '../../../../../view_model/communityController.dart';
import '../../../../../view_model/userViewModel.dart';
import '../../../reels/feed/videoutils/video.dart';
import '../../../reels/reels_single_screen.dart';

class SavedReels extends StatefulWidget {
  final UserModel userModel;
  final bool otherProfile;
  const SavedReels(
      {Key? key, required this.userModel, this.otherProfile = false})
      : super(key: key);

  @override
  State<SavedReels> createState() => _SavedReelsState();
}

class _SavedReelsState extends State<SavedReels> {
  CommunityController communityController = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VideoInfo>>(
        future: communityController.fetchUserReels(widget.userModel, false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Padding(
              padding: EdgeInsets.only(top: 34.h),
              child: CircularProgressIndicator(),
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            if (widget.otherProfile) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 34.h),
                  child: Text(
                    "No reels found",
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'SFProDisplay',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                ),
              );
            }

            return Center(
                child: Padding(
              padding: EdgeInsets.only(top: 34.h),
              child: PrimaryButton(
                height: 44.h,
                width: 159.w,
                borderRadius: 50.r,
                bgColor: AppColors.primaryColor,
                onTap: () {},
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

          final gridItems = snapshot.data!;

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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
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
