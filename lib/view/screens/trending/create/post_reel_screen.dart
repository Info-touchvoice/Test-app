import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tiki/parse/PostsModel.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/theme/colors_constant.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';
import 'package:tiki/view_model/communityController.dart';
import 'package:tiki/utils/mp4_fast_start.dart';

import '../../../../helpers/quick_help.dart';
import '../../../../utils/Utils.dart';
import '../../../../view_model/music_controller.dart';
import '../../../../view_model/userViewModel.dart';
import '../../reels/feed/videoutils/video.dart';

class PostReelScreen extends StatefulWidget {
  final File? pickedFile;
  final String? thumbnailImage;
  PostReelScreen({
    Key? key,
    this.pickedFile,
    this.thumbnailImage,
  });
  @override
  State<PostReelScreen> createState() => _PostReelScreenState();
}

class _PostReelScreenState extends State<PostReelScreen> {
  Utils util = Utils();
  final TextEditingController _textController = TextEditingController();
  String? _selectedMedia;
  File? _pickedFile;
  ParseFile? parseFileThumbnail;
  String? thumbnailImage;
  RxBool isBold = false.obs;
  RxBool isUnderline = false.obs;
  RxBool isItalic = false.obs;

  MusicController musicController = Get.find();

  bool get isVideoChosen => _selectedMedia == 'video';

