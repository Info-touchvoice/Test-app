import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiki/helpers/quick_actions.dart';
import 'package:tiki/parse/BattleStreamingModel.dart';
import 'package:tiki/parse/LiveStreamingModel.dart';
import 'package:tiki/view_model/gift_contoller.dart';
import 'package:tiki/view_model/live_messages_controller.dart';
import 'package:tiki/view_model/ranking_controller.dart';
import 'package:tiki/view_model/userViewModel.dart';
import 'package:tiki/view_model/youtube_controller.dart';
import 'package:tiki/view_model/zego_controller.dart';
import 'package:tiki/compat/wakelock.dart';

import '../data/app/setup.dart';
import '../helpers/quick_help.dart';
import '../parse/RankingModel.dart';
import '../parse/UserModel.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/status.dart';
import '../services/group_history_service.dart';
import '../services/my_audio_group_service.dart';
import '../services/room_settings_store.dart';
import '../utils/routes/app_routes.dart';
import '../view/screens/live/zegocloud/zim_zego_sdk/internal/business/business_define.dart';
import 'audio_home_view_model.dart';
import '../view/screens/live/zegocloud/zim_zego_sdk/internal/internal_defines.dart';
import 'multi_guest_grid_controller.dart';

class LiveViewModel extends GetxController {
  ZegoLiveRole role;
  final LiveStreamingModel? liveModel;
  bool _handledForceEnd = false;

  //---- live preview-------
  final List bottomTab = [
    LiveStreamingModel.keyTypeAudioLive,
  ];

  late Timer liveTimer;
  RxInt liveTime = 0.obs;

  int audioLiveIndex = 0;

  int? receiverUid;

  /// 0 = 8 co-host seats (9P), 1 = 11 co-host seats (12P total with host).
  final RxInt nineMemberIndex = 1.obs;
  final RxString selectedGuestSeat = "4P".obs;
  //--------------------

  RxString title = ''.obs;
  RxString mode = 'Public'.obs;
  RxList tagList = [].obs;
  RxString selectedLanguage = 'Language'.obs;
  RxString roomAnnouncement = ''.obs;
  LiveStreamingModel liveStreamingModel = LiveStreamingModel();
  late LiveStreamingModel tempLiveStreamingModel;
  LiveQuery liveQuery = LiveQuery();
  Subscription? subscription;
  int giftListLength = 0;
  List giftSendersList = [];
  RxBool isCameraOn = true.obs;
  ParseFileBase? parseFile;
  ParseFileBase? backgroundImage;
  ParseFileBase? savedBackgroundImage;
  String? presetThemeAsset;
  String? presetThemeUrl;
  String? customThemeUrl;
  RxString selectedLiveType = LiveStreamingModel.keyTypeAudioLive.obs;
  List viewerList = [];
  RxBool giftAnimation = true.obs;

  //------ people who are live list
  List<UserModel> liveUsers = [];

  //------ people who are live list
  List<UserModel> friendsList = [];

  final List stickerPaths = [
    AppImagePath.sticker1,
    AppImagePath.background1,
  ];

  Widget? video;

  List<UserModel> multiGuestCoHostList = [];
  List<UserModel> audioCoHostList = [];

  List? myWishList = [];

  List blockList = [];
  List disableList = [];
  List adminList = [];

  Status status = Status.Completed;

  RxBool dislike = false.obs;

  RxBool chatField = false.obs;
  TextEditingController chatEditingController = TextEditingController();

  List<Map> hostGifters = [];
  List<String> hostGiftersAvatar = [];
  Map<String, dynamic> senderDetail = {};
  RxBool showGiftBanner = false.obs;

  bool get isSingleLive {
    return liveStreamingModel.getStreamingType ==
        LiveStreamingModel.keyTypeSingleLive;
  }

  bool get isAudioLive {
    return liveStreamingModel.getStreamingType ==
        LiveStreamingModel.keyTypeAudioLive;
  }

  bool get isMultiGuest {
    return liveStreamingModel.getStreamingType ==
        LiveStreamingModel.keyTypeMultiGuestLive;
  }

  bool get isMultiSeat3 {
    return liveStreamingModel.getMultiSeats ==
        LiveStreamingModel.keyTypeMultiThreeSeat;
  }

  bool get isMultiSeat4 {
    return liveStreamingModel.getMultiSeats ==
        LiveStreamingModel.keyTypeMultiFourSeat;
  }

  bool get isMultiSeat6 {
    return liveStreamingModel.getMultiSeats ==
        LiveStreamingModel.keyTypeMultiSixSeat;
  }

  bool get isMultiSeat9 {
    return liveStreamingModel.getMultiSeats ==
        LiveStreamingModel.keyTypeMultiNineSeat;
  }

  bool get isMultiSeat12 {
    return liveStreamingModel.getMultiSeats ==
        LiveStreamingModel.keyTypeMultiTwelveSeat;
  }

  set toggleDislike(bool value) {
    dislike.value = !dislike.value;
  }

  addParseFile(
      ParseFileBase? file, File imageFile, BuildContext context) async {
    parseFile = file;
    liveStreamingModel.setImage = file!;
    ParseResponse response = await liveStreamingModel.save();
    if (response.success && response.results != null) {
      liveStreamingModel = response.results!.first;
      QuickHelp.hideLoadingDialog(context);
      QuickHelp.hideLoadingDialog(context);
      update();
    } else {
      QuickHelp.hideLoadingDialog(context);
      QuickHelp.hideLoadingDialog(context);
    }
  }

