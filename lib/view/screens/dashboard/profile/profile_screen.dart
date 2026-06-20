import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:tiki/view/screens/dashboard/profile/widget/full_user_detail_widget.dart';
import 'package:tiki/view/screens/dashboard/profile/widget/saved_reels.dart';
import 'package:tiki/view/screens/dashboard/profile/widget/user_bio.dart';

import '../../../../parse/UserModel.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/theme/colors_constant.dart';
import '../../../../view_model/userViewModel.dart';
import '../../../widgets/base_scaffold.dart';
import '../../../widgets/custom_buttons.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? userModel;
  bool otherProfile = false;
  bool isLoading = true;
  late UserViewModel userViewModel;

  @override
  void initState() {
    super.initState();
    userViewModel = Get.find();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final initialUserModel = Get.arguments['mUser'] as UserModel?;
    final initialOtherProfile = Get.arguments['otherProfile'] as bool? ?? false;
    
    if (initialUserModel == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Determine if this is another user's profile by comparing with current user
    final bool isOtherUser = userViewModel.currentUser.objectId != initialUserModel.objectId;
    
    setState(() {
      userModel = initialUserModel;
      // Always show back button if viewing another user's profile
      otherProfile = isOtherUser || initialOtherProfile;
    });

    // If viewing another user's profile, fetch fresh data to get updated followers count
    if (otherProfile && initialUserModel.objectId != null) {
      try {
        final query = QueryBuilder(UserModel.forQuery())
          ..whereEqualTo(UserModel.keyObjectId, initialUserModel.objectId);
        
        final response = await query.query();
        if (response.success && response.results != null && response.results!.isNotEmpty) {
          final updatedUser = response.results!.first as UserModel;
          setState(() {
            userModel = updatedUser;
            isLoading = false;
          });
          // Trigger rebuild of profile header
          userViewModel.update(['profile_header']);
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || userModel == null) {
      return BaseScaffold(
        appBar: otherProfile
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
              )
            : null,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return BaseScaffold(
      appBar: otherProfile
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            )
          : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 45.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GetBuilder<UserViewModel>(
                init: userViewModel,
                id: 'profile_header',
                builder: (_) => FullUserDetailsWidget(
                  userModel: userModel,
                ),
              ),
              Column(
                children: [
                  UserBio(
                    userModel: userModel,
                  ),
                  if (otherProfile == true) ...[
                    SizedBox(
                      height: 24.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GetBuilder<UserViewModel>(
                            init: userViewModel,
                            id: 'subscribe_button',
                            builder: (controller) {
                              // Read following list directly to ensure fresh data
                              final followingList = controller.currentUser.getFollowing ?? [];
                              final isSubscribed = followingList.isNotEmpty && 
                                                  followingList.contains(userModel?.objectId);
                              
                              return OutlineButton(
                                height: 44.h,
                                width: double.infinity,
                                borderRadius: 50.r,
                                useTextGradient: true,
                                onTap: () async {
                                  // Toggle follow state
                                  await controller.followOrUnFollow(
                                    userModel!.objectId!,
                                    targetUser: userModel,
                                  );
                                  // Refresh user data after subscribe/unsubscribe to get updated followers count
                                  if (mounted) {
                                    await _loadUserData();
                                  }
                                },
                                title: isSubscribed
                                    ? "Subscribed"
                                    : "Subscribe",
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 24.w,
                        ),
                        Expanded(
                          child: PrimaryButton(
                              height: 44.h,
                              width: double.infinity,
                              gradient:
                                  AppColors.secondaryGradient(stops: [0, 1]),
                              borderRadius: 50.r,
                              onTap: () {
                                Get.toNamed(AppRoutes.messageView,
                                    arguments: userModel!);
                              },
                              title: "Message",
                              textColor: AppColors.white),
                        ),
                      ],
                    )
                  ],
                  SizedBox(
                    height: 28.h,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(AppImagePath.icMenu,
                                height: 20.h,
                                width: 20.w,
                                fit: BoxFit.fill,
                                color: AppColors.primaryColor),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Divider(
                        color: Colors.white.withOpacity(0.2),
                      )
                    ],
                  ),
                  SavedReels(
                    userModel: userModel!,
                    otherProfile: true,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
