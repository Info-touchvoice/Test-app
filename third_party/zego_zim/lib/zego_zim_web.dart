import 'dart:async';
import 'dart:convert';
import 'dart:html';
// In order to *not* need this ignore, consider extracting the 'web' version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util' as js;
import 'dart:js_util';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:zego_zim/src/internal/web/zim_defines_web.dart';
import 'package:zego_zim/src/internal/web/zim_event_handler_web.dart';
import 'package:zego_zim/src/internal/zim_common_data.dart';
import 'package:zego_zim/src/zim_defines.dart';

/// A web implementation of the ZimFlutterSdkPlatform of the ZimFlutterSdk plugin.
class ZegoZimPlugin {
  /// Constructs a ZegoZimPluginWeb
  ZegoZimPlugin();

  static Map<String, ZIM> handleMap = {};
  static final StreamController _evenController = StreamController.broadcast();

  static void registerWith(Registrar registrar) {
    //ZimFlutterSdkPlatform.instance = ZimFlutterSdkWeb();
    final MethodChannel channel = MethodChannel(
      'zego_zim_plugin',
      const StandardMethodCodec(),
      registrar,
    );

    final eventChannel = PluginEventChannel(
        'zim_event_handler', const StandardMethodCodec(), registrar);

    final pluginInstance = ZegoZimPlugin();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
    eventChannel.setController(ZegoZimPlugin._evenController);

    _evenController.stream.listen((event) {
      ZIMEventHandlerWeb.eventListener(event);
    });
  }

  static Map _jsObjectToMap(dynamic obj) {
    return jsonDecode(ZIM.toJSON(obj));
  }

  static Object _mapToJSObject(Map<dynamic, dynamic>? a) {
    var object = js.newObject();

    if (a == null) {
      return object;
    }

    a.forEach((k, v) {
      var key = k.toString();
      var value = _dartValueToJs(v);

      js.setProperty(object, key, value);
    });
    return object;
  }

  static dynamic _dartValueToJs(dynamic value) {
    if (value is Map) {
      return _mapToJSObject(value);
    } else if (value is List) {
      return value.map(_dartValueToJs).toList();
    } else {
      return value;
    }
  }

  static _handleError(e) {
    Map e1 = _jsObjectToMap(e);
    throw PlatformException(
        code: e1['code'].toString(), message: e1['message']);
  }

  static String _getHandle(ZIM zim) {
    var handle = '';
    handleMap.forEach((key, val) {
      if (val == zim) {
        handle = key;
      }
    });

    return handle;
  }

  static void writeLog(String logString) {
    window.console.info(logString);
  }

  static String getVersion() {
    return ZIM.getVersion();
  }

  static ZIM? getInstance() {
    return ZIM.getInstance();
  }

  static void setLogConfig(dynamic config) {
    var level = config['logLevel'] ?? 0;
    var log = 'info'; // level: 1
    if (level == 0) {
      log = 'debug';
    } else if (level == 2) {
      log = 'warn';
    } else if (level == 3) {
      log = 'error';
    } else if (level == 99) {
      log = 'report';
    } else if (level == 100) {
      log = 'disable';
    }

    ZIM.getInstance()?.setLogConfig(_mapToJSObject({'logLevel': log}));
  }

  static void setCacheConfig(dynamic config) {
    return;
  }

  static void setAdvancedConfig(String key, String value) {
    ZIM.setAdvancedConfig(key, value);
  }

  static bool setGeofencingConfig(dynamic areaList, dynamic type) {
    return ZIM.setGeofencingConfig(areaList, type);
  }

  static ZIM? create(String handle, dynamic appConfig) {
    ZIM.setEventHandler(allowInterop((dynamic zim, event, String data) {
      String handle = _getHandle(zim);
      _evenController.add({'handle': handle, 'ev': event, 'data': data});
    }));

    ZIM? zim = ZIM.create(_mapToJSObject(appConfig));

    if (zim != null) {
      handleMap[handle] = zim;
    } else if (handleMap.isNotEmpty) {
      handleMap[handle] = handleMap.values.first;
    }

    ZIM.setAdvancedConfig('zim_cross_platform', 'flutter');

    return zim;
  }

  void destroy() {
    ZIM.getInstance()?.destroy();
  }

  void logout() {
    ZIM.getInstance()?.logout();
  }