  addBackGroundImage(
      ParseFileBase? file, File imageFile, BuildContext context) async {
    parseFile = file;
    liveStreamingModel.setBackgroundImage = file!;
    savedBackgroundImage = file;
    presetThemeAsset = null;
    customThemeUrl = file.url;
    ParseResponse response = await liveStreamingModel.save();
    if (response.success && response.results != null) {
      liveStreamingModel = response.results!.first;
      QuickHelp.hideLoadingDialog(context);
      QuickHelp.hideLoadingDialog(context);
      stickerPaths.insert(2, liveStreamingModel.getBackgroundImage!.url!);
      update();
      update();
    } else {
      QuickHelp.hideLoadingDialog(context);
      QuickHelp.hideLoadingDialog(context);
    }
  }

  updateLiveStreamingModel() {
    update();
  }

  saveLiveStreamingModel() {
    liveStreamingModel.save();
  }

  void applyRoomThemeSettings(RoomSettingsData data) {
    presetThemeAsset = data.activePresetTheme;
    presetThemeUrl = _isNetworkTheme(data.activePresetTheme)
        ? data.activePresetTheme
        : null;
    customThemeUrl = data.activeCustomThemeUrl;
    if (presetThemeUrl != null || presetThemeAsset != null) {
      backgroundImage = null;
    }
    update();
  }

  bool _isNetworkTheme(String? value) {
    if (value == null || value.isEmpty) return false;
    return value.startsWith('http://') || value.startsWith('https://');
  }

  Future<void> loadRoomThemeSettings() async {
    if (!isAudioLive || liveStreamingModel.objectId == null) return;
    final roomName = liveStreamingModel.getTitle?.trim().isNotEmpty == true
        ? liveStreamingModel.getTitle!.trim()
        : (liveStreamingModel.getAuthor?.getFullName ?? 'Touch Voice');
    final data = await RoomSettingsStore.load(
      liveStreamingModel.objectId,
      liveStreamingModel,
      defaultIntro: '$roomName Room',
    );
    applyRoomThemeSettings(data);
  }

  Future<void> toggleCamera(CameraController cameraController) async {
    if (isCameraOn.value) {
      await cameraController.pausePreview();
    } else {
      await cameraController.resumePreview();
    }

    isCameraOn.value = !isCameraOn.value;
  }

  subscribeLiveStreamingModel() async {
    QueryBuilder<LiveStreamingModel> query =
        QueryBuilder<LiveStreamingModel>(LiveStreamingModel());

    query.whereEqualTo(
        LiveStreamingModel.keyObjectId, liveStreamingModel.objectId);
    query.includeObject([
      LiveStreamingModel.keyAuthor,
      LiveStreamingModel.keyBattleModel,
    ]);

    subscription = await liveQuery.client.subscribe(query);

    if (isAudioLive) {
      loadRoomThemeSettings();
    }

    subscription!.on(LiveQueryEvent.update, (LiveStreamingModel value) async {
      if (kDebugMode) {
        print('*** livestreaming UPDATE ***');
        print('*** livestreaming UPDATE ***');
      }

      UserModel author = liveStreamingModel.getAuthor!;

      liveStreamingModel = value;
      liveStreamingModel.setAuthor = author;
      if (liveStreamingModel.getGiftsList!.length > giftListLength) {
        giftListLength = liveStreamingModel.getGiftsList!.length;
        Map lastGift = liveStreamingModel.getGiftsList!.last;
        String gift = lastGift["gift"];
        String audio = lastGift["audio"];
        Get.find<GiftViewModel>().loadAnimation(gift, audio);
        addGifterList(lastGift);
        addGiftCoins(lastGift);
        showGiftReceiverBanner(lastGift);
      }
      if (liveStreamingModel.getMyWishList != null) {
        myWishList = liveStreamingModel.getMyWishList!;
      }

      if (isAudioLive && Get.isRegistered<ZegoController>()) {
        final seats = value.getAudioSeats;
        if (seats != null) {
          final zego = Get.find<ZegoController>();
          if (zego.liveAudioRoomManager.seatList.length != seats) {
            zego.updateAudioSeatCount(seats);
          }
        }
      }

      update();

      updateViewersList(value.getViewersId ?? []);
      isExpandedFeatureActive();

      if (value.getStreaming == false && role == ZegoLiveRole.audience) {
        closeAlert(Get.context!, forceEnded: true);
      }

      // If admin ended the live in dashboard, force-end the HOST too.
      // Without this, host keeps streaming because only the Parse flag is changed.
      if (value.getStreaming == false &&
          role == ZegoLiveRole.host &&
          (value.isLiveCancelledByAdmin ?? false) == true) {
        _handleHostForceEndByAdmin();
      }
      setYoutubeControllerValue();
      checkKickOutUserList(value);
      blockUserList(value);
      getDisableChatUsers(value);
      getAdminList(value);
      changeBackgroundImage(value);
    });
  }

  Future<void> _handleHostForceEndByAdmin() async {
    if (_handledForceEnd) return;
    _handledForceEnd = true;

    try {
      cancelLiveTimer();
    } catch (_) {}

    try {
      await unSubscribeLiveStreamingModel();
    } catch (_) {}

    try {
      await Get.find<LiveMessagesViewModel>().unSubscribeLiveMessageModels();
    } catch (_) {}

    try {
      await Get.find<ZegoController>().unSubscribeZegoService();
    } catch (_) {}

    try {
      await AppWakelock.disable();
    } catch (_) {}

    // Navigate host to end screen (same as when they end manually)
    try {
      Get.toNamed(AppRoutes.endScreen, arguments: true);
    } catch (_) {}
  }

  Future unSubscribeLiveStreamingModel() async {
    if (subscription != null) {
      liveQuery.client.unSubscribe(subscription!);
    }
    subscription = null;
  }

  static const String defaultRoomWelcome = MyAudioGroupService.defaultRoomWelcome;

  static Future<LiveStreamingModel?> findMyOwnedAudioRoom() =>
      MyAudioGroupService.findOwnedRoom();

