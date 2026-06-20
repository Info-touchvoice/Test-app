import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:tiki/compat/like_button.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tiki/utils/routes/app_routes.dart';
import 'package:tiki/view_model/communityController.dart';
import 'package:tiki/view_model/userViewModel.dart';

import '../../../../../helpers/quick_actions.dart';
import '../../../../../helpers/quick_cloud.dart';
import '../../../../../helpers/quick_help.dart';
import '../../../../../parse/NotificationsModel.dart';
import '../../../../../parse/PostsModel.dart';
import '../../../../../services/dynamic_link_service.dart';
import '../../../../../utils/Utils.dart';
import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/constants/status.dart';
import '../../../../../utils/constants/typography.dart';
import '../../../../../utils/theme/colors_constant.dart';
import '../../../trending/widgets/tip_sheet.dart';
import '../../comments.dart';

// ignore: must_be_immutable
class DefaultVideoInfoWidget extends StatefulWidget {
  PostsModel? postModel;
  int? currentIndex;
  final bool singleReel;

  DefaultVideoInfoWidget(
      {this.postModel, this.currentIndex, this.singleReel = false});

  @override
  State<DefaultVideoInfoWidget> createState() => _DefaultVideoInfoWidgetState();
}

class _DefaultVideoInfoWidgetState extends State<DefaultVideoInfoWidget> {
  TextEditingController textEditingController = TextEditingController();

  late int count;
  List<StreamSubscription> subscriptions = [];
  bool following = false;
  RxInt selectedGiftIndex = 0.obs;

  RxInt userTotalDiamonds = 0.obs;
  UserViewModel userViewModel = Get.find();

  Future<void> updateModel() async {
    QueryBuilder<PostsModel> queryBuilder =
        QueryBuilder<PostsModel>(PostsModel());
    queryBuilder.whereEqualTo(
        PostsModel.keyObjectId, widget.postModel!.objectId!);
    ParseResponse response = await queryBuilder.query();
    if (response.success && response.results != null) {
      widget.postModel = response.results!.first! as PostsModel;
    }
  }

