import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:tiki/helpers/quick_actions.dart';
import 'package:tiki/view_model/userViewModel.dart';

import '../model/popular_card_model.dart';
import '../parse/LiveStreamingModel.dart';
import '../parse/UserModel.dart';
import '../services/group_history_service.dart';
import '../utils/constants/status.dart';
import '../services/my_audio_group_service.dart';

class AudioHomeViewModel extends GetxController {
  String tempImagePath1 =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi-9Q5sx5ZaCLtCieoMMf_PITwvg9SYnwALQ&s';

  Status status = Status.Loading;
  Status relatedStatus = Status.Loading;

  List<PopularModel> audioLiveModelList = [];
  List<PopularModel> recentGroupList = [];
  List<PopularModel> joinedGroupList = [];
  PopularModel? myOwnedGroup;
  List<UserModel> newUserList = [];
  List<PopularModel> newRoomList = [];

  LiveQuery liveQuery = LiveQuery();
  Subscription? subscription;

  Future<void> loadLive({battle = false}) async {
    QueryBuilder<UserModel> queryUsers = QueryBuilder(UserModel.forQuery());
    queryUsers.whereValueExists(UserModel.keyUserStatus, true);
    queryUsers.whereEqualTo(UserModel.keyUserStatus, true);

    QueryBuilder<LiveStreamingModel> queryBuilder =
        QueryBuilder<LiveStreamingModel>(LiveStreamingModel());

    queryBuilder.whereEqualTo(LiveStreamingModel.keyStreaming, true);
    queryBuilder.whereEqualTo(LiveStreamingModel.keyStreamingType,
        LiveStreamingModel.keyTypeAudioLive);
    queryBuilder.whereNotEqualTo(LiveStreamingModel.keyAuthorUid,
        Get.find<UserViewModel>().currentUser.getUid);
    queryBuilder.whereNotContainedIn(LiveStreamingModel.keyAuthorUid,
        Get.find<UserViewModel>().currentUser.getBlockedUsersIds!);
    queryBuilder.whereValueExists(LiveStreamingModel.keyAuthor, true);
    queryBuilder.whereDoesNotMatchQuery(
        LiveStreamingModel.keyAuthor, queryUsers);

    queryBuilder.orderByDescending(LiveStreamingModel.keyCreatedAt);
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
    audioLiveModelList = tempModelList;
  }

  void _loadEmptyApiData() {
    audioLiveModelList = [];
    status = Status.Completed;
    update();
  }

  Future<void> loadMyOwnedGroup() async {
    final owned = await MyAudioGroupService.findOwnedRoom();
    if (owned == null) {
      myOwnedGroup = null;
      update();
      return;
    }
    myOwnedGroup = _popularFromOwnedLiveModel(owned);
    update();
  }

  PopularModel _popularFromOwnedLiveModel(LiveStreamingModel liveModel) {
    final author = liveModel.getAuthor;
    final coverUrl = liveModel.getImage?.url ??
        author?.getAvatar?.url ??
        tempImagePath1;
    return PopularModel(
      name: liveModel.getTitle ?? author?.getFullName ?? 'My Group',
      avatar: author?.getAvatar?.url ?? coverUrl,
      flag: author != null ? QuickActions.getCountryFlag(author) : '',
      country: author != null
          ? '${QuickActions.getCountryCode(author)} '
          : '',
      liveModel: liveModel,
      achievementCount: liveModel.getViewersCount ?? 0,
      image: coverUrl,
    );
  }

  String welcomeMessageFor(LiveStreamingModel liveModel) {
    final text = liveModel.getRoomAnnouncement?.trim();
    if (text != null && text.isNotEmpty) return text;
    return MyAudioGroupService.defaultRoomWelcome;
  }

  Future<void> loadRecentGroups() async {
    relatedStatus = Status.Loading;
    update();
    await loadMyOwnedGroup();
    final entries = await GroupHistoryService.getRecent();
    recentGroupList = await _resolveGroupEntries(entries);
    relatedStatus = Status.Completed;
    update();
  }

  Future<void> loadJoinedGroups() async {
    relatedStatus = Status.Loading;
    update();
    await loadMyOwnedGroup();
    final entries = await GroupHistoryService.getJoined();
    joinedGroupList = await _resolveGroupEntries(entries);
    relatedStatus = Status.Completed;
    update();
  }