  @override
  void initState() {
    _pickedFile = widget.pickedFile;
    // This screen is specifically for posting a reel (video). Ensure it is treated as video by default.
    _selectedMedia = 'video';
    if (widget.thumbnailImage != null) {
      thumbnailImage = widget.thumbnailImage;
      parseFileThumbnail =
          ParseFile(File(thumbnailImage!), name: "thumbnail.jpg");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 25.sp,
                    color: AppColors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text('Post',
                        style: sfProDisplayBold.copyWith(
                          color: Colors.white,
                          fontSize: 20.h,
                        )),
                  ),
                ),
                SizedBox(width: 48.w)
              ],
            ),
            Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return TextField(
                            controller: _textController,
                            style: sfProDisplaySemiBold.copyWith(
                              color: AppColors.black,
                              fontSize: 18.h,
                              fontStyle: isItalic.value
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                              fontWeight: isBold.value == true
                                  ? FontWeight.bold
                                  : FontWeight.w400,
                              decoration: isUnderline.value
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                            ),
                            maxLines: 2,
                            decoration: InputDecoration(
                              filled: true,
                              focusedBorder: InputBorder.none,
                              focusColor: Colors.transparent,
                              fillColor: AppColors.white,
                              hintText: "What's on your mind ......",
                              hintStyle: sfProDisplayMedium.copyWith(
                                  fontSize: 13.sp, color: AppColors.black),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          );
                        }),
                        Row(
                          children: [
                            IconButton(
                              icon: Text('B',
                                  style: sfProDisplayBold.copyWith(
                                    color: Colors.black,
                                    fontSize: 20.sp,
                                  )),
                              onPressed: () => isBold.value = !isBold.value,
                            ),
                            IconButton(
                              icon: Text('I',
                                  style: sfProDisplayBold.copyWith(
                                      color: Colors.black,
                                      fontSize: 20.sp,
                                      fontStyle: FontStyle.italic)),
                              onPressed: () => isItalic.value = !isItalic.value,
                            ),
                            IconButton(
                              icon: Text('U',
                                  style: sfProDisplayBold.copyWith(
                                      color: Colors.black,
                                      fontSize: 20.sp,
                                      decoration: TextDecoration.underline)),
                              onPressed: () =>
                                  isUnderline.value = !isUnderline.value,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            thumbnailImage != null
                ? _buildMediaPreview(thumbnailImage!)
                : Container(),
            Spacer(),
            ElevatedButton(
              onPressed: savePost,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellowBtnColor,
                foregroundColor: Colors.black,
                minimumSize:
                    Size(double.infinity, 50), // <-- matches the height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: Text(
                'Submit',
                style: sfProDisplaySemiBold.copyWith(
                  color: AppColors.black,
                  fontSize: 20.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future savePost() async {
    if (_pickedFile != null) {
      QuickHelp.showLoadingDialogWithText(
        context,
        description: 'Optimizing video, please wait...',
      );

      // 1) Ensure MP4 is "faststart" (moov atom at beginning) so reels can start playing
      // much sooner on slow networks (progressive download).
      final File preparedVideo = await _ensureFastStartMp4(_pickedFile!);

      // 2) Upload
      QuickHelp.hideLoadingDialog(context);
      QuickHelp.showLoadingDialogWithText(
        context,
        description: 'Uploading, please wait...',
      );

      final user = Get.find<UserViewModel>().currentUser;
      PostsModel postsModel = PostsModel();
      postsModel.setAuthor = user!;
      postsModel.setAuthorId = user.objectId!;

      if (musicController.selectedMusic != null) {
        postsModel.addMusicFile = musicController.selectedMusic!;
      }

      if (parseFileThumbnail != null)
        postsModel.setVideoThumbnail = parseFileThumbnail!;
      if (_textController.text.isNotEmpty)
        postsModel.setCaption = _textController.text;
      if (_pickedFile != null) {
        ParseFile parseFile = ParseFile(preparedVideo);
        // await parseFile.save();
        if (_selectedMedia == "image") {
          postsModel.setImage = parseFile;
        } else {
          postsModel.setVideo = parseFile;
        }
      }
      postsModel.setPostType = "video";
      postsModel.setExclusive = false;

      // Display loading dialog

      // Save post
      ParseResponse response = await postsModel.save();
      QuickHelp.hideLoadingDialog(context);

      if (response.success) {
        VideoInfo videoInfo = VideoInfo(
          postModel: postsModel,
          currentUser: user,
          url: postsModel.getVideo!.url,
        );
        Get.find<CommunityController>().videosList.add(videoInfo);
        Get.find<CommunityController>().update();
        Get.find<CommunityController>().loadFeedsVideo(
            Get.find<UserViewModel>().currentUser,
            updateBuild: false);
        QuickHelp.showAppNotificationAdvanced(
          context: context,
          title: "feed.post_posted_title".tr(),
          message: "feed.post_posted".tr(),
          isError: false,
        );
        Navigator.of(context).pop();
      } else {
        QuickHelp.showAppNotificationAdvanced(
            context: context,
            title: "feed.post_not_posted".tr(),
            message: response.error!.message,
            isError: true,
            user: user);
      }
    } else
      QuickHelp.showAppNotificationAdvanced(
        context: context,
        title: "Please add a video to upload.",
        isError: true,
      );
  }

  /// Ensures an MP4 is optimized for progressive download ("faststart").
  /// Many camera-recorded MP4s store the `moov` atom at the end, which makes ExoPlayer
  /// wait a long time before it can start playback over HTTP.
  ///
  /// We do a pure-Dart moov relocation (no native dependencies).
  /// If anything fails, we fall back to the original file.
  Future<File> _ensureFastStartMp4(File input) async {
    try {
      if (!await input.exists()) return input;
      final inputLen = await input.length();
      if (inputLen <= 0) return input;

      // Only process mp4 files; other formats keep as-is.
      final lower = input.path.toLowerCase();
      if (!lower.endsWith('.mp4')) return input;

      final dir = await getTemporaryDirectory();
      final tmpDir = Directory(dir.path);
      final outFile = await Mp4FastStart.ensureFastStart(input, tempDir: tmpDir);
      if (await outFile.exists() && await outFile.length() > 0) return outFile;
    } catch (_) {
      // Ignore and fall back to original
    }
    return input;
  }

  Widget _buildMediaPreview(String imagePath) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: imagePath.endsWith('.mp4')
                ? Center(
                    child: Icon(
                      Icons.videocam,
                      color: AppColors.grey,
                      size: 50.w,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
