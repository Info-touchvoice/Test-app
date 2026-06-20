import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:tiki/helpers/quick_help.dart';
import 'package:tiki/parse/UserModel.dart';
import 'package:tiki/view_model/gender_controller.dart';
import 'package:tiki/view_model/userViewModel.dart';

import '../../../../../utils/permission/choose_photo_permission.dart';
import '../../../../../utils/theme/colors_constant.dart';
import '../../../../../view_model/edit_controller.dart';
import '../../../../../view_model/relationship_status_controller.dart';
import '../touchvoice_profile_constants.dart';

class EditProfileTopBar extends StatelessWidget {
  const EditProfileTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    final textColor = isLightTheme ? Colors.black : Colors.white;

    UserViewModel userViewModel = Get.find();
    final EditController editController = Get.find();
    final UserViewModel profileController = Get.find();
    final GenderController genderController = Get.find();
    final RelationshipStatusController relationStatusController = Get.find();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                    ),
                  ),
                  Text(
                    "Edit",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: textColor),
                  ),
                  GestureDetector(
                    onTap: () async {
                      QuickHelp.showLoadingDialog(context);
                      if (editController.bioEditingController.text.isNotEmpty)
                        userViewModel.currentUser.setBio =
                            editController.bioEditingController.text;
                      if (editController
                          .websiteEditingController.text.isNotEmpty)
                        userViewModel.currentUser.setWebsite =
                            editController.websiteEditingController.text;
                      if (editController.nameEditingController.text.isNotEmpty)
                        userViewModel.currentUser.setFullName =
                            editController.nameEditingController.text;
                      userViewModel.currentUser.setFirstName = editController
                          .nameEditingController.text
                          .split(' ')[0];
                      if (editController.nameEditingController.text
                              .split(' ')
                              .length >
                          1) {
                        userViewModel.currentUser.setLastName = editController
                            .nameEditingController.text
                            .split(' ')[1];
                      }
                      if (editController.selectedDate.value.isNotEmpty)
                        userViewModel.currentUser.setBirthday =
                            DateTime.parse(editController.selectedDate.value);
                      if (genderController.selectedGender.value.isNotEmpty)
                        userViewModel.currentUser.setGender =
                            genderController.selectedGender.value;
                      if (editController
                          .countryEditingController.text.isNotEmpty)
                        userViewModel.currentUser.setCountry =
                            editController.countryEditingController.text;

                      ParseResponse parseResponse =
                          await userViewModel.currentUser.save();
                      if (parseResponse.success) {
                        if (parseResponse.results != null) {
                          userViewModel.currentUser =
                              parseResponse.results!.first as UserModel;
                          userViewModel.update();
                          profileController.currentUser =
                              userViewModel.currentUser;
                          profileController.update();

                          QuickHelp.hideLoadingDialog(context);
                          // Close edit profile after successful save
                          Get.back();
                        }
                      } else
                        QuickHelp.hideLoadingDialog(context);
                    },
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: textColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Row(
                children: [
                  Text(
                    "Banner",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: textColor),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "Tap to change from your phone",
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: textColor),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: () =>
                    PermissionHandler.checkPermission(false, context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 120.h,
                        width: double.infinity,
                        child: _buildBannerPreview(
                            userViewModel.currentUser.getCover?.url),
                      ),
                      Positioned(
                        right: 10.w,
                        bottom: 10.h,
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Text(
                    "Image",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        // color: AppColors.white,
                        color: textColor),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "Tap to edit up to 9 images",
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: textColor),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      PermissionHandler.checkPermission(true, context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(3), // border thickness
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.secondaryGradient(stops: [
                          0.0,
                          1.0
                        ]), // your gradient function or custom gradient
                      ),
                      child: CircleAvatar(
                        radius: 42.r, // main avatar radius
                        backgroundColor:
                            Colors.transparent, // transparent background
                        backgroundImage: QuickHelp.getUserAvatarProvider(
                            userViewModel.currentUser),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(4, (index) {
                            ParseFileBase? avatar;
                            if (index == 0)
                              avatar = userViewModel.currentUser.getAvatar1;
                            else if (index == 1)
                              avatar = userViewModel.currentUser.getAvatar2;
                            else if (index == 2)
                              avatar = userViewModel.currentUser.getAvatar3;
                            else
                              avatar = userViewModel.currentUser.getAvatar4;
                            return GestureDetector(
                              onTap: () => PermissionHandler.checkPermission(
                                  true, context,
                                  avatarNumber: index + 1),
                              child: Container(
                                width: 36.w,
                                height: 36.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      // color: AppColors.white
                                      color: textColor),
                                ),
                                child: avatar == null
                                    ? Center(child: Icon(Icons.add))
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(44.r),
                                        child: Image.network(
                                          avatar.url!,
                                          height: double.infinity,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(4, (index) {
                            ParseFileBase? avatar;
                            if (index == 0)
                              avatar = userViewModel.currentUser.getAvatar5;
                            else if (index == 1)
                              avatar = userViewModel.currentUser.getAvatar6;
                            else if (index == 2)
                              avatar = userViewModel.currentUser.getAvatar7;
                            else
                              avatar = userViewModel.currentUser.getAvatar8;
                            return GestureDetector(
                              onTap: () => PermissionHandler.checkPermission(
                                  true, context,
                                  avatarNumber: index + 5),
                              child: Container(
                                  width: 36.w,
                                  height: 36.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        // color: AppColors.white
                                        color: textColor),
                                  ),
                                  child: avatar == null
                                      ? Center(child: Icon(Icons.add))
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(44.r),
                                          child: Image.network(
                                            avatar.url!,
                                            height: double.infinity,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                children: [
                  Text(
                    "Video",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        // color: AppColors.white,
                        color: textColor),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "Unlock at Lv 6",
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: textColor),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(3), // border thickness
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.secondaryGradient(stops: [
                        0.0,
                        1.0
                      ]), // your gradient function or custom gradient
                    ),
                    child: CircleAvatar(
                      radius: 43.r, // main avatar radius
                      backgroundColor: Colors.black, // transparent background
                      child: Center(child: Icon(Icons.play_arrow)),
                    ),
                  ),
                  Container(
                    width: 88.w,
                    height: 88.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: textColor, width: 2)),
                    child: Center(child: Icon(Icons.play_arrow)),
                  ),
                  Container(
                    width: 88.w,
                    height: 88.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: textColor, width: 2)),
                    child: Center(child: Icon(Icons.play_arrow)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBannerPreview(String? coverUrl) {
    if (coverUrl != null && coverUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: coverUrl,
        fit: BoxFit.cover,
        placeholder: (_, __) => _defaultBannerPlaceholder(),
        errorWidget: (_, __, ___) => _defaultBannerPlaceholder(),
      );
    }
    return _defaultBannerPlaceholder();
  }

  Widget _defaultBannerPlaceholder() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            TouchVoiceProfileColors.headerTop,
            TouchVoiceProfileColors.headerBottom,
          ],
        ),
      ),
      child: Image.asset(
        TouchVoiceProfileAssets.topCover,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        opacity: const AlwaysStoppedAnimation(0.35),
      ),
    );
  }
}