  static Future<LiveStreamingModel?> findMyActiveAudioRoom() =>
      MyAudioGroupService.findActiveRoom();

  static void _refreshMyOwnedGroupCard() {
    if (Get.isRegistered<AudioHomeViewModel>()) {
      Get.find<AudioHomeViewModel>().loadMyOwnedGroup();
    }
  }

  void applyProfileDefaults(UserModel user) {
    if (title.value.trim().isEmpty) {
      title.value = user.getFullName?.trim() ?? 'Audio Room';
    }
    if (roomAnnouncement.value.trim().isEmpty) {
      roomAnnouncement.value = defaultRoomWelcome;
    }
    if (user.getAvatar != null) {
      liveStreamingModel.setImage = user.getAvatar!;
    }
  }

  static void _prepareHostController(LiveStreamingModel? existing) {
    if (Get.isRegistered<LiveViewModel>()) {
      Get.delete<LiveViewModel>(force: true);
    }
    Get.put(LiveViewModel(ZegoLiveRole.host, existing));
  }

  /// Create My Group: rejoin owned room or create + enter immediately (no preview).
  static Future<void> openOrCreateMyAudioRoom(BuildContext context) async {
    QuickHelp.showLoadingDialog(context, isDismissible: false);
    try {
      final existing = await findMyOwnedAudioRoom();
      if (existing != null) {
        _prepareHostController(existing);
        QuickHelp.hideLoadingDialog(context);
        await Get.toNamed(AppRoutes.streamerAudioLive,
            arguments: {"role": ZegoLiveRole.host});
        _refreshMyOwnedGroupCard();
        return;
      }

      final micStatus = await Permission.microphone.status;
      if (!micStatus.isGranted) {
        final requested = await Permission.microphone.request();
        if (!requested.isGranted) {
          QuickHelp.hideLoadingDialog(context);
          if (context.mounted) {
            QuickHelp.showAppNotificationAdvanced(
              context: context,
              title: 'Microphone required',
              message: 'Allow microphone access to start your audio room.',
              isError: true,
            );
          }
          return;
        }
      }

      _prepareHostController(null);
      final vm = Get.find<LiveViewModel>();
      vm.selectedLiveType.value = LiveStreamingModel.keyTypeAudioLive;
      vm.nineMemberIndex.value = 1;
      vm.applyProfileDefaults(Get.find<UserViewModel>().currentUser);

      final ok = await vm.createAndEnterAudioRoom();
      QuickHelp.hideLoadingDialog(context);
      if (!context.mounted) return;

      if (ok) {
        await Get.toNamed(AppRoutes.streamerAudioLive,
            arguments: {"role": ZegoLiveRole.host});
        _refreshMyOwnedGroupCard();
      } else {
        QuickHelp.showAppNotificationAdvanced(
          context: context,
          title: "live_streaming.live_set_cover_error".tr(),
          message: "try_again_later".tr(),
          isError: true,
          user: Get.find<UserViewModel>().currentUser,
        );
      }
    } catch (e) {
      QuickHelp.hideLoadingDialog(context);
      if (context.mounted) {
        QuickHelp.showAppNotificationAdvanced(
          context: context,
          title: "error".tr(),
          message: e.toString(),
          isError: true,
        );
      }
    }
  }

  Future<bool> createAndEnterAudioRoom() async {
    final UserModel currentUser = Get.find<UserViewModel>().currentUser;
    applyProfileDefaults(currentUser);
    selectedLiveType.value = LiveStreamingModel.keyTypeAudioLive;
    nineMemberIndex.value = 1;

    final existingOwned = await findMyOwnedAudioRoom();
    if (existingOwned != null) {
      liveStreamingModel = existingOwned;
      title.value = existingOwned.getTitle ?? title.value;
      roomAnnouncement.value = existingOwned.getRoomAnnouncement?.trim().isNotEmpty ==
              true
          ? existingOwned.getRoomAnnouncement!
          : defaultRoomWelcome;
      update();
      return true;
    }

    liveStreamingModel.setAuthor = currentUser;
    liveStreamingModel.setAuthorId = currentUser.objectId!;
    liveStreamingModel.setAuthorUid = currentUser.getUid!;
    if (parseFile != null) {
      liveStreamingModel.setImage = parseFile!;
    } else if (currentUser.getAvatar != null) {
      liveStreamingModel.setImage = currentUser.getAvatar!;
    }
    if (currentUser.getGeoPoint != null) {
      liveStreamingModel.setStreamingGeoPoint = currentUser.getGeoPoint!;
    }
    liveStreamingModel.setStreaming = false;
    liveStreamingModel.setStreamingType = LiveStreamingModel.keyTypeAudioLive;
    liveStreamingModel.addViewersCount = 0;
    liveStreamingModel.addDiamonds = 0;
    liveStreamingModel.setTitle = title.value.trim().isEmpty
        ? (currentUser.getFullName ?? 'Audio Room')
        : title.value.trim();
    liveStreamingModel.setTags = tagList;
    liveStreamingModel.setMode = mode.value;
    liveStreamingModel.setStreamerFollowers =
        currentUser.getFollowing?.length ?? 0;
    final announcement = roomAnnouncement.value.trim().isEmpty
        ? defaultRoomWelcome
        : roomAnnouncement.value.trim();
    roomAnnouncement.value = announcement;
    liveStreamingModel.setRoomAnnouncement = announcement;
    liveStreamingModel.setLanguage = selectedLanguage.value;
    if (backgroundImage != null) {
      liveStreamingModel.setBackgroundImage = backgroundImage!;
    }
    liveStreamingModel.setAudioSeats = 8;

    final response = await liveStreamingModel.save();
    if (response.success) {
      if (response.results != null) {
        liveStreamingModel = response.results!.first as LiveStreamingModel;
      }
      update();
      return true;
    }
    return false;
  }

