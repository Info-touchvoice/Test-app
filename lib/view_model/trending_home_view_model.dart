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

class TrendingHomeViewModel extends GetxController {
  String tempImagePath1 =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi-9Q5sx5ZaCLtCieoMMf_PITwvg9SYnwALQ&s';

  Status status = Status.Loading;

  List<PopularModel> popularModelList = [];

  LiveQuery liveQuery = LiveQuery();
  Subscription? subscription;

  Future<void> loadLive({battle = false}) async {
    QueryBuilder<UserModel> queryUsers = QueryBuilder(UserModel.forQuery());
    queryUsers.whereValueExists(UserModel.keyUserStatus, true);
    queryUsers.whereEqualTo(UserModel.keyUserStatus, true);

    QueryBuilder<LiveStreamingModel> queryBuilder =
        QueryBuilder<LiveStreamingModel>(LiveStreamingModel());

    queryBuilder.whereEqualTo(LiveStreamingModel.keyStreaming, true);
    queryBuilder.whereNotEqualTo(LiveStreamingModel.keyAuthorUid,
        Get.find<UserViewModel>().currentUser.getUid);
    queryBuilder.whereNotContainedIn(LiveStreamingModel.keyAuthorUid,
        Get.find<UserViewModel>().currentUser.getBlockedUsersIds!);
    queryBuilder.whereValueExists(LiveStreamingModel.keyAuthor, true);
    queryBuilder.whereDoesNotMatchQuery(
        LiveStreamingModel.keyAuthor, queryUsers);

    queryBuilder.orderByDescending(LiveStreamingModel.keyViewersCountLive);
    queryBuilder.setLimit(10);

    queryBuilder.setLimit(25);
    queryBuilder.includeObject([
      LiveStreamingModel.keyAuthor,
    ]);

    ParseResponse apiResponse = await queryBuilder.query();
    if (apiResponse.success) {
      if (apiResponse.results != null) {
        _loadApiData(apiResponse.results ?? []).then((value) {
          status = Status.Completed;
          update();
        });
      } else {
        _loadEmptyApiData();
      }
    } else {
      status = Status.Error;
      update();
    }
  }

  Future<void> _loadApiData(List<dynamic> result) async {
    List<PopularModel> tempModelList = [];

    result.forEach((value) {
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
              : tempImagePath1);

      tempModelList.add(popularModel);
    });
    popularModelList = tempModelList;
  }

  void _loadEmptyApiData() {
    popularModelList = [];
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

      loadLive();
    });
  }

  unSubscribeLiveStreamingModel() async {
    if (subscription != null) {
      liveQuery.client.unSubscribe(subscription!);
    }
    subscription = null;
  }

  @override
  void onInit() {
    super.onInit();

    loadLive();
  }

  TrendingHomeViewModel();
}
