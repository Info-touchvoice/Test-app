import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:tiki/utils/constants/status.dart';
import 'package:tiki/utils/routes/app_routes.dart';
import 'package:tiki/view_model/ranking_controller.dart';

import '../helpers/quick_actions.dart';
import '../helpers/quick_help.dart';
import '../parse/UserModel.dart';

class UserViewModel extends GetxController {
  UserModel currentUser;
  double singleCoinPrice = 0.0106;

  // Cache followers count for a short time to avoid spamming Parse with requests
  final Map<String, int> _followersCountCache = {};
  final Map<String, DateTime> _followersCountCacheAt = {};
  static const Duration _followersCountCacheTtl = Duration(seconds: 15);

  bool isDetailView = false;

  set showFullDetailView(bool value) {
    isDetailView = value;
    update();
  }

  bool get showFullDetailView {
    return isDetailView;
  }

  int get level {
    return currentUser.getLevel ?? 1;
  }

  int get xp {
    return currentUser.getXp ?? 0;
  }

  double get xpFactor {
    return (1 / 5000) * xp;
  }

  double get myBalance {
    return (currentUser.getCoins * singleCoinPrice) * 0.5;
  }

  int get coins {
    return currentUser.getCoins;
  }

  int get beans => currentUser.getBeans;

  int get gold => currentUser.getGold;

  List blockList = [];

  Status status = Status.Loading;

  bool checkCoins(int coins) {
    return currentUser.getCoins >= coins;
  }

  updateUserModel() async {
    try {
      ParseResponse response = await currentUser.save();
      if (response.success && response.results != null) {
        currentUser = response.results!.first as UserModel;
        update();
      } else {
        QuickHelp.showAppNotificationAdvanced(
            context: Get.context!,
            title: "error".tr(),
            message: "try_again_later".tr());
      }
    } catch (e) {
      QuickHelp.showAppNotificationAdvanced(
          context: Get.context!,
          title: "error".tr(),
          message: "try_again_later".tr());
    }
  }

  void updatePersonalDetails(String name, String phone, String birthDate) {
    currentUser.setFullName = name;
    currentUser.setPhoneNumber = phone;
    currentUser.setBirthday = QuickHelp.getDate(birthDate);
  }

  Future<void> updateGender(String gender) async {
    currentUser.setGender = gender;
    await updateUserModel();
  }

  Future<void> updateUserDetails(String name, String gender, String country,
      String birthDate, BuildContext context) async {
    QuickHelp.showLoadingDialog(context);

    String fullName = name;
    String firstName = "";
    String lastName = "";

    if (fullName.contains(" ")) {
      int firstSpace = fullName.indexOf(" ");
      firstName = fullName.substring(0, firstSpace);
      lastName = fullName.substring(firstSpace).trim();
    } else {
      firstName = fullName;
    }

    currentUser.setFullName = fullName;
    currentUser.setFirstName = firstName;
    currentUser.setLastName = lastName;
    currentUser.setGender = gender;
    currentUser.setCountry = country;

    currentUser.setBirthday = QuickHelp.getDate(birthDate);

    ParseResponse userResult = await currentUser.save();

    if (userResult.success) {
      QuickHelp.hideLoadingDialog(context,
          result: userResult.results!.first as UserModel);

      QuickHelp.hideLoadingDialog(context,
          result: userResult.results!.first as UserModel);

      currentUser = userResult.results!.first as UserModel;

      // _getUser();
    } else if (userResult.error!.code == 100) {
      QuickHelp.hideLoadingDialog(context);
      QuickHelp.showAppNotificationAdvanced(
          context: context, title: "error".tr(), message: "not_connected".tr());
    } else {
      QuickHelp.hideLoadingDialog(context);
      // QuickHelp.showAppNotificationAdvanced(
      //     context: context,
      //     title: "error".tr(),
      //     message: "try_again_later".tr());
    }
  }