  Future<void> createLive(BuildContext context) async {
    QuickHelp.showLoadingDialog(context, isDismissible: false);
    final ok = await createAndEnterAudioRoom();
    QuickHelp.hideLoadingDialog(context);
    if (!context.mounted) return;
    if (ok) {
      await Get.toNamed(AppRoutes.streamerAudioLive,
          arguments: {"role": ZegoLiveRole.host});
    } else {
      QuickHelp.showAppNotificationAdvanced(
        context: context,
        title: "live_streaming.live_set_cover_error".tr(),
        message: "try_again_later".tr(),
        isError: true,
        user: Get.find<UserViewModel>().currentUser,
      );
    }
  }

  Future updateViewers(
      int uid, updateType, String joinUserName, String roomID) async {
    if (uid != liveStreamingModel.getAuthor!.getUid!) {
      if (updateType == ZegoUpdateType.Add) {
        liveStreamingModel.addViewersCount = 1;
        liveStreamingModel.setViewsCount = 1;
        liveStreamingModel.setViewersId = uid;
      } else {
        liveStreamingModel.removeViewersCount = 1;
        liveStreamingModel.setRemove("viewers_id", uid);
      }

      final updateResponse = await liveStreamingModel.save();

      if (updateResponse.success) {
        update();
      }
    }
  }

  Future<bool> closeAlert(BuildContext context,
      {bool forceEnded = false, bool kickOut = false}) async {
    if (role != ZegoLiveRole.host) {
      if (forceEnded == true || kickOut == true) {
        _handleAudienceForceEnd(kickOut: kickOut);
        Get.toNamed(AppRoutes.endScreen, arguments: kickOut);
      } else {
        popBackToHomePage(forceEnded: forceEnded);
      }
      return false;
    }

    if (isAudioLive) {
      await _showAudioRoomExitDialog(context);
      return false;
    }

    QuickActions.showAlertDialog(
      context,
      'Are you sure you want to end the live?',
      () {
        Get.back();
        Get.toNamed(AppRoutes.endScreen);
        endLive();
      },
      forLive: true,
    );
    return false;
  }

