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

class UserSubscriptionsListScreen extends StatefulWidget {
  final UserModel? userModel;

  const UserSubscriptionsListScreen({Key? key, this.userModel}) : super(key: key);

  @override
  State<UserSubscriptionsListScreen> createState() => _UserSubscriptionsListScreenState();
}

class _UserSubscriptionsListScreenState extends State<UserSubscriptionsListScreen> {
  List<UserModel> subscriptionsList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSubscriptions();
  }

  Future<void> _fetchSubscriptions() async {
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

      final followingIds = user.getFollowing;
      if (followingIds == null || followingIds.isEmpty) {
        setState(() {
          isLoading = false;
          subscriptionsList = [];
        });
        return;
      }

      // Convert IDs to appropriate type (could be String or int)
      List<dynamic> idList = followingIds.map((id) {
        if (id is int) return id;
        if (id is String) {
          // Try to parse as int (UID) or use as string (objectId)
          return int.tryParse(id) ?? id;
        }
        return id;
      }).toList();

      QueryBuilder<UserModel> query = QueryBuilder<UserModel>(UserModel.forQuery());
      
      // Try querying by UID first (if IDs are integers)
      if (idList.isNotEmpty && idList.first is int) {
        query.whereContainedIn(UserModel.keyUid, idList);
      } else {
        // Otherwise query by objectId
        query.whereContainedIn(UserModel.keyObjectId, idList);
      }
      
      query.includeObject([UserModel.keyAvatar, UserModel.keyCover]);
      query.orderByDescending(UserModel.keyCreatedAt);

      ParseResponse response = await query.query();

      if (response.success && response.results != null) {
        List<UserModel> tempList = [];
        for (var result in response.results!) {
          if (result is UserModel) {
            tempList.add(result);
          }
        }
        setState(() {
          subscriptionsList = tempList;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          subscriptionsList = [];
        });
      }
    } catch (e) {
      print('Error fetching subscriptions: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load subscriptions';
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
          'Subscriptions',
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
              : subscriptionsList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "*  ",
                            style: sfProDisplayBlack.copyWith(color: Colors.red),
                          ),
                          Text(
                            "No Subscriptions",
                            style: sfProDisplayMedium.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      itemCount: subscriptionsList.length,
                      itemBuilder: (context, index) {
                        UserModel user = subscriptionsList[index];
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