  Future<void> getFollowers() async {
    List<String> temp = [];
    QueryBuilder<UserModel> queryUsers = QueryBuilder(UserModel.forQuery());

    ParseResponse response = await queryUsers.query();
    if (response.success) {
      if (response.results != null)
        response.results!.forEach((value) {
          UserModel userModel = value as UserModel;
          if (userModel.getFollowing != null &&
              userModel.getFollowing!.contains(currentUser.objectId.toString()))
            temp.add(userModel.objectId!);
        });
      currentUser.resetFollowers = temp;

      currentUser.save();
      update();
    }
  }

  void _invalidateFollowersCountCache(String targetObjectId) {
    _followersCountCache.remove(targetObjectId);
    _followersCountCacheAt.remove(targetObjectId);
  }

  Future<int> getFollowersCountForUser(String? targetObjectId) async {
    final String id = (targetObjectId ?? '').trim();
    if (id.isEmpty) return 0;

    final cachedAt = _followersCountCacheAt[id];
    if (cachedAt != null &&
        DateTime.now().difference(cachedAt) < _followersCountCacheTtl) {
      return _followersCountCache[id] ?? 0;
    }

    try {
      final query = QueryBuilder<UserModel>(UserModel.forQuery())
        // Parse behavior: whereEqualTo on an array field matches "array contains value"
        ..whereEqualTo(UserModel.keyFollowing, id);

      final ParseResponse response = await query.count();
      if (response.success) {
        final int count = response.count ?? 0;
        _followersCountCache[id] = count;
        _followersCountCacheAt[id] = DateTime.now();
        return count;
      }
    } catch (_) {}

    _followersCountCache[id] = 0;
    _followersCountCacheAt[id] = DateTime.now();
    return 0;
  }

  Future<List<UserModel>> getFollowersUsersForUser(
    String? targetObjectId, {
    int limit = 200,
    int skip = 0,
  }) async {
    final String id = (targetObjectId ?? '').trim();
    if (id.isEmpty) return <UserModel>[];

    final query = QueryBuilder<UserModel>(UserModel.forQuery())
      // Parse behavior: whereEqualTo on an array field matches "array contains value"
      ..whereEqualTo(UserModel.keyFollowing, id)
      ..includeObject([UserModel.keyAvatar, UserModel.keyCover])
      ..orderByDescending(UserModel.keyCreatedAt)
      ..setLimit(limit);

    if (skip > 0) {
      query.setAmountToSkip(skip);
    }

    final ParseResponse response = await query.query();
    if (response.success && response.results != null) {
      return response.results!
          .whereType<UserModel>()
          .toList(growable: false);
    }
    return <UserModel>[];
  }

  Future<List> getFollowersUserModel() async {
    QueryBuilder<UserModel> queryUsers = QueryBuilder(UserModel.forQuery());
    queryUsers.whereContainedIn(
        UserModel.keyObjectId, currentUser.getFollowers ?? []);

    ParseResponse response = await queryUsers.query();
    if (response.success) {
      if (response.results != null)
        return response.results!;
      else
        return [];
    } else
      return [];
  }

  Future<void> followOrUnFollow(String objectId, {UserModel? targetUser}) async {
    // NOTE:
    // Don't write into the other user's `followers` list (ACLs usually block it).
    // Followers/subscribers should be derived by querying: users where `following`
    // contains the profile's objectId.

    final List<String> followingLocal = List<String>.from(
      (currentUser.getFollowing ?? const []).map((e) => e.toString()),
    );

    final bool wasFollowing = followingLocal.contains(objectId);

    // Optimistic local update for instant UI
    if (wasFollowing) {
      followingLocal.remove(objectId);
    } else {
      followingLocal.add(objectId);
    }
    currentUser.set<List<String>>(UserModel.keyFollowing, followingLocal);

    // Invalidate cached followers count for the target profile (it changed)
    if (objectId.trim().isNotEmpty) {
      _invalidateFollowersCountCache(objectId.trim());
    }

    update(['subscribe_button']);
    update(['profile_header']);
    update();

    // Persist only on the current user (the logged-in user can write their own `following`)
    final ParseResponse response = await currentUser.save();

    if (!response.success) {
      // rollback local state on failure
      if (wasFollowing) {
        followingLocal.add(objectId);
      } else {
        followingLocal.remove(objectId);
      }
      currentUser.set<List<String>>(UserModel.keyFollowing, followingLocal);

      update(['subscribe_button']);
      update(['profile_header']);
      update();
      return;
    }

    // Sync back from server (keeps state consistent across screens)
    try {
      if (response.results != null && response.results!.isNotEmpty) {
        currentUser = response.results!.first as UserModel;
      } else {
        await currentUser.fetch();
      }
    } catch (_) {}

    update(['subscribe_button']);
    update(['profile_header']);
    update();
  }