  Future<void> uploadLog() async {
    await promiseToFuture(ZIM.getInstance()!.uploadLog())
        .catchError(_handleError);

    return Future.value();
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'writeLog':
        return writeLog(call.arguments['logString']);
      case 'uploadLog':
        return uploadLog();
      case 'getVersion':
        return getVersion();
      case 'setLogConfig':
        return setLogConfig(call.arguments['config']);
      case 'setCacheConfig':
        return setCacheConfig(call.arguments['config']);
      case 'setAdvancedConfig':
        return setAdvancedConfig(
            call.arguments['key'], call.arguments['value']);
      case 'setGeofencingConfig':
        return setGeofencingConfig(
            call.arguments['areaList'], call.arguments['type']);

      /// MARK: - Main
      case 'destroy':
        return destroy();
      case 'logout':
        return logout();
      case 'create':
        return create(call.arguments['handle'], call.arguments['config']);
      case 'login':
        return login(call.arguments['userID'], call.arguments['config']);
      case 'callExperimentalAPI':
        return callExperimentalAPI(call.arguments['params']);
      case 'updateUserBadge':
        return updateUserBadge(call.arguments['badge']);
      case 'renewToken':
        return renewToken(call.arguments['token']);
      case 'updateUserName':
        return updateUserName(call.arguments['userName']);
      case 'updateUserAvatarUrl':
        return updateUserAvatarUrl(call.arguments['userAvatarUrl']);
      case 'updateUserExtendedData':
        return updateUserExtendedData(call.arguments['extendedData']);
      case 'updateUserCustomStatus':
        return updateUserCustomStatus(
            customStatus: call.arguments['customStatus'],
            config: call.arguments['config']);
      case 'updateUserOfflinePushRule':
        return updateUserOfflinePushRule(call.arguments['offlinePushRule']);
      case 'querySelfUserInfo':
        return querySelfUserInfo();
      case 'queryUsersInfo':
        return queryUsersInfo(
            call.arguments['userIDs'], call.arguments['config']);
      case 'queryUsersStatus':
        return queryUsersStatus(call.arguments['userIDs']);
      case 'subscribeUsersStatus':
        return subscribeUsersStatus(
            call.arguments['userIDs'], call.arguments['config']);
      case 'unsubscribeUsersStatus':
        return unsubscribeUsersStatus(call.arguments['userIDs']);
      case 'querySubscribedUserStatusList':
        return querySubscribedUserStatusList(call.arguments['config']);

      /// MARK: - Conversation
      case 'queryConversation':
        return queryConversation(call.arguments['conversationID'],
            call.arguments['conversationType']);
      case 'queryConversationList':
        return queryConversationList(
            call.arguments['config'], call.arguments['option']);
      case 'queryConversationPinnedList':
        return queryConversationPinnedList(call.arguments['config']);
      case 'queryConversationTotalUnreadMessageCount':
        return queryConversationTotalUnreadMessageCount(
            call.arguments['config']);
      case 'deleteConversation':
        return deleteConversation(call.arguments['conversationID'],
            call.arguments['conversationType'], call.arguments['config']);
      case 'deleteAllConversations':
        return deleteAllConversations(call.arguments['config']);
      case 'deleteAllConversationMessages':
        return deleteAllConversationMessages(call.arguments['config']);
      case 'clearConversationUnreadMessageCount':
        return clearConversationUnreadMessageCount(
            call.arguments['conversationID'],
            call.arguments['conversationType']);
      case 'clearConversationTotalUnreadMessageCount':
        return clearConversationTotalUnreadMessageCount();
      case 'updateConversationPinnedState':
        return updateConversationPinnedState(
            call.arguments['isPinned'],
            call.arguments['conversationID'],
            call.arguments['conversationType']);
      case 'setConversationDraft':
        return setConversationDraft(
            call.arguments['draft'],
            call.arguments['conversationID'],
            call.arguments['conversationType']);
      case 'setConversationMark':
        return setConversationMark(call.arguments['markType'],
            call.arguments['enable'], call.arguments['infos']);
      case 'setConversationNotificationStatus':
        return setConversationNotificationStatus(
            call.arguments['status'],
            call.arguments['conversationID'],
            call.arguments['conversationType']);

      /// MARK: - Message
      case 'sendMessage':
        return sendMessage(
            call.arguments['message'],
            call.arguments['toConversationID'],
            call.arguments['conversationType'],
            call.arguments['config'],
            call.arguments['messageAttachedCallbackID'],
            call.arguments['mediaUploadingCallbackID'],
            call.arguments['multipleMediaUploadingCallbackID'],
            call.arguments['messageID']);
      case 'editMessage':
        return editMessage(
            call.arguments['message'],
            call.arguments['config'],
            call.arguments['messageAttachedCallbackID'],
            call.arguments['multipleMediaUploadingCallbackID']);
      case 'replyMessage':
        return replyMessage(
            call.arguments['message'],
            call.arguments['toOriginalMessage'],
            call.arguments['config'],
            call.arguments['messageID'],
            call.arguments['messageAttachedCallbackID'],
            call.arguments['mediaUploadingCallbackID'],
            call.arguments['multipleMediaUploadingCallbackID']);
      case 'insertMessageToLocalDB':
        return insertMessageToLocalDB(
            call.arguments['message'],
            call.arguments['messageID'],
            call.arguments['conversationID'],
            call.arguments['conversationType'],
            call.arguments['senderUserID']);
      case 'cancelSendingMessage':
        return cancelSendingMessage(
            call.arguments['message'], call.arguments['config']);
      case 'deleteMessages':
        return deleteMessages(
            call.arguments['messageList'],
            call.arguments['conversationID'],
            call.arguments['conversationType'],
            call.arguments['config']);
      case 'deleteAllMessage':
        return deleteAllMessage(call.arguments['conversationID'],
            call.arguments['conversationType'], call.arguments['config']);
      case 'downloadMediaFile':
        return downloadMediaFile(call.arguments['message'],
            call.arguments['fileType'], call.arguments['progressID']);
      case 'queryHistoryMessage':
        return queryHistoryMessage(call.arguments['conversationID'],
            call.arguments['conversationType'], call.arguments['config']);
      case 'queryMessages':
        return queryMessages(
            call.arguments['messageSeqs'],
            call.arguments['conversationID'],
            call.arguments['conversationType']);
      case 'queryMessageRepliedList':
        return queryMessageRepliedList(
            call.arguments['message'], call.arguments['config']);
      case 'queryCombineMessageDetail':
        return queryCombineMessageDetail(call.arguments['message']);
      case 'updateMessageLocalExtendedData':
        return updateMessageLocalExtendedData(
            call.arguments['localExtendedData'], call.arguments['message']);
      case 'revokeMessage':
        return revokeMessage(
            call.arguments['message'], call.arguments['config']);
      case 'sendConversationMessageReceiptRead':
        return sendConversationMessageReceiptRead(
            call.arguments['conversationID'],
            call.arguments['conversationType']);
      case 'sendMessageReceiptsRead':
        return sendMessageReceiptsRead(
            call.arguments['messageList'],
            call.arguments['conversationID'],
            call.arguments['conversationType']);
      case 'queryMessageReceiptsInfo':
        return queryMessageReceiptsInfo(
            call.arguments['messageList'],
            call.arguments['conversationID'],
            call.arguments['conversationType']);
      case 'queryGroupMessageReceiptReadMemberList':
        return queryGroupMessageReceiptReadMemberList(call.arguments['message'],
            call.arguments['groupID'], call.arguments['config']);
      case 'queryGroupMessageReceiptUnreadMemberList':
        return queryGroupMessageReceiptUnreadMemberList(
            call.arguments['message'],
            call.arguments['groupID'],
            call.arguments['config']);
      case 'addMessageReaction':
        return addMessageReaction(call.arguments['reactionType'],
            call.arguments['message'], call.arguments['config']);
      case 'deleteMessageReaction':
        return deleteMessageReaction(
            call.arguments['reactionType'], call.arguments['message']);
      case 'deleteMessageAllReactions':
        return deleteMessageAllReactions(call.arguments['message']);
      case 'queryMessageReactionUserList':
        return queryMessageReactionUserList(
            call.arguments['message'], call.arguments['config']);
      case 'pinMessage':
        return pinMessage(call.arguments['message'], call.arguments['isPinned'],
            call.arguments['config']);
      case 'queryPinnedMessageList':
        return queryPinnedMessageList(call.arguments['conversationID'],
            call.arguments['conversationType']);

      /// MARK: - Room
      case 'createRoom':
      case 'createRoomWithConfig':
        return createRoom(call.arguments['roomInfo'], call.arguments['config']);
      case 'enterRoom':
        return enterRoom(call.arguments['roomInfo'], call.arguments['config']);
      case 'joinRoom':
        return joinRoom(call.arguments['roomID']);
      case 'switchRoom':
        return switchRoom(
            call.arguments['fromRoomID'],
            call.arguments['toRoomInfo'],
            call.arguments['isCreateWhenRoomNotExisted'],
            call.arguments['config']);
      case 'leaveRoom':
        return leaveRoom(call.arguments['roomID']);
      case 'leaveAllRoom':
        return leaveAllRoom();
      case 'queryRoomMembers':
        return queryRoomMembers(
            call.arguments['userIDs'], call.arguments['roomID']);
      case 'queryRoomMemberList':
        return queryRoomMemberList(
            call.arguments['roomID'], call.arguments['config']);
      case 'queryRoomOnlineMemberCount':
        return queryRoomOnlineMemberCount(call.arguments['roomID']);
      case 'queryRoomAllAttributes':
        return queryRoomAllAttributes(call.arguments['roomID']);
      case 'setRoomAttributes':
        return setRoomAttributes(call.arguments['roomAttributes'],
            call.arguments['roomID'], call.arguments['config']);
      case 'deleteRoomAttributes':
        return deleteRoomAttributes(call.arguments['keys'],
            call.arguments['roomID'], call.arguments['config']);
      case 'beginRoomAttributesBatchOperation':
        return beginRoomAttributesBatchOperation(
            call.arguments['roomID'], call.arguments['config']);
      case 'endRoomAttributesBatchOperation':
        return endRoomAttributesBatchOperation(call.arguments['roomID']);
      case 'setRoomMembersAttributes':
        return setRoomMembersAttributes(
            call.arguments['attributes'],
            call.arguments['roomID'],
            call.arguments['userIDs'],
            call.arguments['config']);
      case 'queryRoomMembersAttributes':
        return queryRoomMembersAttributes(
            call.arguments['userIDs'], call.arguments['roomID']);
      case 'queryRoomMemberAttributesList':
        return queryRoomMemberAttributesList(
            call.arguments['roomID'], call.arguments['config']);

      /// MARK: - Group
      case 'createGroup':
        return createGroup(call.arguments['groupInfo'],
            call.arguments['userIDs'], call.arguments['config']);
      case 'joinGroup':
        return joinGroup(call.arguments['groupID']);
      case 'leaveGroup':
        return leaveGroup(call.arguments['groupID']);
      case 'dismissGroup':
        return dismissGroup(call.arguments['groupID']);
      case 'queryGroupList':
        return queryGroupList(
            count: call.arguments['count'], config: call.arguments['config']);
      case 'updateGroupName':
        return updateGroupName(
            call.arguments['groupName'], call.arguments['groupID']);
      case 'updateGroupAvatarUrl':
        return updateGroupAvatarUrl(
            call.arguments['groupAvatarUrl'], call.arguments['groupID']);
      case 'updateGroupNotice':
        return updateGroupNotice(
            call.arguments['groupNotice'], call.arguments['groupID']);
      case 'updateGroupAlias':
        return updateGroupAlias(
            call.arguments['groupAlias'], call.arguments['groupID']);
      case 'queryGroupInfo':
        return queryGroupInfo(call.arguments['groupID']);
      case 'setGroupAttributes':
        return setGroupAttributes(
            call.arguments['groupAttributes'], call.arguments['groupID']);
      case 'deleteGroupAttributes':
        return deleteGroupAttributes(
            call.arguments['keys'], call.arguments['groupID']);
      case 'queryGroupAttributes':
        return queryGroupAttributes(
            call.arguments['keys'], call.arguments['groupID']);
      case 'queryGroupAllAttributes':
        return queryGroupAllAttributes(call.arguments['groupID']);
      case 'inviteUsersIntoGroup':
        return inviteUsersIntoGroup(
            call.arguments['userIDs'], call.arguments['groupID']);
      case 'kickGroupMembers':
        return kickGroupMembers(
            call.arguments['userIDs'], call.arguments['groupID']);
      case 'transferGroupOwner':
        return transferGroupOwner(
            call.arguments['toUserID'], call.arguments['groupID']);
      case 'setGroupMemberRole':
        return setGroupMemberRole(call.arguments['role'],
            call.arguments['forUserID'], call.arguments['groupID']);
      case 'setGroupMemberNickname':
        return setGroupMemberNickname(call.arguments['nickname'],
            call.arguments['forUserID'], call.arguments['groupID']);
      case 'queryGroupMemberInfo':
        return queryGroupMemberInfo(
            call.arguments['userID'], call.arguments['groupID']);
      case 'queryGroupMemberList':
        return queryGroupMemberList(
            call.arguments['groupID'], call.arguments['config']);
      case 'queryGroupMemberCount':
        return queryGroupMemberCount(call.arguments['groupID']);
      case 'muteGroup':
        return muteGroup(call.arguments['isMute'], call.arguments['groupID'],
            call.arguments['config']);
      case 'muteGroupMembers':
        return muteGroupMembers(
            call.arguments['isMute'],
            call.arguments['userIDs'],
            call.arguments['groupID'],
            call.arguments['config']);
      case 'queryGroupMemberMutedList':
        return queryGroupMemberMutedList(
            call.arguments['groupID'], call.arguments['config']);
      case 'updateGroupJoinMode':
        return updateGroupJoinMode(
            call.arguments['mode'], call.arguments['groupID']);
      case 'updateGroupInviteMode':
        return updateGroupInviteMode(
            call.arguments['mode'], call.arguments['groupID']);
      case 'updateGroupBeInviteMode':
        return updateGroupBeInviteMode(
            call.arguments['mode'], call.arguments['groupID']);
      case 'sendGroupJoinApplication':
        return sendGroupJoinApplication(
            call.arguments['groupID'], call.arguments['config']);
      case 'acceptGroupJoinApplication':
        return acceptGroupJoinApplication(call.arguments['userID'],
            call.arguments['groupID'], call.arguments['config']);
      case 'rejectGroupJoinApplication':
        return rejectGroupJoinApplication(call.arguments['userID'],
            call.arguments['groupID'], call.arguments['config']);
      case 'sendGroupInviteApplications':
        return sendGroupInviteApplications(call.arguments['userIDs'],
            call.arguments['groupID'], call.arguments['config']);
      case 'acceptGroupInviteApplication':
        return acceptGroupInviteApplication(call.arguments['inviterUserID'],
            call.arguments['groupID'], call.arguments['config']);
      case 'rejectGroupInviteApplication':
        return rejectGroupInviteApplication(call.arguments['inviterUserID'],
            call.arguments['groupID'], call.arguments['config']);
      case 'queryGroupApplicationList':
        return queryGroupApplicationList(call.arguments['config']);

      /// MARK: - Call
      case 'callInvite':
        return callInvite(call.arguments['invitees'], call.arguments['config']);
      case 'callCancel':
        return callCancel(call.arguments['invitees'], call.arguments['callID'],
            call.arguments['config']);
      case 'callAccept':
        return callAccept(call.arguments['callID'], call.arguments['config']);
      case 'callReject':
        return callReject(call.arguments['callID'], call.arguments['config']);
      case 'callQuit':
        return callQuit(call.arguments['callID'], call.arguments['config']);
      case 'callEnd':
        return callEnd(call.arguments['callID'], call.arguments['config']);
      case 'callJoin':
        return callJoin(call.arguments['callID'], call.arguments['config']);
      case 'callingInvite':
        return callingInvite(call.arguments['invitees'],
            call.arguments['callID'], call.arguments['config']);
      case 'queryCallInvitationList':
        return queryCallInvitationList(call.arguments['config']);

      /// MARK: - Friend
      case 'addFriend':
        return addFriend(call.arguments['userID'], call.arguments['config']);
      case 'deleteFriends':
        return deleteFriends(
            call.arguments['userIDs'], call.arguments['config']);
      case 'checkFriendsRelation':
        return checkFriendsRelation(
            call.arguments['userIDs'], call.arguments['config']);
      case 'updateFriendAlias':
        return updateFriendAlias(
            call.arguments['friendAlias'], call.arguments['userID']);
      case 'updateFriendAttributes':
        return updateFriendAttributes(
            call.arguments['friendAttributes'], call.arguments['userID']);
      case 'sendFriendApplication':
        return sendFriendApplication(
            call.arguments['userID'], call.arguments['config']);
      case 'acceptFriendApplication':
        return acceptFriendApplication(
            call.arguments['userID'], call.arguments['config']);
      case 'rejectFriendApplication':
        return rejectFriendApplication(
            call.arguments['userID'], call.arguments['config']);
      case 'queryFriendsInfo':
        return queryFriendsInfo(call.arguments['userIDs']);
      case 'queryFriendList':
        return queryFriendList(call.arguments['config']);
      case 'queryFriendApplicationList':
        return queryFriendApplicationList(call.arguments['config']);

      /// MARK: - Blacklist
      case 'addUsersToBlacklist':
        return addUsersToBlacklist(call.arguments['userIDs']);
      case 'removeUsersFromBlacklist':
        return removeUsersFromBlacklist(call.arguments['userIDs']);
      case 'checkUserIsInBlacklist':
        return checkUserIsInBlacklist(call.arguments['userID']);
      case 'queryBlacklist':
        return queryBlacklist(call.arguments['config']);

      /// MARK: - DB Search
      case 'searchLocalConversations':
        return searchLocalConversations(call.arguments['config']);
      case 'searchGlobalLocalMessages':
        return searchGlobalLocalMessages(call.arguments['config']);
      case 'searchLocalMessages':
        return searchLocalMessages(call.arguments['conversationID'],
            call.arguments['conversationType'], call.arguments['config']);
      case 'searchLocalGroups':
        return searchLocalGroups(call.arguments['config']);
      case 'searchLocalGroupMembers':
        return searchLocalGroupMembers(
            call.arguments['groupID'], call.arguments['config']);
      case 'searchLocalFriends':
        return searchLocalFriends(call.arguments['config']);

      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'zim for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// MARK: - Main

  Future<void> login(String userID, dynamic config) async {
    await promiseToFuture(
            ZIM.getInstance()!.login(userID, _mapToJSObject(config)))
        .catchError(_handleError);

    return Future.value();
  }

  Future<void> updateUserBadge(int badge) async {
    await promiseToFuture(ZIM.getInstance()!.updateUserBadge(badge))
        .catchError(_handleError);

    return Future.value();
  }

  Future<String> callExperimentalAPI(String params) async {
    var result =
        await promiseToFuture(ZIM.getInstance()!.callExperimentalAPI(params))
            .catchError(_handleError);

    return result;
  }

  Future<Map<dynamic, dynamic>> renewToken(String token) async {
    var result = await promiseToFuture(ZIM.getInstance()!.renewToken(token))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateUserName(String userName) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.updateUserName(userName))
            .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateUserAvatarUrl(
      String userAvatarUrl) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateUserAvatarUrl(userAvatarUrl))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateUserExtendedData(
      String extendedData) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateUserExtendedData(extendedData))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateUserCustomStatus(
      {String? customStatus, dynamic? config}) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .updateUserCustomStatus(customStatus ?? '',
                config == null ? null : _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateUserOfflinePushRule(
      dynamic offlinePushRule) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .updateUserOfflinePushRule(_mapToJSObject(offlinePushRule)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> querySelfUserInfo() async {
    final result = await promiseToFuture(ZIM.getInstance()!.querySelfUserInfo())
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryUsersInfo(
      dynamic userIDs, dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryUsersInfo(userIDs, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryUsersStatus(dynamic userIDs) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.queryUsersStatus(userIDs))
            .catchError(_handleError);
    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> subscribeUsersStatus(
      dynamic userIDs, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .subscribeUsersStatus(userIDs, _mapToJSObject(config)))
        .catchError(_handleError);
    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> unsubscribeUsersStatus(dynamic userIDs) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.unsubscribeUsersStatus(userIDs))
        .catchError(_handleError);
    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> querySubscribedUserStatusList(
      dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .querySubscribedUserStatusList(_mapToJSObject(config)))
        .catchError(_handleError);
    return _jsObjectToMap(result);
  }

  /// MARK: - Conversation

  Future<Map<dynamic, dynamic>> queryConversation(
      String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryConversation(conversationID, conversationType))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryConversationList(
      dynamic config, dynamic option) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryConversationList(
                _mapToJSObject(config), _mapToJSObject(option)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryConversationPinnedList(
      dynamic config) async {
    final _config = _mapToJSObject((config));

    final result = await promiseToFuture(
            ZIM.getInstance()!.queryConversationPinnedList(_config))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryConversationTotalUnreadMessageCount(
      dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryConversationTotalUnreadMessageCount(_mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> deleteConversation(
      String conversationID, dynamic conversationType, dynamic config) async {
    final result = await promiseToFuture(ZIM.getInstance()!.deleteConversation(
            conversationID, conversationType, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<void> deleteAllConversations(dynamic config) async {
    await promiseToFuture(
            ZIM.getInstance()!.deleteAllConversations(_mapToJSObject(config)))
        .catchError(_handleError);

    return Future.value();
  }

  Future<void> deleteAllConversationMessages(dynamic config) async {
    await promiseToFuture(ZIM
            .getInstance()!
            .deleteAllConversationMessages(_mapToJSObject(config)))
        .catchError(_handleError);

    return Future.value();
  }

  Future<Map<dynamic, dynamic>> clearConversationUnreadMessageCount(
      String conversationID, int conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .clearConversationUnreadMessageCount(
                conversationID, conversationType))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<void> clearConversationTotalUnreadMessageCount() async {
    await promiseToFuture(
            ZIM.getInstance()!.clearConversationTotalUnreadMessageCount())
        .catchError(_handleError);
    return Future.value();
  }

  Future<Map<dynamic, dynamic>> updateConversationPinnedState(
      bool isPinned, String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .updateConversationPinnedState(
                isPinned, conversationID, conversationType))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> setConversationDraft(
      String draft, String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .setConversationDraft(draft, conversationID, conversationType))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> setConversationMark(
      int markType, bool enable, dynamic conversationInfos) async {
    final result = await promiseToFuture(ZIM.getInstance()!.setConversationMark(
            markType, enable, _dartValueToJs(conversationInfos)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> setConversationNotificationStatus(
      dynamic status, String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .setConversationNotificationStatus(
                status, conversationID, conversationType))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  /// MARK: - Message

  Future<Map<dynamic, dynamic>> sendMessage(
      dynamic message,
      String toConversationID,
      dynamic conversationType,
      dynamic config,
      int? messageAttachedCallbackID,
      int? mediaUploadingCallbackID,
      int? multipleMediaUploadingCallbackID,
      int messageID) async {
    final _message = _mapToJSObject(message);
    final _config = _mapToJSObject(config);

    Map notification = {
      'onMessageAttached': allowInterop((message) {
        ZIMMessageAttachedCallback? callback = ZIMCommonData
            .zimMessageAttachedCallbackMap[messageAttachedCallbackID];

        if (callback != null) {
          callback(
              ZIMDataUtils.parseZIMMessageFromMap(_jsObjectToMap(message)));
        }
      }),
      'onMediaUploadingProgress':
          allowInterop((message, currentFileSize, totalFileSize) {
        ZIMMediaUploadingProgress? progress =
            ZIMCommonData.mediaUploadingProgressMap[mediaUploadingCallbackID];
        if (progress != null) {
          progress(
              ZIMDataUtils.parseZIMMessageFromMap(_jsObjectToMap(message))
                  as ZIMMediaMessage,
              currentFileSize,
              totalFileSize);
        }
      }),
      'onMultipleMediaUploadingProgress': allowInterop((message,
          currentFileSize,
          totalFileSize,
          messageInfoIndex,
          currentIndexFileSize,
          totalIndexFileSize) {
        ZIMMultipleMediaUploadingProgress? progress =
            ZIMCommonData.multipleMediaUploadingProgressMap[
                multipleMediaUploadingCallbackID];
        if (progress != null) {
          progress(
              ZIMDataUtils.parseZIMMessageFromMap(_jsObjectToMap(message))
                  as ZIMMultipleMessage,
              currentFileSize,
              totalFileSize,
              messageInfoIndex,
              currentIndexFileSize,
              totalIndexFileSize);
        }
      })
    };

    final result = await promiseToFuture(ZIM.getInstance()!.sendMessage(
            _message,
            toConversationID,
            conversationType,
            _config,
            _mapToJSObject(notification)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> editMessage(
      dynamic message,
      dynamic config,
      int? messageAttachedCallbackID,
      int? multipleMediaUploadingCallbackID) async {
    final _message = _mapToJSObject(message);
    final _config = _mapToJSObject(config);

    Map notification = {
      'onMessageAttached': allowInterop((message) {
        ZIMMessageAttachedCallback? callback = ZIMCommonData
            .zimMessageAttachedCallbackMap[messageAttachedCallbackID];

        if (callback != null) {
          callback(
              ZIMDataUtils.parseZIMMessageFromMap(_jsObjectToMap(message)));
        }
      }),
      'onMultipleMediaUploadingProgress': allowInterop((message,
          currentFileSize,
          totalFileSize,
          messageInfoIndex,
          currentIndexFileSize,
          totalIndexFileSize) {
        ZIMMultipleMediaUploadingProgress? progress =
            ZIMCommonData.multipleMediaUploadingProgressMap[
                multipleMediaUploadingCallbackID];
        if (progress != null) {
          progress(
              ZIMDataUtils.parseZIMMessageFromMap(_jsObjectToMap(message))
                  as ZIMMultipleMessage,
              currentFileSize,
              totalFileSize,
              messageInfoIndex,
              currentIndexFileSize,
              totalIndexFileSize);
        }
      })
    };

    final result = await promiseToFuture(ZIM
            .getInstance()!
            .editMessage(_message, _config, _mapToJSObject(notification)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> replyMessage(
      dynamic message,
      dynamic toOriginalMessage,
      dynamic config,
      int messageID,
      int? messageAttachedCallbackID,
      int? mediaUploadingCallbackID,
      int? multipleMediaUploadingCallbackID) async {
    final _message = _mapToJSObject(message);
    final _toOriginalMessage = _mapToJSObject(toOriginalMessage);
    final _config = _mapToJSObject(config);

    Map notification = {
      'onMessageAttached': allowInterop((message) {
        ZIMMessageAttachedCallback? callback = ZIMCommonData
            .zimMessageAttachedCallbackMap[messageAttachedCallbackID];

        if (callback != null) {
          callback(
              ZIMDataUtils.parseZIMMessageFromMap(_jsObjectToMap(message)));
        }
      }),
      'onMediaUploadingProgress':
          allowInterop((message, currentFileSize, totalFileSize) {
        ZIMMediaUploadingProgress? progress =
            ZIMCommonData.mediaUploadingProgressMap[mediaUploadingCallbackID];

        if (progress != null) {
          progress(
              ZIMDataUtils.parseZIMMessageFromMap(_jsObjectToMap(message))
                  as ZIMMediaMessage,
              currentFileSize,
              totalFileSize);
        }
      }),
      'onMultipleMediaUploadingProgress': allowInterop((message,
          currentFileSize,
          totalFileSize,
          messageInfoIndex,
          currentIndexFileSize,
          totalIndexFileSize) {
        ZIMMultipleMediaUploadingProgress? progress =
            ZIMCommonData.multipleMediaUploadingProgressMap[
                multipleMediaUploadingCallbackID];
        if (progress != null) {
          progress(
              ZIMDataUtils.parseZIMMessageFromMap(_jsObjectToMap(message))
                  as ZIMMultipleMessage,
              currentFileSize,
              totalFileSize,
              messageInfoIndex,
              currentIndexFileSize,
              totalIndexFileSize);
        }
      })
    };
    final _notification = _mapToJSObject(notification);

    final result = await promiseToFuture(ZIM
            .getInstance()!
            .replyMessage(_message, _toOriginalMessage, _config, _notification))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> insertMessageToLocalDB(
      dynamic message,
      int messageID,
      String conversationID,
      dynamic conversationType,
      String senderUserID) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .insertMessageToLocalDB(_mapToJSObject(message), conversationID,
                conversationType, senderUserID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<void> cancelSendingMessage(dynamic message, dynamic config) async {
    await promiseToFuture(ZIM.getInstance()!.cancelSendingMessage(
            _mapToJSObject(message), _mapToJSObject(config)))
        .catchError(_handleError);

    return Future.value();
  }

  Future<Map<dynamic, dynamic>> deleteMessages(dynamic messageList,
      String conversationID, dynamic conversationType, dynamic config) async {
    final result = await promiseToFuture(ZIM.getInstance()!.deleteMessages(
            _dartValueToJs(messageList),
            conversationID,
            conversationType,
            _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> deleteAllMessage(
      String conversationID, dynamic conversationType, dynamic config) async {
    final result = await promiseToFuture(ZIM.getInstance()!.deleteAllMessage(
            conversationID, conversationType, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> downloadMediaFile(
      dynamic message, dynamic fileType, int progressID) async {
    ZIMMediaDownloadingProgress? progress =
        ZIMCommonData.mediaDownloadingProgressMap[progressID];
    if (progress != null) {
      int size = message['fileSize'] ?? 1;
      progress(ZIMDataUtils.parseZIMMessageFromMap(message), size, size);
    }
    return {'message': message};
  }

  Future<Map<dynamic, dynamic>> queryHistoryMessage(
      String conversationID, int conversationType, dynamic config) async {
    final result = await promiseToFuture(ZIM.getInstance()!.queryHistoryMessage(
            conversationID, conversationType, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryMessages(dynamic messageSeqs,
      String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryMessages(messageSeqs, conversationID, conversationType))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryMessageRepliedList(
      dynamic message, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryMessageRepliedList(
                _mapToJSObject(message), _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryCombineMessageDetail(
      dynamic message) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryCombineMessageDetail(_mapToJSObject(message)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateMessageLocalExtendedData(
    String localExtendedData,
    dynamic message,
  ) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .updateMessageLocalExtendedData(
                localExtendedData, _mapToJSObject(message)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> revokeMessage(
      dynamic message, dynamic config) async {
    final _message = _mapToJSObject(message);
    final _config = _mapToJSObject(config);

    final result = await promiseToFuture(
            ZIM.getInstance()!.revokeMessage(_message, _config))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> sendConversationMessageReceiptRead(
      String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .sendConversationMessageReceiptRead(
                conversationID, conversationType))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> sendMessageReceiptsRead(dynamic messageList,
      String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .sendMessageReceiptsRead(
                _dartValueToJs(messageList), conversationID, conversationType))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryMessageReceiptsInfo(dynamic messageList,
      String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryMessageReceiptsInfo(
                _dartValueToJs(messageList), conversationID, conversationType))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupMessageReceiptReadMemberList(
      dynamic message, String groupID, dynamic config) async {
    final _message = _mapToJSObject(message);
    final _config = _mapToJSObject(config);

    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryGroupMessageReceiptReadMemberList(_message, groupID, _config))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupMessageReceiptUnreadMemberList(
      dynamic message, String groupID, dynamic config) async {
    final _message = _mapToJSObject(message);
    final _config = _mapToJSObject(config);

    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryGroupMessageReceiptUnreadMemberList(
                _message, groupID, _config))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> addMessageReaction(
      String reactionType, dynamic message, dynamic? config) async {
    final result = await promiseToFuture(ZIM.getInstance()!.addMessageReaction(
            reactionType,
            _mapToJSObject(message),
            config == null ? null : _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> deleteMessageReaction(
      String reactionType, dynamic message) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .deleteMessageReaction(reactionType, _mapToJSObject(message)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<void> deleteMessageAllReactions(dynamic message) async {
    await promiseToFuture(ZIM
            .getInstance()!
            .deleteMessageAllReactions(_mapToJSObject(message)))
        .catchError(_handleError);

    return Future.value();
  }

  Future<Map<dynamic, dynamic>> queryMessageReactionUserList(
      dynamic message, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryMessageReactionUserList(
                _mapToJSObject(message), _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<void> pinMessage(
      dynamic message, bool isPinned, dynamic? config) async {
    await promiseToFuture(ZIM.getInstance()!.pinMessage(_mapToJSObject(message),
            isPinned, config == null ? null : _mapToJSObject(config)))
        .catchError(_handleError);

    return Future.value();
  }

  Future<Map<dynamic, dynamic>> queryPinnedMessageList(
      String conversationID, dynamic conversationType) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryPinnedMessageList(conversationID, conversationType))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  /// MARK: - Room

  Future<Map<dynamic, dynamic>> createRoom(
      dynamic roomInfo, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .createRoom(_mapToJSObject(roomInfo), _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> enterRoom(
      dynamic roomInfo, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .enterRoom(_mapToJSObject(roomInfo), _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> joinRoom(String roomID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.joinRoom(roomID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> switchRoom(
      String fromRoomID,
      dynamic toRoomInfo,
      bool isCreateWhenRoomNotExisted,
      dynamic config) async {
    final result = await promiseToFuture(ZIM.getInstance()!.switchRoom(
            fromRoomID,
            _mapToJSObject(toRoomInfo),
            isCreateWhenRoomNotExisted,
            _mapToJSObject(config)))
        .catchError(_handleError);
    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> leaveRoom(String roomID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.leaveRoom(roomID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> leaveAllRoom() async {
    final result = await promiseToFuture(ZIM.getInstance()!.leaveAllRoom())
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryRoomMembers(
      dynamic userIDs, String roomID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryRoomMembers(userIDs, roomID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryRoomMemberList(
      String roomID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryRoomMemberList(roomID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryRoomOnlineMemberCount(
      String roomID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryRoomOnlineMemberCount(roomID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryRoomAllAttributes(String roomID) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.queryRoomAllAttributes(roomID))
            .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> setRoomAttributes(
      Map roomAttributes, String roomID, dynamic config) async {
    final result = await promiseToFuture(ZIM.getInstance()!.setRoomAttributes(
            _mapToJSObject(roomAttributes), roomID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> deleteRoomAttributes(
      dynamic keys, String roomID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .deleteRoomAttributes(keys, roomID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  void beginRoomAttributesBatchOperation(String roomID, dynamic config) {
    ZIM
        .getInstance()!
        .beginRoomAttributesBatchOperation(roomID, _mapToJSObject(config));
  }

  Future<Map<dynamic, dynamic>> endRoomAttributesBatchOperation(
      String roomID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.endRoomAttributesBatchOperation(roomID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> setRoomMembersAttributes(
      Map attributes, String roomID, dynamic userIDs, dynamic config) async {
    final _attributes = _mapToJSObject(attributes);
    final _config = _mapToJSObject(config);

    final result = await promiseToFuture(ZIM
            .getInstance()!
            .setRoomMembersAttributes(_attributes, userIDs, roomID, _config))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryRoomMembersAttributes(
      dynamic userIDs, String roomID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryRoomMembersAttributes(userIDs, roomID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryRoomMemberAttributesList(
      String roomID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryRoomMemberAttributesList(roomID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  /// MARK: - Group

  Future<Map<dynamic, dynamic>> createGroup(
      dynamic groupInfo, dynamic userIDs, dynamic config) async {
    final result = await promiseToFuture(ZIM.getInstance()!.createGroup(
            _mapToJSObject(groupInfo), userIDs, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> joinGroup(String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.joinGroup(groupID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> leaveGroup(String groupID) async {
    final result = await promiseToFuture(ZIM.getInstance()!.leaveGroup(groupID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> dismissGroup(String groupID) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.dismissGroup(groupID))
            .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupList(
      {int? count, dynamic? config}) async {
    final result = await promiseToFuture(ZIM.getInstance()!.queryGroupList(
            count ?? 0, config == null ? null : _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateGroupName(
      String groupName, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateGroupName(groupName, groupID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateGroupAvatarUrl(
      String groupAvatarUrl, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateGroupAvatarUrl(groupAvatarUrl, groupID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateGroupNotice(
      String groupNotice, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateGroupNotice(groupNotice, groupID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateGroupAlias(
      String groupAlias, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateGroupAlias(groupAlias, groupID))
        .catchError(_handleError);
    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupInfo(String groupID) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.queryGroupInfo(groupID))
            .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> setGroupAttributes(
      dynamic groupAttributes, String groupID) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .setGroupAttributes(_mapToJSObject(groupAttributes), groupID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> deleteGroupAttributes(
      dynamic keys, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.deleteGroupAttributes(keys, groupID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupAttributes(
      dynamic keys, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryGroupAttributes(keys, groupID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupAllAttributes(String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryGroupAllAttributes(groupID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> inviteUsersIntoGroup(
      dynamic userIDs, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.inviteUsersIntoGroup(userIDs, groupID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> kickGroupMembers(
      dynamic userIDs, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.kickGroupMembers(userIDs, groupID))
        .catchError(_handleError);

    Map map = _jsObjectToMap(result);
    map['kickedUserIDList'] = map['kickedUserIDs'];
    return map;
  }

  Future<Map<dynamic, dynamic>> transferGroupOwner(
      String toUserID, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.transferGroupOwner(toUserID, groupID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> setGroupMemberRole(
    int role,
    String forUserID,
    String groupID,
  ) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.setGroupMemberRole(role, forUserID, groupID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> setGroupMemberNickname(
    String nickname,
    String forUserID,
    String groupID,
  ) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .setGroupMemberNickname(nickname, forUserID, groupID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupMemberInfo(
      String userID, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryGroupMemberInfo(userID, groupID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupMemberList(
      String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryGroupMemberList(groupID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupMemberCount(String groupID) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.queryGroupMemberCount(groupID))
            .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> muteGroup(
      bool isMute, String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .muteGroup(isMute, groupID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> muteGroupMembers(
      bool isMute, dynamic userIDs, String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .muteGroupMembers(isMute, userIDs, groupID, _mapToJSObject(config)))
        .catchError(_handleError);

    Map map = _jsObjectToMap(result);
    map['mutedMemberIDs'] = map['mutedUserIDs'];
    return map;
  }

  Future<Map<dynamic, dynamic>> queryGroupMemberMutedList(
      String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryGroupMemberMutedList(groupID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateGroupJoinMode(
      dynamic mode, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateGroupJoinMode(mode, groupID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateGroupInviteMode(
      dynamic mode, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateGroupInviteMode(mode, groupID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateGroupBeInviteMode(
      dynamic mode, String groupID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateGroupBeInviteMode(mode, groupID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> sendGroupJoinApplication(
      String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .sendGroupJoinApplication(groupID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> acceptGroupJoinApplication(
      String userID, String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .acceptGroupJoinApplication(
                userID, groupID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> rejectGroupJoinApplication(
      String userID, String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .rejectGroupJoinApplication(
                userID, groupID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> sendGroupInviteApplications(
      dynamic userIDs, String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .sendGroupInviteApplications(
                userIDs, groupID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> acceptGroupInviteApplication(
      String inviterUserID, String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .acceptGroupInviteApplication(
                inviterUserID, groupID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> rejectGroupInviteApplication(
      String inviterUserID, String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .rejectGroupInviteApplication(
                inviterUserID, groupID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryGroupApplicationList(
      dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryGroupApplicationList(_mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  /// MARK: - Call

  Future<Map<dynamic, dynamic>> callInvite(
      dynamic invitees, dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.callInvite(invitees, _mapToJSObject(config)))
        .catchError(_handleError);

    Map map = _jsObjectToMap(result);
    map['errorInvitees'] = [];
    return {'callID': map['callID'], 'info': map};
  }

  Future<Map<dynamic, dynamic>> callCancel(
      dynamic invitees, String callID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .callCancel(invitees, callID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> callAccept(
      String callID, dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.callAccept(callID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> callReject(
      String callID, dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.callReject(callID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> callJoin(String callID, dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.callJoin(callID, _mapToJSObject(config)))
        .catchError(_handleError);

    Map map = _jsObjectToMap(result);
    return {'callID': map['callID'], 'info': map};
  }

  Future<Map<dynamic, dynamic>> callQuit(String callID, dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.callQuit(callID, _mapToJSObject(config)))
        .catchError(_handleError);

    Map map = _jsObjectToMap(result);
    return {'callID': map['callID'], 'info': map};
  }

  Future<Map<dynamic, dynamic>> callEnd(String callID, dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.callEnd(callID, _mapToJSObject(config)))
        .catchError(_handleError);

    Map map = _jsObjectToMap(result);
    return {'callID': map['callID'], 'info': map};
  }

  Future<Map<dynamic, dynamic>> callingInvite(
      dynamic invitees, String callID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .callingInvite(invitees, callID, _mapToJSObject(config)))
        .catchError(_handleError);

    Map map = _jsObjectToMap(result);
    return {'callID': map['callID'], 'info': map};
  }

  Future<Map<dynamic, dynamic>> queryCallInvitationList(dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryCallInvitationList(_mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  /// MARK: - Friend

  Future<Map<dynamic, dynamic>> addFriend(String userID, dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.addFriend(userID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> deleteFriends(
      dynamic userIDs, dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.deleteFriends(userIDs, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> checkFriendsRelation(
      dynamic userIDs, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .checkFriendsRelation(userIDs, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateFriendAlias(
      String friendAlias, String userID) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.updateFriendAlias(friendAlias, userID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> updateFriendAttributes(
      dynamic friendAttributes, String userID) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .updateFriendAttributes(_mapToJSObject(friendAttributes), userID))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> sendFriendApplication(
      String userID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .sendFriendApplication(userID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> acceptFriendApplication(
      String userID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .acceptFriendApplication(userID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> rejectFriendApplication(
      String userID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .rejectFriendApplication(userID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryFriendsInfo(dynamic userIDs) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.queryFriendsInfo(userIDs))
            .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryFriendList(dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryFriendList(_mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryFriendApplicationList(
      dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .queryFriendApplicationList(_mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  /// MARK: - Blacklist

  Future<Map<dynamic, dynamic>> addUsersToBlacklist(dynamic userIDs) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.addUsersToBlacklist(userIDs))
            .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> removeUsersFromBlacklist(
      dynamic userIDs) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.removeUsersFromBlacklist(userIDs))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> checkUserIsInBlacklist(String userID) async {
    final result =
        await promiseToFuture(ZIM.getInstance()!.checkUserIsInBlacklist(userID))
            .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> queryBlacklist(dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.queryBlacklist(_mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  /// MARK: - DB Search

  Future<Map<dynamic, dynamic>> searchLocalConversations(dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.searchLocalConversations(_mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> searchGlobalLocalMessages(
      dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .searchGlobalLocalMessages(_mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> searchLocalMessages(
      String conversationID, dynamic conversationType, dynamic config) async {
    final result = await promiseToFuture(ZIM.getInstance()!.searchLocalMessages(
            conversationID, conversationType, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> searchLocalGroups(dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.searchLocalGroups(_mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> searchLocalGroupMembers(
      String groupID, dynamic config) async {
    final result = await promiseToFuture(ZIM
            .getInstance()!
            .searchLocalGroupMembers(groupID, _mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }

  Future<Map<dynamic, dynamic>> searchLocalFriends(dynamic config) async {
    final result = await promiseToFuture(
            ZIM.getInstance()!.searchLocalFriends(_mapToJSObject(config)))
        .catchError(_handleError);

    return _jsObjectToMap(result);
  }
}