  Future<void> _showAudioRoomExitDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2E),
        title: Text('Leave audio room?',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Leave keeps your room online so others can still join. End room closes it for everyone.',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              leaveAudioRoomKeepAlive();
            },
            child: const Text('Leave'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              endAudioRoomCompletely();
            },
            child: const Text('End room',
                style: TextStyle(color: Color(0xFFFF6B6B))),
          ),
        ],
      ),
    );
  }

  /// Host exits UI but room stays `streaming=true` on Parse.
  Future<void> leaveAudioRoomKeepAlive() async {
    try {
      liveStreamingModel.setStreaming = true;
      await liveStreamingModel.save();
      await GroupHistoryService.recordVisit(liveStreamingModel);
    } catch (_) {}

    await _tearDownAudioRoomSession();
    _refreshMyOwnedGroupCard();
    if (Get.isDialogOpen == true) Get.back();
    Get.back();
  }

  /// Host ends the room for everyone and returns to the app home.
  Future<void> endAudioRoomCompletely() async {
    try {
      cancelLiveTimer();
    } catch (_) {}

    await endLive();

    await _tearDownAudioRoomSession();
    _refreshMyOwnedGroupCard();

    if (Get.isDialogOpen == true) Get.back();
    if (Get.currentRoute == AppRoutes.streamerAudioLive) {
      Get.back();
    }
  }

  Future<void> _tearDownAudioRoomSession() async {
    try {
      cancelLiveTimer();
    } catch (_) {}

    try {
      await unSubscribeLiveStreamingModel();
    } catch (_) {}

    try {
      await Get.find<LiveMessagesViewModel>().unSubscribeLiveMessageModels();
    } catch (_) {}

    try {
      await Get.find<ZegoController>().unSubscribeZegoService();
    } catch (_) {}

    try {
      await AppWakelock.disable();
    } catch (_) {}
  }

  Future<void> endLive() async {
    if (role == ZegoLiveRole.host) {
      liveStreamingModel.setStreaming = false;
      liveStreamingModel.setLiveTime = liveTime.value.toString();
      liveStreamingModel.save();
    }
  }

  Future<void> _handleAudienceForceEnd({required bool kickOut}) async {
    if (_handledForceEnd) return;
    _handledForceEnd = true;

    try {
      cancelLiveTimer();
    } catch (_) {}

    try {
      await unSubscribeLiveStreamingModel();
    } catch (_) {}

    try {
      await Get.find<LiveMessagesViewModel>().unSubscribeLiveMessageModels();
    } catch (_) {}

    try {
      // Stop any Zego streams/rooms for this live type.
      await Get.find<ZegoController>().unSubscribeZegoService();
    } catch (_) {}

    try {
      // Ensure screen can sleep again after forced end.
      await AppWakelock.disable();
    } catch (_) {}
  }

  void popBackToHomePage({bool forceEnded = false}) {
    if (forceEnded == true) {
      Get.back();
      Get.back();
      Get.back();
    } else {
      Get.back();
      Get.back();
      Get.back();
    }
  }

  Future<void> startLive() async {
    if (role == ZegoLiveRole.host) {
      liveStreamingModel.setStreaming = true;
      final resp = await liveStreamingModel.save();
      if (!resp.success) {
        if (Setup.isDebug) {
          print(
              "[startLive] Failed to set streaming=true: ${resp.error?.message}");
        }
      } else {
        if (Setup.isDebug) {
          print(
              "[startLive] streaming=true saved for objectId=${liveStreamingModel.objectId}, AuthorUid=${liveStreamingModel.getAuthorUid}");
        }
        try {
          await GroupHistoryService.recordVisit(liveStreamingModel);
          _refreshMyOwnedGroupCard();
        } catch (_) {}
      }
      update();
    }
  }

  Future<void> addBattleModel(BattleModel battleModel) async {
    liveStreamingModel.setBattleModel = battleModel;
    ParseResponse response = await liveStreamingModel.save();
    if (response.success) {
      update();
    }
  }

  void endPreviousLiveStreaming() async {
    QueryBuilder<LiveStreamingModel> queryBuilder =
        QueryBuilder(LiveStreamingModel());
    queryBuilder.whereEqualTo(LiveStreamingModel.keyAuthorUid,
        Get.find<UserViewModel>().currentUser.getUid);
    queryBuilder.whereEqualTo(LiveStreamingModel.keyStreaming, true);
    // Don't accidentally turn off the current live (can happen if the controller is recreated).
    if (liveStreamingModel.objectId != null) {
      queryBuilder.whereNotEqualTo(
          LiveStreamingModel.keyObjectId, liveStreamingModel.objectId);
    }

    ParseResponse parseResponse = await queryBuilder.query();
    if (parseResponse.success) {
      if (parseResponse.results != null) {
        LiveStreamingModel live =
            parseResponse.results!.first! as LiveStreamingModel;

        live.setStreaming = false;
        await live.save();
      }
    }
  }

  sendGift(
      {required String gift,
      required String audio,
      required int senderUid,
      required int coins,
      required String quantity,
      required String giftName,
      required String giftPath}) {
    final String senderAvatar =
        Get.find<UserViewModel>().currentUser.getAvatar?.url ?? '';
    liveStreamingModel.setGift = {
      LiveStreamingModel.keyGift: gift,
      LiveStreamingModel.keyGiftName: giftName,
      LiveStreamingModel.keyGiftPath: giftPath,
      LiveStreamingModel.keyReceiverUid: senderUid,
      LiveStreamingModel.keyAudio: audio,
      LiveStreamingModel.keySenderName:
          Get.find<UserViewModel>().currentUser.getFullName,
      LiveStreamingModel.keySenderAvatar:
          senderAvatar,
      LiveStreamingModel.keySenderUid:
          Get.find<UserViewModel>().currentUser.getUid,
      LiveStreamingModel.keyCoins: coins,
      LiveStreamingModel.keyQuantity: quantity,
      LiveStreamingModel.keySenderCountry:
          QuickActions.getCountryFlag(Get.find<UserViewModel>().currentUser)
    };
    liveStreamingModel.setGifterCount = 1;
    liveStreamingModel.setTotalCoins = coins;
    liveStreamingModel.addDiamonds = coins;
    liveStreamingModel.save();
    Get.find<RankingViewModel>()
        .addRecord(coins, RankingModel.keyCategoryGifter);
    Get.find<UserViewModel>().deductBalance(coins);
  }

  fetchViewersList() async {
    QueryBuilder<UserModel> query = QueryBuilder(UserModel.forQuery());

    query.whereContainedIn(
        UserModel.keyUid, liveStreamingModel.getViewersId ?? []);
    ParseResponse response = await query.query();
    if (response.success) {
      if (response.results != null && response.results!.isNotEmpty) {
        viewerList = response.results!;
        update();
      } else {
        viewerList = [];
        update();
      }
    }
  }

  updateViewersList(List list) {
    if (viewerList.length != list.length) fetchViewersList();
  }

  //--------------  for fetching details of waiting users----------

  Future<List?> fetchUserdataRequest(List requestList) async {
    List<int> intList = requestList.map((str) => int.parse(str)).toList();

    QueryBuilder<UserModel> query = QueryBuilder(UserModel.forQuery());
    query.whereContainedIn(UserModel.keyUid, intList);
    query.includeObject([UserModel.keyFirstName]);

    try {
      final response = await query.query();
      print("response result${response.results}");

      if (response.success) {
        List? userList = response.results;

        return userList;
      } else {
        print('No data found.');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return null;
  }

  //---------- people who are live

  Future<void> peopleWhoAreLive() async {
    List<UserModel> temp = [];
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
    queryBuilder.orderByDescending(LiveStreamingModel.keyCreatedAt);
    queryBuilder.setLimit(25);
    queryBuilder.includeObject([
      LiveStreamingModel.keyAuthor,
    ]);
    ParseResponse apiResponse = await queryBuilder.query();
    if (apiResponse.success) {
      if (apiResponse.results != null) {
        apiResponse.results!.forEach((value) {
          LiveStreamingModel liveModel = value as LiveStreamingModel;
          if (liveModel.getAuthor != null) temp.add(liveModel.getAuthor!);
        });
        liveUsers = temp;
        update();
      } else {
        liveUsers = [];
        update();
      }
    } else {
      liveUsers = [];
      update();
    }
  }

  // ----------------- friends------------
  Future<void> peopleWhoAreFriends() async {
    List<UserModel> temp = [];
    List result = await Get.find<UserViewModel>().getFollowersUserModel();
    result.forEach((value) {
      UserModel userModel = value as UserModel;
      temp.add(userModel);
    });
    friendsList = temp;
    update();
  }

  // ----------- multi Guest------------

  void isExpandedFeatureActive() {
    if (role == ZegoLiveRole.audience && isMultiGuest) {
      Get.find<GridController>().isExpanded.value =
          liveStreamingModel.getExpandedFeatureActive ?? false;
      Get.find<GridController>().seat =
          liveStreamingModel.getExpandedFeatureIndex;
      update();
    }
  }

  void setExpandedFeature(bool value, int? seat) {
    liveStreamingModel.setExpandedFeatureActive = value;
    if (seat != null) liveStreamingModel.setExpandedFeatureIndex = seat;
    liveStreamingModel.save();
  }

  void setYoutube(bool value, String? id) {
    liveStreamingModel.setYoutube = value;
    if (id != null) liveStreamingModel.setYoutubeVideoId = id;

    liveStreamingModel.save();
    update();
  }

  void setYoutubeControllerValue() {
    if (isMultiGuest && role == ZegoLiveRole.audience) {
      if (liveStreamingModel.getYoutube == true) {
        if (liveStreamingModel.getYoutubeVideoId != null &&
            Get.find<YoutubeController>().videoId !=
                liveStreamingModel.getYoutubeVideoId) {
          Get.find<YoutubeController>().videoId =
              liveStreamingModel.getYoutubeVideoId!;
          Get.find<YoutubeController>()
              .youtubePlayerController
              .load(liveStreamingModel.getYoutubeVideoId!);
        }
        if (Get.find<YoutubeController>()
                .youtubePlayerController
                .value
                .isPlaying !=
            liveStreamingModel.getYoutubeVideoPlaying) {
          if (liveStreamingModel.getYoutubeVideoPlaying == true)
            Get.find<YoutubeController>().youtubePlayerController.play();
          else
            Get.find<YoutubeController>().youtubePlayerController.pause();
        }
      }
    }
  }

  void youtubePlaying(bool value) {
    liveStreamingModel.setYoutubeVideoPlaying = value;
    liveStreamingModel.save();
  }

  void changeMultiGuestSeatView(int seat) {
    liveStreamingModel.setYoutube = false;
    Get.find<GridController>().isExpanded.value = false;
    setExpandedFeature(false, seat);
    if (seat == 3)
      liveStreamingModel.setMultiSeats =
          LiveStreamingModel.keyTypeMultiThreeSeat;
    else if (seat == 4)
      liveStreamingModel.setMultiSeats =
          LiveStreamingModel.keyTypeMultiFourSeat;
    else if (seat == 6)
      liveStreamingModel.setMultiSeats = LiveStreamingModel.keyTypeMultiSixSeat;
    else if (seat == 9)
      liveStreamingModel.setMultiSeats =
          LiveStreamingModel.keyTypeMultiNineSeat;
    else if (seat == 12)
      liveStreamingModel.setMultiSeats =
          LiveStreamingModel.keyTypeMultiTwelveSeat;
    Get.back();
    liveStreamingModel.save();
    update();
  }

  Future<void> addMultiHostUserModel(List<ZegoSDKUser> coHostList) async {
    List<int> userIDs = [];

    // Iterate through coHostList and extract userID from each item
    for (var item in coHostList) {
      userIDs.add(int.parse(item.userID));
    }

    QueryBuilder<UserModel> queryUsers = QueryBuilder(UserModel.forQuery());
    queryUsers.whereContainedIn(UserModel.keyUid, userIDs);

    ParseResponse response = await queryUsers.query();
    if (response.success) {
      if (response.results != null) {
        for (var item in response.results!) {
          multiGuestCoHostList.add(item as UserModel);
        }
        update();
      } else {
        multiGuestCoHostList = [];
        update();
      }
    } else {
      multiGuestCoHostList = [];
      update();
    }
  }

  void changeAudioSeatView(int seat) {
    if (seat == 9)
      liveStreamingModel.setAudioSeats = 8;
    else if (seat == 12) liveStreamingModel.setAudioSeats = 11;
    // Keep preview selection in sync with the persisted value.
    nineMemberIndex.value = seat == 9 ? 0 : 1;
    Get.back();
    liveStreamingModel.save();
    update();
  }

  //----------------------

  // ------------

  joinOtherHostSession(String objectId) {
    unSubscribeLiveStreamingModel().then((value) async {
      endLive().then((value) async {
        tempLiveStreamingModel = liveStreamingModel;
        LiveStreamingModel? otherSessionLiveStreamingModel =
            await getOtherHostLiveObject(objectId);
        // .then((otherSessionLiveStreamingModel){
        tempLiveStreamingModel = liveStreamingModel;
        if (otherSessionLiveStreamingModel!.objectId != null) {
          liveStreamingModel = otherSessionLiveStreamingModel;
          Get.find<LiveMessagesViewModel>().role = ZegoLiveRole.audience;
          role = ZegoLiveRole.audience;
          Get.find<ZegoController>().update();
          update();
          Get.find<ZegoController>().role = ZegoLiveRole.audience;
          subscribeLiveStreamingModel();
          Get.find<LiveMessagesViewModel>()
              .unSubscribeLiveMessageModels()
              .then((value) {
            Get.find<LiveMessagesViewModel>().updateLiveMessages(
                liveStreamingModel: otherSessionLiveStreamingModel);
            Get.find<LiveMessagesViewModel>().setupLiveMessages();
          });
        }
      });
      // });
    });
  }

  Future<LiveStreamingModel?> getOtherHostLiveObject(String objectId) async {
    QueryBuilder<LiveStreamingModel> queryBuilder =
        QueryBuilder<LiveStreamingModel>(LiveStreamingModel());

    queryBuilder.whereEqualTo(LiveStreamingModel.keyObjectId, objectId);
    queryBuilder.includeObject([
      LiveStreamingModel.keyAuthor,
      LiveStreamingModel.keyAuthorInvited,
      LiveStreamingModel.keyPrivateLiveGift,
    ]);
    ParseResponse response = await queryBuilder.query();
    if (response.success) {
      if (response.results != null) {
        LiveStreamingModel live =
            response.results!.first! as LiveStreamingModel;
        return live;
      }
    }
  }

  backToLiveSession() {
    unSubscribeLiveStreamingModel().then((value) async {
      liveStreamingModel = tempLiveStreamingModel;
      role = ZegoLiveRole.host;
      startLive().then((value) {
        update();
        Get.find<ZegoController>().role = ZegoLiveRole.host;
        Get.find<LiveMessagesViewModel>().role = ZegoLiveRole.host;
        Get.find<ZegoController>().update();
        update();
        subscribeLiveStreamingModel();
        Get.find<LiveMessagesViewModel>()
            .unSubscribeLiveMessageModels()
            .then((value) {
          Get.find<LiveMessagesViewModel>()
              .updateLiveMessages(liveStreamingModel: liveStreamingModel);
          Get.find<LiveMessagesViewModel>().setupLiveMessages();
        });
      });
    });
  }

  //---------------- join other streamer Live Session

  joinOtherStreamerLiveSession(
      LiveStreamingModel? otherSessionLiveStreamingModel) {
    if (otherSessionLiveStreamingModel != null) {
      liveStreamingModel = otherSessionLiveStreamingModel;
      update();
      subscribeLiveStreamingModel();
      Get.find<LiveMessagesViewModel>().updateLiveMessages(
          liveStreamingModel: otherSessionLiveStreamingModel);
      Get.find<LiveMessagesViewModel>().setupLiveMessages();
      if (!isAudioLive)
        Get.find<ZegoController>()
            .exitCurrentJoinOtherSession(otherSessionLiveStreamingModel);
      else
        Get.find<ZegoController>()
            .exitAudioCurrentJoinOtherSession(otherSessionLiveStreamingModel);
    }
  }

  endLiveStreamingAndJoinOtherSession(BuildContext context,
      LiveStreamingModel? otherSessionLiveStreamingModel) {
    if (role == ZegoLiveRole.host) {
      QuickHelp.showDialogLivEend(
        context: context,
        title: 'live_streaming.live_'.tr(),
        confirmButtonText: 'live_streaming.finish_live'.tr(),
        message: 'End Stream to Join New Session?',
        onPressed: () {
          Get.back();
          endLive().then((value) {
            role = ZegoLiveRole.audience;
            update();
            Get.find<ZegoController>().role = ZegoLiveRole.audience;
            Get.find<LiveMessagesViewModel>().role = ZegoLiveRole.audience;
            Get.find<ZegoController>().update();
            joinOtherStreamerLiveSession(otherSessionLiveStreamingModel);
          });
        },
      );
    }
  }

  void incrementNewFansCount() {
    liveStreamingModel.setFansCount = 1;
    liveStreamingModel.save();
  }

  void incrementCount(int coins) {
    liveStreamingModel.setGifterCount = 1;
    liveStreamingModel.setTotalCoins = coins;
    liveStreamingModel.save();
  }

  void subscriberCount() {
    liveStreamingModel.setSubscriberGain = 1;
    liveStreamingModel.save();
  }

  void addComment() {
    liveStreamingModel.setComments = 1;
    liveStreamingModel.save();
  }

  runLiveTimer() {
    liveTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      liveTime.value = liveTime.value + 1;
    });
  }

  cancelLiveTimer() {
    if (liveTimer.isActive) liveTimer.cancel();
  }

  disableRecordFeature(bool disable) {
    liveStreamingModel.setDisableRecord = disable;
    liveStreamingModel.save();
  }

  disableScreenShotFeature(bool disable) {
    liveStreamingModel.setDisableScreenShot = disable;
    liveStreamingModel.save();
  }

  disableGiftAnimation(bool disable) {
    giftAnimation.value = true;
    update();
  }

  String filterMessage(String message) {
    List<String> words = message.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (liveStreamingModel.getFilteredList!.contains(words[i])) {
        words[i] = "******";
      }
    }
    return words.join(' ');
  }

  blockUserList(LiveStreamingModel value) async {
    if (value.getBlockedList!.length != blockList.length) {
      QueryBuilder<UserModel> query = QueryBuilder(UserModel.forQuery());
      query.whereContainedIn(UserModel.keyUid, value.getBlockedList!);
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
  }

  addBlockUser(int uid) {
    liveStreamingModel.setBlockedList = uid;
    liveStreamingModel.save();
    Get.find<UserViewModel>().addToBlockList(uid);
  }

  removeBlockUser(int uid) {
    liveStreamingModel.removeBlockedUser = uid;
    liveStreamingModel.save();
    Get.find<UserViewModel>().removeFromBlockList(uid);
  }

  getAdminList(LiveStreamingModel value) async {
    if (value.getAdminList!.length != adminList.length) {
      QueryBuilder<UserModel> query = QueryBuilder(UserModel.forQuery());
      query.whereContainedIn(UserModel.keyUid, value.getAdminList!);
      ParseResponse response = await query.query();
      if (response.success) {
        if (response.results != null && response.results!.isNotEmpty) {
          adminList = response.results!;
          status = Status.Completed;
          update();
        } else {
          adminList = [];
          status = Status.Completed;
          update();
        }
      } else {
        adminList = [];
        status = Status.Completed;
        update();
      }
    }
  }

  bool isCurrentUserInAdminList() {
    return adminList.any((element) {
      UserModel user = element as UserModel;
      return user.getUid == Get.find<UserViewModel>().currentUser.getUid;
    });
  }

  addAdmin(int uid) {
    liveStreamingModel.setAdminList = uid;
    liveStreamingModel.save();
  }

  removeAdmin(int uid) {
    liveStreamingModel.removeAdminUser = uid;
    liveStreamingModel.save();
  }

  getDisableChatUsers(LiveStreamingModel value) async {
    if (value.getDisableChatList!.length != disableList.length) {
      QueryBuilder<UserModel> query = QueryBuilder(UserModel.forQuery());
      query.whereContainedIn(UserModel.keyUid, value.getDisableChatList!);
      ParseResponse response = await query.query();
      if (response.success) {
        if (response.results != null && response.results!.isNotEmpty) {
          disableList = response.results!;
          status = Status.Completed;
          update();
        } else {
          disableList = [];
          status = Status.Completed;
          update();
        }
      } else {
        status = Status.Completed;
        update();
      }
    }
  }

  addDisableChatUser(int uid) {
    liveStreamingModel.setDisableChatList = uid;
    liveStreamingModel.save();
  }

  removeDisableChatUser(int uid) {
    liveStreamingModel.removeDisableChatUser = uid;
    liveStreamingModel.save();
  }

  addKickOutUser(int uid) {
    liveStreamingModel.setKickOutList = uid;
    liveStreamingModel.setLiveTime = liveTime.value.toString();
    liveStreamingModel.save();
  }

  checkKickOutUserList(LiveStreamingModel value) async {
    if (role == ZegoLiveRole.audience) if (value.getKickOutList!
        .contains(Get.find<UserViewModel>().currentUser.getUid)) {
      closeAlert(Get.context!, forceEnded: true, kickOut: true);
    }
  }

  bool isUserInChatDisableList() {
    if (role == ZegoLiveRole.audience) if (liveStreamingModel
        .getDisableChatList!
        .contains(Get.find<UserViewModel>().currentUser.getUid)) {
      return true;
    } else {
      return false;
    }
    else
      return false;
  }

  changeBackgroundImage(LiveStreamingModel value) {
    if (value.getBackgroundImage != null)
      backgroundImage = value.getBackgroundImage!;
    else if (value.getBackgroundImage == null && role == ZegoLiveRole.audience)
      backgroundImage = null;
    update();
  }

  addGifterList(Map value) {
    if (value[LiveStreamingModel.keyReceiverUid] ==
        liveStreamingModel.getAuthorUid) {
      if (hostGiftersAvatar
              .contains(value[LiveStreamingModel.keySenderAvatar]) ==
          false)
        hostGiftersAvatar.insert(0, value[LiveStreamingModel.keySenderAvatar]);
      addValueToHostGifters(value);
      update();
      saveGifterList(value, value[LiveStreamingModel.keySenderAvatar]);
    }
  }

  void addValueToHostGifters(Map value) {
    bool found = false;

    for (var gifter in hostGifters) {
      if (gifter[LiveStreamingModel.keySenderUid] ==
          value[LiveStreamingModel.keySenderUid]) {
        gifter[LiveStreamingModel.keyCoins] +=
            value[LiveStreamingModel.keyCoins];
        found = true;
        break;
      }
    }

    if (!found) {
      hostGifters.add(value);
    }
  }

  saveGifterList(Map gifter, String avatar) {
    liveStreamingModel.setGifterAvatarList = avatar;
    liveStreamingModel.setGifterList = gifter;
    liveStreamingModel.save();
  }

  setGifterList() {
    if (liveStreamingModel.getGifterAvatarList!.isNotEmpty) {
      liveStreamingModel.getGifterAvatarList!.forEach((element) {
        String value = element;
        if (hostGiftersAvatar.contains(value) == false)
          hostGiftersAvatar.insert(0, value);
      });
    }
    if (liveStreamingModel.getGifterList!.isNotEmpty) {
      liveStreamingModel.getGifterList!.forEach((element) {
        Map value = element;
        addValueToHostGifters(value);
      });
    }
  }

  addGiftCoins(Map value) {
    if (value[LiveStreamingModel.keyReceiverUid] ==
        Get.find<UserViewModel>().currentUser.getUid) {
      Get.find<UserViewModel>()
          .addBalance(value[LiveStreamingModel.keyCoins])
          .then((value) => update());
    }
  }

  showGiftReceiverBanner(Map value) {
    if (Get.find<UserViewModel>().currentUser.getUid ==
        value[LiveStreamingModel.keyReceiverUid]) {
      senderDetail = {
        LiveStreamingModel.keySenderName:
            value[LiveStreamingModel.keySenderName],
        LiveStreamingModel.keySenderAvatar:
            value[LiveStreamingModel.keySenderAvatar],
        LiveStreamingModel.keyGiftPath: value[LiveStreamingModel.keyGiftPath],
        LiveStreamingModel.keyGiftName: value[LiveStreamingModel.keyGiftName],
        LiveStreamingModel.keyQuantity: value[LiveStreamingModel.keyQuantity],
      };
      showGiftBanner.value = true;
      Future.delayed(Duration(seconds: 10), () {
        showGiftBanner.value = false;
      });
    }
  }

  LiveViewModel(this.role, this.liveModel);

  @override
  void onInit() {
    role = this.role;
    if (role == ZegoLiveRole.audience) {
      liveStreamingModel = this.liveModel!;
      giftListLength = liveStreamingModel.getGiftsList!.length;
      if (liveStreamingModel.getMyWishList != null)
        myWishList = liveStreamingModel.getMyWishList!;
      setGifterList();
      updateLiveStreamingModel();
    }
    if (role == ZegoLiveRole.host) {
      if (liveModel != null) {
        liveStreamingModel = liveModel!;
        title.value = liveStreamingModel.getTitle ?? '';
        final seats = liveStreamingModel.getAudioSeats ?? 11;
        nineMemberIndex.value = seats == 8 ? 0 : 1;
      }
      runLiveTimer();
      endPreviousLiveStreaming();
    }
    AppWakelock.enable();

    super.onInit();
  }

  @override
  void onClose() {
    // Do not automatically end live on controller disposal.
    // This controller can be recreated during camera/device interruptions; ending the live here
    // flips Parse `streaming` to false and breaks admin-side viewing while the host is still live.
    if (role == ZegoLiveRole.host) cancelLiveTimer();
    AppWakelock.disable();

    super.onClose();
  }
}