  @override
  void initState() {
    count = widget.postModel!.getLikes!.length;

    userTotalDiamonds.value = userViewModel.currentUser!.getCoins!;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Stack(children: [
      Positioned(
        right: 10,
        bottom: widget.singleReel == true ? 15 : 50,
        child: Column(
          children: [
            GetBuilder<UserViewModel>(
                init: userViewModel,
                builder: (context) {
                  if (userViewModel.currentUser!.getFollowing!
                      .contains(widget.postModel!.getAuthor!.objectId)) {
                    following = true;
                  } else {
                    following = false;
                  }
                  return GestureDetector(
                    onTap: () {
                      userViewModel.followOrUnFollow(
                          widget.postModel!.getAuthor!.objectId!);
                    },
                    child: SizedBox(
                      height: 39.h,
                      width: 39.w,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white)),
                            child: QuickActions.avatarWidget(
                              widget.postModel!.getAuthor!,
                              height: 39.h,
                              width: 39.w,
                            ),
                          ),
                          if (widget.postModel!.getAuthor!.objectId !=
                              userViewModel.currentUser.objectId)
                            Positioned(
                              bottom: -6,
                              left: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Color(0xffEA4359),
                                  child: Icon(
                                    following ? Icons.check : Icons.add,
                                    color: Colors.white,
                                    size: 11,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
            SizedBox(
              height: 18.h,
            ),
            LikeButton(
              padding: EdgeInsets.only(right: 2),
              size: 34,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              countPostion: CountPostion.bottom,
              circleColor: CircleColor(
                  start: AppColors.primaryColor, end: AppColors.primaryColor),
              bubblesColor: BubblesColor(
                dotPrimaryColor: AppColors.primaryColor,
                dotSecondaryColor: AppColors.primaryColor,
              ),
              isLiked: widget.postModel!.getLikes!
                  .contains(userViewModel.currentUser!.objectId),
              likeCountAnimationType: LikeCountAnimationType.all,
              likeBuilder: (bool isLiked) {
                return Container(
                  height: 33.h,
                  width: 33.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.favorite,
                      color: isLiked
                          ? AppColors.primaryColor
                          : Colors.white.withOpacity(0.8),
                      size: 32),
                );
              },
              likeCountPadding: EdgeInsets.only(left: 3, top: 1.h),
              likeCount: widget.postModel!.getLikes!.length,
              countBuilder: (count, bool isLiked, String text) {
                Widget result;

                result = Text(
                  QuickHelp.convertNumberToK(count!),
                  style: SafeGoogleFont(
                    'DM Sans',
                    fontSize: 12 * ffem,
                    fontWeight: FontWeight.w500,
                    height: 1.3333333333 * ffem / fem,
                    color: Color(0xffffffff),
                  ),
                );
                return result;
              },
              onTap: (isLiked) {
                print("Liked: $isLiked");

                if (isLiked) {
                  widget.postModel!.removeLike =
                      userViewModel.currentUser!.objectId!;

                  widget.postModel!.save().then((value) {
                    widget.postModel = value.results!.first as PostsModel;
                  });

                  _deleteLike(widget.postModel!);

                  return Future.value(false);
                } else {
                  widget.postModel!.setLikes =
                      userViewModel.currentUser!.objectId!;
                  widget.postModel!.setLastLikeAuthor =
                      userViewModel.currentUser!;

                  widget.postModel!.save().then((value) {
                    widget.postModel = value.results!.first as PostsModel;
                  });

                  // _likePost(widget.postModel!);

                  return Future.value(true);
                }
              },
            ),
            SizedBox(
              height: widget.singleReel == false ? 18.h : 15.h,
            ),
            LikeButton(
              padding: EdgeInsets.only(right: 2),
              size: 34,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              countPostion: CountPostion.bottom,
              circleColor: CircleColor(
                  start: AppColors.primaryColor, end: AppColors.primaryColor),
              bubblesColor: BubblesColor(
                dotPrimaryColor: AppColors.primaryColor,
                dotSecondaryColor: AppColors.primaryColor,
              ),
              isLiked: widget.postModel!.getLikes!
                  .contains(userViewModel.currentUser!.objectId),
              likeCountAnimationType: LikeCountAnimationType.all,
              likeBuilder: (bool isLiked) {
                return Image.asset(AppImagePath.icComment);
              },
              likeCountPadding: EdgeInsets.only(left: 3, top: 1.h),
              likeCount: widget.postModel!.getComments!.length,
              countBuilder: (count, bool isLiked, String text) {
                var color = isLiked ? Colors.white : Colors.white;
                Widget result;

                result = Text(
                  QuickHelp.convertNumberToK(
                      widget.postModel!.getComments!.length),
                  style: SafeGoogleFont(
                    'DM Sans',
                    fontSize: 12 * ffem,
                    fontWeight: FontWeight.w500,
                    height: 1.3333333333 * ffem / fem,
                    color: Color(0xffffffff),
                  ),
                );
                return result;
              },
              onTap: (isLiked) {
                print("Liked: $isLiked");
                showComments(context, fem, ffem, () {
                  widget.postModel!.save().then((value) {
                    widget.postModel = value.results!.first as PostsModel;
                    setState(() {});
                  });
                });
                return Future.value(false);
              },
            ),
            SizedBox(
              height: 18.h,
            ),
            GetBuilder<CommunityController>(builder: (communityController) {
              return GestureDetector(
                onTap: () async {
                  communityController.toggleSavedStatusAndUpdateList(
                      postId: widget.postModel!.objectId!,
                      authorId: userViewModel.currentUser.objectId!,
                      post: widget.postModel!);
                },
                child: Column(
                  children: [
                    Image.asset(
                      AppImagePath.icSave,
                      color: communityController
                              .isPostSaved(widget.postModel!.objectId!)
                          ? AppColors.primaryColor
                          : null,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      communityController
                              .isPostSaved(widget.postModel!.objectId!)
                          ? "Saved"
                          : "Save",
                      style: sfProDisplayMedium.copyWith(
                        color: Color(0xffffffff),
                        fontSize: 10.51.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(
              height: 18.h,
            ),
            GestureDetector(
              onTap: () async {
                try {
                  // Check if postModel and objectId are valid
                  if (widget.postModel == null || widget.postModel!.objectId == null || widget.postModel!.objectId!.isEmpty) {
                    QuickHelp.showAppNotificationAdvanced(
                        title: 'Unable to share: Invalid post data', context: context);
                    return;
                  }

                  // Show loading indicator
                  QuickHelp.showLoadingDialog(context);
                  
                  Uri? uri = await DynamicLinkService()
                      .createDynamicLink(widget.postModel!.objectId, reels: true);
                  
                  QuickHelp.hideLoadingDialog(context);
                  
                  if (uri != null) {
                    String shareText = "Come and check ${widget.postModel!.getAuthor?.getFirstName ?? 'this'}'s reel on Tiki! ${uri.toString()}";
                    
                    await Share.share(shareText);
                    
                    // Update share count
                    widget.postModel!.setShares =
                        userViewModel.currentUser.objectId!;

                    widget.postModel!.save().then((value) {
                      if (value.success && value.results != null) {
                        widget.postModel = value.results!.first as PostsModel;
                        setState(() {});
                      }
                    });
                  } else {
                    QuickHelp.showAppNotificationAdvanced(
                        title: 'Unable to create share link. Please try again.', context: context);
                  }
                } catch (e) {
                  QuickHelp.hideLoadingDialog(context);
                  print("Error sharing reel: $e");
                  QuickHelp.showAppNotificationAdvanced(
                      title: 'Something went wrong! Please try again.', context: context);
                }
              },
              child: Column(
                children: [
                  Image.asset(
                    AppImagePath.icShare,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "Share",
                    style: sfProDisplayMedium.copyWith(
                      color: Color(0xffffffff),
                      fontSize: 10.51.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 18.h,
            ),
            if (widget.singleReel == false &&
                widget.postModel!.getAuthor!.objectId! !=
                    userViewModel.currentUser.objectId) ...[
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
                      isScrollControlled: true,
                      builder: (context) => Wrap(
                        children: [
                          TipSheet(),
                        ],
                      ),
                    );
                  },
                  child: Image.asset(
                    AppImagePath.reel_tip,
                    color: AppColors.brand,
                  )),
              SizedBox(
                height: 6.h,
              ),
              Text(
                "Tip",
                style: TextStyle(
                  color: Color(0xffffffff),
                ),
              ),
              SizedBox(
                height: 18.h,
              ),
            ],
            GestureDetector(
              onTap: () {
                tools(context);
              },
              child: Container(
                height: 32.h,
                width: 32.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xff494848)),
                child: Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            if (widget.postModel!.getMusicFile != null) ...[
              SizedBox(height: 25.h),
              GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.audioScreen,
                      arguments: {
                        'music': widget.postModel!.getMusicFile,
                        'post': widget.postModel,
                      },
                    );
                  },
                  child: Image.asset(AppImagePath.icMusic))
            ],
            SizedBox(
              height: 40.h,
            ),
          ],
        ),
      ),
      Positioned(
          left: 10,
          bottom: widget.singleReel == true ? 15 : 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.postModel!.getCaption != null)
                Text(
                  "${widget.postModel!.getCaption ?? ''}",
                  style: TextStyle(color: AppColors.white),
                ),
              if (widget.postModel!.getCaption != null)
                SizedBox(
                  height: 30.h,
                ),
              if (widget.postModel!.getCaption == null)
                SizedBox(
                  height: 10.h,
                ),
              if (widget.postModel!.getCaption == null)
                SizedBox(
                  height: 14.h,
                ),
              SizedBox(
                height: 40.h,
              ),
            ],
          ))
    ]);
  }

  _deleteLike(PostsModel postsModel) async {
    QueryBuilder<NotificationsModel> queryBuilder =
        QueryBuilder<NotificationsModel>(NotificationsModel());
    queryBuilder.whereEqualTo(
        NotificationsModel.keyAuthor, userViewModel.currentUser);
    queryBuilder.whereEqualTo(NotificationsModel.keyPost, postsModel);

    ParseResponse parseResponse = await queryBuilder.query();

    if (parseResponse.success && parseResponse.results != null) {
      NotificationsModel notification = parseResponse.results!.first;
      await notification.delete();
    }
  }

  void followOrUnfollow() async {
    if (userViewModel.currentUser!.getFollowing!
        .contains(widget.postModel!.getAuthor!.objectId)) {
      userViewModel.currentUser!.removeFollowing =
          widget.postModel!.getAuthor!.objectId!;

      following = false;
    } else {
      userViewModel.currentUser!.setFollowing =
          widget.postModel!.getAuthor!.objectId!;

      following = true;
    }

    await userViewModel.currentUser!.save();

    ParseResponse parseResponse = await QuickCloudCode.followUser(
        isFollowing: false,
        author: userViewModel.currentUser!,
        receiver: widget.postModel!.getAuthor!);

    if (parseResponse.success) {
      QuickActions.createOrDeleteNotification(
          userViewModel.currentUser!,
          widget.postModel!.getAuthor!,
          NotificationsModel.notificationTypeFollowers);
    }
  }

  void showComments(
      BuildContext context, double fem, double ffem, Function()? then) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      useRootNavigator: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      // backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: new BoxDecoration(
          gradient: LinearGradient(
              begin: Get.isDarkMode
                  ? Alignment.bottomLeft
                  : Alignment.bottomCenter,
              end: Get.isDarkMode ? Alignment.topRight : Alignment.topCenter,
              stops: Get.isDarkMode ? const [0.7, 0.9] : null,
              colors: Get.isDarkMode
                  ? AppColors.darkBGGradientColor
                  : AppColors.lightBGGradientColor),
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 18 * fem),
            Text(
              "Comments",
              style: SafeGoogleFont(
                'DM Sans',
                fontSize: 16 * ffem,
                color: Get.isDarkMode ? Colors.white : AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 14 * fem),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16 * fem),
              child: Divider(
                color: AppColors.white.withOpacity(0.7),
              ),
            ),
            Expanded(
              child: Comments(
                postModel: widget.postModel!,
                currentUser: userViewModel.currentUser,
                reels: true,
              ),
            ),
          ],
        ),
      ),
    ).then((value) => then);
  }

  Future<void> tools(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: userViewModel.currentUser!.objectId ==
                  widget.postModel!.getAuthorId
              ? MediaQuery.of(context).size.height * 0.24
              : MediaQuery.of(context).size.height * 0.28,
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .9,
                height: userViewModel.currentUser!.objectId ==
                        widget.postModel!.getAuthorId
                    ? MediaQuery.of(context).size.height * .1
                    : MediaQuery.of(context).size.height * .139,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.card,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (userViewModel.currentUser!.objectId !=
                        widget.postModel!.getAuthorId)
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.chatReportScreen,
                            arguments: widget.postModel!.getAuthor),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Report',
                                style: sfProDisplayRegular.copyWith(
                                  color: AppColors.textWhite,
                                  fontSize: 18.sp,
                                )),
                          ),
                        ),
                      ),
                    if (userViewModel.currentUser!.objectId !=
                        widget.postModel!.getAuthorId)
                      Divider(
                        thickness: 0.1,
                        color: AppColors.grey,
                      ),
                    if (userViewModel.currentUser!.objectId ==
                        widget.postModel!.getAuthorId)
                      GestureDetector(
                        onTap: () => _deletePost(context, widget.postModel!),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Delete',
                                style: sfProDisplayRegular.copyWith(
                                  color: AppColors.textWhite,
                                  fontSize: 18.sp,
                                )),
                          ),
                        ),
                      ),
                    if (userViewModel.currentUser!.objectId ==
                        widget.postModel!.getAuthorId)
                      Divider(
                        thickness: 0.1,
                        color: AppColors.grey,
                      ),
                    if (userViewModel.currentUser!.objectId !=
                        widget.postModel!.getAuthorId)
                      GestureDetector(
                        onTap: () => QuickActions.showAlertDialog(context,
                            "Are you sure you want to block this user?", () {
                          Get.back();
                          Get.find<UserViewModel>().addToBlockList(
                              widget.postModel!.getAuthor!.getUid!);
                          QuickHelp.showAppNotificationAdvanced(
                              title: 'User added to block list',
                              context: context);
                          Get.back();
                        }),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Block User',
                                style: sfProDisplayRegular.copyWith(
                                  color: AppColors.textWhite,
                                  fontSize: 18.sp,
                                )),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * .9,
                  height: MediaQuery.of(context).size.height * .06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.yellowBtnColor,
                  ),
                  child: Center(
                    child: Text('Cancel',
                        style: sfProDisplayRegular.copyWith(
                          color: AppColors.black,
                          fontSize: 20.sp,
                        )),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _deletePost(BuildContext context, PostsModel post) {
    // QuickHelp.goBackToPreviousPage(context);

    QuickActions.showAlertDialog(
        context, "Are you sure you want to delete this post?", () {
      _confirmDeletePost(context, post);
    });
  }

  _confirmDeletePost(BuildContext context, PostsModel postsModel) async {
    QuickHelp.goBackToPreviousPage(context);

    QuickHelp.showLoadingDialog(context);

    ParseResponse parseResponse = await postsModel.delete();
    if (parseResponse.success) {
      Get.find<CommunityController>().videosList.removeAt(widget.currentIndex!);
      Get.find<CommunityController>().status = Status.Loading;
      Get.find<CommunityController>().update();
      Get.find<CommunityController>().loadFeedsVideo(
          Get.find<UserViewModel>().currentUser,
          updateBuild: true);

      QuickHelp.goBackToPreviousPage(context);
      Get.back();

      QuickHelp.showAppNotificationAdvanced(
        context: context,
        title: "deleted".tr(),
        message: "feed.post_deleted".tr(),
        user: postsModel.getAuthor,
        isError: false,
      );
    } else {
      QuickHelp.goBackToPreviousPage(context);

      QuickHelp.showAppNotificationAdvanced(
        context: context,
        title: "error".tr(),
        message: "feed.post_not_deleted".tr(),
        user: postsModel.getAuthor,
        isError: true,
      );
    }
  }
}