  bool followingUser(UserModel user) {
    if (currentUser.getFollowing!.contains(user.objectId)) {
      return true;
    } else {
      return false;
    }
  }

  getDeviceName(BuildContext context) async {
    currentUser.setDevice = await QuickActions.getDeviceName(context);
    ParseResponse response = await currentUser.save();
    if (response.success) {
      if (response.results != null && response.results!.isNotEmpty) {
        currentUser = response.results!.first as UserModel;
        update();
      }
    }
  }

  bool isUserInBlockList(UserModel userModel) {
    if (currentUser.getBlockedUsersIds!.contains(userModel.getUid!))
      return true;
    else
      return false;
  }

  addOrRemoveFromBlockList(UserModel mUser, BuildContext context,
      {bool back = true}) {
    if (isUserInBlockList(mUser))
      QuickActions.showAlertDialog(
          context, 'Are you sure you want to add user to block list?', () {
        currentUser.setBlockedUserIds = mUser.getUid!;
        currentUser.save().then((value) {
          currentUser.update();
          if (back == true) {
            Get.back();
            Get.back();
          }
          QuickHelp.showAppNotificationAdvanced(
              title: 'User Added to Block List!',
              context: context,
              isError: false);
        });
      });
    else {
      QuickActions.showAlertDialog(
          context, 'Are you sure you want to remove user from block list?', () {
        currentUser.removeBlockedUserIds = mUser.getUid!;
        currentUser.save().then((value) {
          currentUser.update();
          if (back == true) {
            Get.back();
            Get.back();
          }
          QuickHelp.showAppNotification(
              title: 'User removed from Block List!',
              context: context,
              isError: false);
        });
      });
    }
  }

  addToBlockList(int mUid) async {
    currentUser.setBlockedUserIds = mUid;
    ParseResponse response = await currentUser.save();
    if (response.success) {
      if (response.results != null) {
        currentUser = response.results!.first as UserModel;
        update();
      }
    }
  }

  removeFromBlockList(int mUid) async {
    currentUser.removeBlockedUserIds = mUid;
    ParseResponse response = await currentUser.save();
    if (response.success) {
      if (response.results != null) {
        currentUser = response.results!.first as UserModel;
        update();
      }
    }
  }

  deductBalance(int coins, {bool save = false}) {
    currentUser.decrementCoins = coins;
    if (save == true) currentUser.save();
    addXp(100);
  }

  Future addBalance(int coins) async {
    currentUser.setCoins = coins;
    ParseResponse response = await currentUser.save();
    if (response.success) {
      if (response.results != null) {
        currentUser = response.results!.first as UserModel;
        update();
        Get.find<RankingViewModel>().addCoinsRecord(coins);
      }
    }
  }

  Future<bool> addBeans(int amount) async {
    currentUser.setBeans = amount;
    final response = await currentUser.save();
    if (response.success && response.results != null) {
      currentUser = response.results!.first as UserModel;
      update();
      return true;
    }
    return false;
  }

  Future<bool> addGold(int amount) async {
    currentUser.setGold = amount;
    final response = await currentUser.save();
    if (response.success && response.results != null) {
      currentUser = response.results!.first as UserModel;
      update();
      return true;
    }
    return false;
  }

  Future<bool> exchangeDiamondsToBeans(int diamondAmount, int beansReceived) async {
    if (diamondAmount <= 0 || currentUser.getCoins < diamondAmount) return false;
    currentUser.decrementCoins = diamondAmount;
    currentUser.setBeans = beansReceived;
    final response = await currentUser.save();
    if (response.success && response.results != null) {
      currentUser = response.results!.first as UserModel;
      update();
      return true;
    }
    return false;
  }

