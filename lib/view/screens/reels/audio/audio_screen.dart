import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiki/utils/constants/app_constants.dart';
import 'package:tiki/view/screens/reels/audio/view_model/audio_controller.dart';
import 'package:tiki/view/screens/reels/feed/videoutils/video.dart';
import 'package:tiki/view/screens/reels/reels_single_screen.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';
import 'package:tiki/view/widgets/custom_buttons.dart';

import '../../../../../utils/constants/typography.dart';
import '../../../../../utils/theme/colors_constant.dart';
import '../../../../helpers/quick_help.dart';
import '../../../../parse/MusicModel.dart';
import '../../../../parse/PostsModel.dart';
import '../../../../view_model/userViewModel.dart';
import '../../trending/create/create_reel_screen.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen();

  @override
  Widget build(BuildContext context) {
    MusicModel? musicModel = Get.arguments['music'];
    PostsModel? postModel = Get.arguments['post'];
    AudioViewModel audioViewModel = Get.put(AudioViewModel(musicModel));
    return BaseScaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Audio',
            style: sfProDisplayMedium.copyWith(
                fontSize: 16.sp,
                color: Get.isDarkMode ? AppColors.white : AppColors.black),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios,
                  color: Get.isDarkMode ? AppColors.white : AppColors.black)),
        ),
        body: Column(children: [
          Container(
            color: Color(0xff494848),
            height: 16.h,
            width: double.infinity,
          ),
          SizedBox(
            height: 24.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(AppImagePath.icAudio),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          musicModel?.getAudioName ?? '',
                          style: sfProDisplayMedium.copyWith(
                              fontSize: 16.sp, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          musicModel?.getSingerName ?? '',
                          style: sfProDisplayMedium.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.7)),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 24.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => GestureDetector(
                          child: Icon(
                            audioViewModel.isPlaying.value
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 32,
                          ),
                          onTap: () => audioViewModel.playPause(),
                        )),
                    Expanded(
                      child: Obx(() {
                        final duration = audioViewModel.duration.value;
                        final position = audioViewModel.position.value;
                        return Slider(
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey,
                          min: 0.0,
                          max: duration.inMilliseconds.toDouble(),
                          value: position.inMilliseconds
                              .clamp(0, duration.inMilliseconds)
                              .toDouble(),
                          onChanged: (value) => audioViewModel.seekTo(value),
                        );
                      }),
                    ),
                    Obx(() => Text(
                          audioViewModel.isPlaying.value
                              ? audioViewModel
                                  .formatDuration(audioViewModel.position.value)
                              : audioViewModel.formatDuration(
                                  audioViewModel.duration.value),
                          style: sfProDisplayMedium.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 24.h,
                ),
                PrimaryButton(
                  onTap: () {
                    QuickHelp.goToNavigatorScreen(
                      context,
                      CreateReelScreen(
                        musicModel: musicModel,
                      ),
                    );
                  },
                  height: 48.h,
                  title: 'Use Audio',
                  width: double.infinity,
                  borderRadius: 12.r,
                  bgColor: AppColors.primaryColor,
                  fontSize: 16.sp,
                  textStyle: sfProDisplaySemiBold.copyWith(
                      color: AppColors.darkBGColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp),
                ),
                SizedBox(
                  height: 24.h,
                ),
                FutureBuilder(
                    future: audioViewModel.fetchReels(
                        Get.find<UserViewModel>().currentUser, postModel),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      List<VideoInfo> reels = snapshot.data as List<VideoInfo>;
                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: reels.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 3 items per row
                          mainAxisSpacing: 16.h,
                          crossAxisSpacing: 15.w,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => Get.to(ReelsSingleScreen(
                              currentUser:
                                  Get.find<UserViewModel>().currentUser,
                              post: reels[index].postModel,
                            )),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9.r),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    reels[index]
                                        .postModel!
                                        .getVideoThumbnail!
                                        .url!,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 12.h,
                                    left: 8.w,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          AppImagePath.icReelPlay,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${reels[index].postModel!.getViews}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 12.h,
                                    right: 8.w,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          AppImagePath.icReelHeart,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${reels[index].postModel?.getLikes?.length ?? 0}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
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
                    })
              ],
            ),
          )
        ]));
  }
}