  Future<List<PopularModel>> _resolveGroupEntries(
      List<GroupHistoryEntry> entries) async {
    if (entries.isEmpty) return [];

    final ids = entries.map((e) => e.objectId).toList();
    final liveById = <String, LiveStreamingModel>{};

    final queryBuilder =
        QueryBuilder<LiveStreamingModel>(LiveStreamingModel());
    queryBuilder.whereContainedIn(LiveStreamingModel.keyObjectId, ids);
    queryBuilder.includeObject([LiveStreamingModel.keyAuthor]);

    final response = await queryBuilder.query();
    if (response.success && response.results != null) {
      for (final result in response.results!) {
        final liveModel = result as LiveStreamingModel;
        if (liveModel.objectId != null) {
          liveById[liveModel.objectId!] = liveModel;
        }
      }
    }

    final rooms = <PopularModel>[];
    for (final entry in entries) {
      final liveModel = liveById[entry.objectId];
      if (liveModel != null) {
        rooms.add(_popularFromLiveModel(liveModel));
      } else {
        rooms.add(_popularFromHistoryEntry(entry));
      }
    }
    return rooms;
  }

  PopularModel _popularFromLiveModel(LiveStreamingModel liveModel) {
    return PopularModel(
      name: liveModel.getAuthor!.getFullName!,
      avatar: liveModel.getAuthor!.getAvatar!.url!,
      flag: QuickActions.getCountryFlag(liveModel.getAuthor!),
      country: '${QuickActions.getCountryCode(liveModel.getAuthor!)} ',
      liveModel: liveModel,
      achievementCount:
          liveModel.getViewsCount ?? liveModel.getAuthor!.getCoins ?? 0,
      image: liveModel.getImage != null
          ? liveModel.getImage!.url!
          : tempImagePath1,
    );
  }

  PopularModel _popularFromHistoryEntry(GroupHistoryEntry entry) {
    final liveModel = LiveStreamingModel();
    liveModel.objectId = entry.objectId;
    liveModel.setTitle = entry.name;
    liveModel.setStreamingType = LiveStreamingModel.keyTypeAudioLive;
    liveModel.setStreaming = false;

    return PopularModel(
      name: entry.name,
      avatar: entry.image,
      flag: entry.flag,
      country: entry.country,
      liveModel: liveModel,
      achievementCount: entry.achievementCount,
      image: entry.image,
    );
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

  Future<void> loadNewSection() async {
    relatedStatus = Status.Loading;
    update();

    final currentUser = Get.find<UserViewModel>().currentUser;

    final userQuery = QueryBuilder<UserModel>(UserModel.forQuery());
    userQuery.whereValueExists(UserModel.keyUserStatus, true);
    userQuery.whereEqualTo(UserModel.keyUserStatus, true);
    userQuery.whereNotEqualTo(UserModel.keyUid, currentUser.getUid);
    userQuery.whereNotContainedIn(
        UserModel.keyUid, currentUser.getBlockedUsersIds ?? []);
    userQuery.orderByDescending(UserModel.keyCreatedAt);
    userQuery.setLimit(8);

    final roomQuery = QueryBuilder<LiveStreamingModel>(LiveStreamingModel());
    roomQuery.whereEqualTo(LiveStreamingModel.keyStreaming, true);
    roomQuery.whereEqualTo(
        LiveStreamingModel.keyStreamingType, LiveStreamingModel.keyTypeAudioLive);
    roomQuery.whereNotEqualTo(
        LiveStreamingModel.keyAuthorUid, currentUser.getUid);
    roomQuery.orderByDescending(LiveStreamingModel.keyCreatedAt);
    roomQuery.setLimit(12);
    roomQuery.includeObject([LiveStreamingModel.keyAuthor]);

    final results = await Future.wait([userQuery.query(), roomQuery.query()]);

    newUserList = [];
    if (results[0].success && results[0].results != null) {
      newUserList = results[0].results!.cast<UserModel>();
    }

    newRoomList = [];
    if (results[1].success && results[1].results != null) {
      for (final item in results[1].results!) {
        newRoomList.add(_popularFromLiveModel(item as LiveStreamingModel));
      }
    }

    relatedStatus = Status.Completed;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadLive();
  }

  AudioHomeViewModel();
}
