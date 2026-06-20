import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:tiki/helpers/quick_actions.dart';
import 'package:tiki/view_model/userViewModel.dart';

import '../model/popular_card_model.dart';
import '../parse/LiveStreamingModel.dart';
import '../parse/UserModel.dart';
import '../utils/constants/status.dart';

class HomeLiveViewModel extends GetxController {
  String tempImagePath1 =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi-9Q5sx5ZaCLtCieoMMf_PITwvg9SYnwALQ&s';

  RxBool isNearbySelected = true.obs;

  Status status = Status.Loading;

  List<PopularModel> nearbyLiveModelList = [];

  List<PopularModel> popularModelList = [];

  LiveQuery liveQuery = LiveQuery();
  Subscription? subscription;

  switchToggle(bool nearby) {
    if (nearby == true) {
      isNearbySelected.value = true;
      update();
    } else {
      isNearbySelected.value = false;
      update();
    }
  }

  Future<void> loadNearbyLives() async {
    // If the current user has no location saved yet, "Nearby" will always be empty/error.
    // In that case, auto-fallback to "Popular" so the Live tab still shows streams.
    final currentUser = Get.find<UserViewModel>().currentUser;
    if (currentUser.getGeoPoint == null) {
      isNearbySelected.value = false;
      update();
      await loadPopularLives();
      return;
    }

    await _loadLives(isNearby: true);

    // If the nearby query returns nothing (common when streamers don't have geo),
    // fallback to Popular so the Live tab never looks "broken".
    if (nearbyLiveModelList.isEmpty) {
      isNearbySelected.value = false;
      update();
      await loadPopularLives();
    }
  }

  Future<void> loadPopularLives() async {
    await _loadLives(isNearby: false);
  }

  Future<void> _loadLives({required bool isNearby}) async {
    final currentUser = Get.find<UserViewModel>().currentUser;

    if (isNearby == true && currentUser.getGeoPoint == null) {
      status = Status.Error;
      update();
      return;
    }

    // Active user filter
    QueryBuilder<UserModel> queryUsers = QueryBuilder(UserModel.forQuery());
    queryUsers.whereValueExists(UserModel.keyUserStatus, true);
    queryUsers.whereEqualTo(UserModel.keyUserStatus, true);

    // Live streaming filter
    QueryBuilder<LiveStreamingModel> queryBuilder =
        QueryBuilder<LiveStreamingModel>(LiveStreamingModel());

    queryBuilder.whereEqualTo(LiveStreamingModel.keyStreaming, true);
    queryBuilder.whereNotEqualTo(
        LiveStreamingModel.keyAuthorUid, currentUser.getUid);
    queryBuilder.whereNotContainedIn(
        LiveStreamingModel.keyAuthorUid, currentUser.getBlockedUsersIds ?? []);
    queryBuilder.whereValueExists(LiveStreamingModel.keyAuthor, true);
    queryBuilder.whereDoesNotMatchQuery(
        LiveStreamingModel.keyAuthor, queryUsers);

    // Include relations
    queryBuilder.includeObject([
      LiveStreamingModel.keyAuthor,
      LiveStreamingModel.keyAuthorInvited,
      LiveStreamingModel.keyPrivateLiveGift,
    ]);

    if (isNearby) {
      final ParseGeoPoint currentGeoPoint = currentUser.getGeoPoint!;
      // Nearby lives within 500 km
      queryBuilder.whereNear(
        '${LiveStreamingModel.keyAuthor}.${UserModel.keyGeoPoint}',
        currentGeoPoint,
      );
      queryBuilder.whereWithinKilometers(
        '${LiveStreamingModel.keyAuthor}.${UserModel.keyGeoPoint}',
        currentGeoPoint,
        500,
      );
      queryBuilder.orderByDescending(LiveStreamingModel.keyCreatedAt);
    } else {
      // Popular lives (most followed streamers)
      queryBuilder.orderByDescending(LiveStreamingModel.keyStreamerFollowers);
    }

    queryBuilder.setLimit(25);

    ParseResponse apiResponse = await queryBuilder.query();

    if (apiResponse.success) {
      if (apiResponse.results != null) {
        await _loadApiData(apiResponse.results!, isNearby: isNearby);
        status = Status.Completed;
      } else {
        _loadEmptyApiData(isNearby: isNearby);
      }
    } else {
      status = Status.Error;
    }

    update();
  }

  Future<void> _loadApiData(List<dynamic> result,
      {required bool isNearby}) async {
    List<PopularModel> tempModelList = [];

    for (var value in result) {
      LiveStreamingModel liveModel = value as LiveStreamingModel;

      PopularModel popularModel = PopularModel(
        name: liveModel.getAuthor!.getFullName!,
        avatar: liveModel.getAuthor!.getAvatar!.url!,
        flag: QuickActions.getCountryFlag(liveModel.getAuthor!),
        country: '${QuickActions.getCountryCode(liveModel.getAuthor!)} ',
        liveModel: liveModel,
        achievementCount: liveModel.getAuthor!.getCoins ?? 0,
        image: liveModel.getImage != null
            ? liveModel.getImage!.url!
            : tempImagePath1,
      );

      tempModelList.add(popularModel);
    }

    if (isNearby) {
      nearbyLiveModelList = tempModelList;
    } else {
      popularModelList = tempModelList;
    }
  }

  void _loadEmptyApiData({required bool isNearby}) {
    if (isNearby) {
      nearbyLiveModelList = [];
    } else {
      popularModelList = [];
    }
    status = Status.Completed;
    update();
  }

  subscribeLiveStreamingModel() async {
    QueryBuilder query = QueryBuilder(LiveStreamingModel());

    query.includeObject([
      LiveStreamingModel.keyAuthor,
      LiveStreamingModel.keyBattleModel,
    ]);

    subscription = await liveQuery.client.subscribe(query);

    subscription!.on(LiveQueryEvent.update, (value) async {
      if (kDebugMode) {
        print('*** livestreaming UPDATE ***');
        print('*** livestreaming UPDATE ***');
      }

      loadNearbyLives();
      loadPopularLives();
    });
  }

  unSubscribeLiveStreamingModel() async {
    if (subscription != null) {
      liveQuery.client.unSubscribe(subscription!);
    }
    subscription = null;
  }

  HomeLiveViewModel();
}