  addXp(int xp, {Function? then}) async {
    int xpTemp = currentUser.getXp!;
    xpTemp = xpTemp + xp;
    if (xpTemp >= 5000) {
      currentUser.setXp = (xpTemp - 5000);
      currentUser.incrementLevel = 1;
      ParseResponse response = await currentUser.save();
      if (response.success) {
        currentUser = response.results!.first as UserModel;
        update();
        Get.find<RankingViewModel>().addLevelRecord(xp);
      }
    } else if (xpTemp <= 50 &&
        (currentUser.getLevel == 1 || currentUser.getLevel == null)) {
      currentUser.setXp = xpTemp;
      currentUser.setLevel = 1;
      ParseResponse response = await currentUser.save();
      if (response.success) {
        currentUser = response.results!.first as UserModel;
        update();
        Get.find<RankingViewModel>().addLevelRecord(xp);
      }
    } else {
      currentUser.incrementXp = xp;
      ParseResponse response = await currentUser.save();
      if (response.success) {
        currentUser = response.results!.first as UserModel;
        update();
        Get.find<RankingViewModel>().addLevelRecord(xp);
      }
    }
  }

  hideMyLocation(bool value) async {
    currentUser.setHideMyLocation = value;
    ParseResponse response = await currentUser.save();
    if (response.success) {
      currentUser = response.results!.first as UserModel;
      update();
    }
  }

  hideMyBirthday(bool value) async {
    currentUser.setHideMyBirthday = value;
    ParseResponse response = await currentUser.save();
    if (response.success) {
      currentUser = response.results!.first as UserModel;
      update();
    }
  }

  blockUserList() async {
    QueryBuilder<UserModel> query = QueryBuilder(UserModel.forQuery());
    query.whereContainedIn(
        UserModel.keyUid, currentUser.getBlockedUsersIds ?? []);
    ParseResponse response = await query.query();
    if (response.success) {
      if (response.results != null && response.results!.isNotEmpty) {
        blockList = response.results!;
        status = Status.Completed;
        update();
      } else {
        blockList = [];
        status = Status.Completed;
        update();
      }
    } else {
      status = Status.Completed;
      update();
    }
  }

  changeSelfBanStatus() async {
    currentUser.setSelfBanStatus = !currentUser.getSelfBanStatus;
    ParseResponse response = await currentUser.save();
    if (response.success) {
      if (response.results != null && response.results!.isNotEmpty) {
        currentUser = response.results!.first as UserModel;
        update();
      }
    }
  }

  deleteAccount(BuildContext context) async {
    currentUser.setAccountDeleted = true;
    ParseResponse response = await currentUser.save();
    if (response.success) {
      QuickHelp.showAppNotification(
          title: "Account deleted Successfully",
          context: context,
          isError: false);
      currentUser
          .logout()
          .then((value) => Get.offAllNamed(AppRoutes.onBoarding));
    }
  }

  bool ifGoogleAccountConnected() {
    return currentUser.authData != null &&
        currentUser.authData!.containsKey('Google');
  }

  void verifyUser() {
    DateTime now = DateTime.now().toUtc();

    // Add 1 calendar month safely
    int year = now.year;
    int month = now.month + 1;
    int day = now.day;

    // Handle year rollover
    if (month > 12) {
      month = 1;
      year += 1;
    }

    // Handle invalid dates (e.g., February 30)
    int lastDayOfMonth = DateTime(year, month + 1, 0).day;
    if (day > lastDayOfMonth) {
      day = lastDayOfMonth;
    }

    DateTime expiryDate =
        DateTime.utc(year, month, day, now.hour, now.minute, now.second);

    currentUser.verifyUser = true;
    currentUser.verificationExpiredDate = expiryDate;
    currentUser.save();
    update();
  }

  updateViewModel() {
    update();
  }

  UserViewModel(this.currentUser);

  @override
  void onInit() {
    currentUser = this.currentUser;
    super.onInit();
  }
}
