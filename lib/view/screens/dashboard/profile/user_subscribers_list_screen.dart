import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:tiki/helpers/quick_actions.dart';
import 'package:tiki/helpers/quick_help.dart';
import 'package:tiki/parse/UserModel.dart';
import 'package:tiki/utils/constants/app_constants.dart';
import 'package:tiki/utils/constants/typography.dart';
import 'package:tiki/utils/theme/colors_constant.dart';
import 'package:tiki/view/widgets/base_scaffold.dart';
import 'package:tiki/view_model/userViewModel.dart';

class UserSubscribersListScreen extends StatefulWidget {
  final UserModel? userModel;

  const UserSubscribersListScreen({Key? key, this.userModel}) : super(key: key);

  @override
  State<UserSubscribersListScreen> createState() => _UserSubscribersListScreenState();
}

class _UserSubscribersListScreenState extends State<UserSubscribersListScreen> {
  List<UserModel> subscribersList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSubscribers();
  }

  Future<void> _fetchSubscribers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final user = widget.userModel;
      if (user == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'User not found';
        });
        return;
      }

      final String? targetId = user.objectId;
      if (targetId == null || targetId.isEmpty) {
        setState(() {
          isLoading = false;
          subscribersList = [];
        });
        return;
      }

      // Subscribers = users whose `following` array contains this user's objectId.
      final List<UserModel> tempList = await Get.find<UserViewModel>()
          .getFollowersUsersForUser(targetId, limit: 500);

      if (!mounted) return;
      setState(() {
        subscribersList = tempList;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching subscribers: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load subscribers';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Get.isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
        title: Text(
          'Subscribers',
          textAlign: TextAlign.center,
          style: sfProDisplayMedium.copyWith(
            fontSize: 17.sp,
            color: Get.isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.yellowColor,
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: TextStyle(
                      color: AppColors.textSecondaryColor,
                      fontSize: 14.sp,
                    ),
                  ),
                )
              : subscribersList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "*  ",
                            style: sfProDisplayBlack.copyWith(color: Colors.red),
                          ),
                          Text(
                            "No Subscribers",
                            style: sfProDisplayMedium.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      itemCount: subscribersList.length,
                      itemBuilder: (context, index) {
                        UserModel user = subscribersList[index];
                        return GestureDetector(
                          onTap: () {
                            goToProfile(otherProfile: true, mUser: user);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28.r,
                                  backgroundColor: AppColors.divider,
                                  backgroundImage: QuickHelp.getUserAvatarProvider(user),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            user.getFullName ?? 'Unknown',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimaryColor,
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          if (user.isVerified == true)
                                            Image.asset(
                                              AppImagePath.icVerified,
                                              width: 16.w,
                                              height: 16.h,
                                            ),
                                          SizedBox(width: 8.w),
                                          if (user.getHideMyLocation == false &&
                                              (user.getCountry != null && user.getCountry!.isNotEmpty))
                                            SvgPicture.asset(
                                              QuickActions.getCountryFlag(user),
                                              width: 20.w,
                                              height: 14.h,
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      if (user.getBio?.isNotEmpty ?? false)
                                        Text(
                                          user.getBio ?? '',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColors.textSecondaryColor,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: AppColors.textSecondaryColor,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
