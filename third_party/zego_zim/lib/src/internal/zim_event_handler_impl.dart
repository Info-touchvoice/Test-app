import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:zego_zim/src/internal/zim_engine.dart';

import '../zim_defines.dart';
import '../zim_event_handler.dart';
import 'zim_common_data.dart';
import 'zim_manager.dart';

class ZIMEventHandlerImpl implements ZIMEventHandler {
  static const EventChannel _event = EventChannel('zim_event_handler');
  static StreamSubscription<dynamic>? _streamSubscription;

  /* EventHandler */

  static void registerEventHandler() async {
    _streamSubscription = _event.receiveBroadcastStream().listen(eventListener);
  }

  static void unregisterEventHandler() async {
    await _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  static void eventListener(dynamic data) {
    final Map<dynamic, dynamic> map = data;
    ZIMEngine? zim = ZIMManager.engineMap[map['handle']];
    try {
      if (zim == null) {
        return;
      }
      switch (map['method']) {
        case 'onConnectionStateChanged':
          if (ZIMEventHandler.onConnectionStateChanged == null) return;
          ZIMEventHandler.onConnectionStateChanged!(
              zim,
              ZIMConnectionStateExtension.mapValue[map['state']]!,
              ZIMConnectionEventExtension.mapValue[map['event']]!,
              json.decode(map['extendedData']));
          break;
        case 'onError':
          if (ZIMEventHandler.onError == null) return;
          ZIMError errorInfo =
              ZIMError(code: map['code'], message: map['message']);
          ZIMEventHandler.onError!(zim, errorInfo);
          break;
        case 'onExperimentalEventReceived':
          if (ZIMEventHandler.onError == null) return;
          ZIMEventHandler.onExperimentalEventReceived!(
              zim, map['content'] ?? '');
          break;
        case 'onTokenWillExpire':
          if (ZIMEventHandler.onTokenWillExpire == null) return;
          ZIMEventHandler.onTokenWillExpire!(zim, map['second']);
          break;
        case 'onUserInfoUpdated':
          if (ZIMEventHandler.onUserInfoUpdated == null) return;
          ZIMUserFullInfo info = ZIMUserFullInfo.fromMap(map['info']);
          ZIMEventHandler.onUserInfoUpdated!(zim, info);
          break;
        case 'onConversationChanged':
          if (ZIMEventHandler.onConversationChanged == null) return;
          List<ZIMConversationChangeInfo> infos =
              (map['conversationChangeInfoList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMConversationChangeInfo.fromMap(x))
                  .toList();

          ZIMEventHandler.onConversationChanged!(zim, infos);
          break;
        case 'onConversationsAllDeleted':
          if (ZIMEventHandler.onConversationsAllDeleted == null) return;
          ZIMEventHandler.onConversationsAllDeleted!(
              zim, ZIMConversationsAllDeletedInfo.fromMap(map['info']));
          break;
        case 'onConversationSyncStateChanged':
          if (ZIMEventHandler.onConversationSyncStateChanged == null) return;
          ZIMEventHandler.onConversationSyncStateChanged!(
              zim, ZIMConversationSyncStateExtension.mapValue[map['state']]!);
          break;
        case 'onMessageSentStatusChanged':
          if (ZIMEventHandler.onMessageSentStatusChanged == null) return;
          List<ZIMMessageSentStatusChangeInfo> infos =
              (map['messageSentStatusChangeInfoList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMMessageSentStatusChangeInfo.fromMap(x))
                  .toList();

          ZIMEventHandler.onMessageSentStatusChanged!(zim, infos);
          break;
        case 'onMessageDeleted':
          if (ZIMEventHandler.onMessageDeleted == null) return;
          ZIMMessageDeletedInfo info =
              ZIMMessageDeletedInfo.fromMap(map['deletedInfo']);
          ZIMEventHandler.onMessageDeleted!(zim, info);
          break;
        case 'onConversationTotalUnreadMessageCountUpdated':
          if (ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated ==
              null) return;
          ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated!(
              zim, map['totalUnreadMessageCount']);
          break;
        case 'onReceivePeerMessage':
          if (ZIMEventHandler.onReceivePeerMessage == null) return;
          List<ZIMMessage> messageList = (map['messageList'] as List)
              .cast<Map>()
              .map((x) => ZIMDataUtils.parseZIMMessageFromMap(x))
              .toList();
          ZIMEventHandler.onReceivePeerMessage!(
              zim, messageList, map['fromUserID']);
          break;
        case 'onReceiveRoomMessage':
          if (ZIMEventHandler.onReceiveRoomMessage == null) return;
          List<ZIMMessage> messageList = (map['messageList'] as List)
              .cast<Map>()
              .map((x) => ZIMDataUtils.parseZIMMessageFromMap(x))
              .toList();
          ZIMEventHandler.onReceiveRoomMessage!(
              zim, messageList, map['fromRoomID']);
          break;
        case 'onReceiveGroupMessage':
          if (ZIMEventHandler.onReceiveGroupMessage == null) return;
          List<ZIMMessage> messageList = (map['messageList'] as List)
              .cast<Map>()
              .map((x) => ZIMDataUtils.parseZIMMessageFromMap(x))
              .toList();
          ZIMEventHandler.onReceiveGroupMessage!(
              zim, messageList, map['fromGroupID']);
          break;
        case 'onPeerMessageReceived':
          if (ZIMEventHandler.onPeerMessageReceived == null) return;
          List<ZIMMessage> messageList = (map['messageList'] as List)
              .cast<Map>()
              .map((x) => ZIMDataUtils.parseZIMMessageFromMap(x))
              .toList();
          ZIMMessageReceivedInfo info =
              ZIMMessageReceivedInfo.fromMap(map['info']);
          ZIMEventHandler.onPeerMessageReceived!(
              zim, messageList, info, map['fromUserID']);
          break;
        case 'onRoomMessageReceived':
          if (ZIMEventHandler.onRoomMessageReceived == null) return;
          List<ZIMMessage> messageList = (map['messageList'] as List)
              .cast<Map>()
              .map((x) => ZIMDataUtils.parseZIMMessageFromMap(x))
              .toList();
          ZIMMessageReceivedInfo info =
              ZIMMessageReceivedInfo.fromMap(map['info']);
          ZIMEventHandler.onRoomMessageReceived!(
              zim, messageList, info, map['fromRoomID']);
          break;
        case 'onGroupMessageReceived':
          if (ZIMEventHandler.onGroupMessageReceived == null) return;
          List<ZIMMessage> messageList = (map['messageList'] as List)
              .cast<Map>()
              .map((x) => ZIMDataUtils.parseZIMMessageFromMap(x))
              .toList();
          ZIMMessageReceivedInfo info =
              ZIMMessageReceivedInfo.fromMap(map['info']);
          ZIMEventHandler.onGroupMessageReceived!(
              zim, messageList, info, map['fromGroupID']);
          break;
        case 'onRoomMemberJoined':
          if (ZIMEventHandler.onRoomMemberJoined == null) return;
          List<ZIMUserInfo> memberList = (map['memberList'] as List)
              .cast<Map>()
              .map((x) => ZIMUserInfo.fromMap(x))
              .toList();
          ZIMEventHandler.onRoomMemberJoined!(zim, memberList, map['roomID']);
          break;
        case 'onRoomMemberLeft':
          if (ZIMEventHandler.onRoomMemberLeft == null) return;
          List<ZIMUserInfo> memberList = (map['memberList'] as List)
              .cast<Map>()
              .map((x) => ZIMUserInfo.fromMap(x))
              .toList();
          ZIMEventHandler.onRoomMemberLeft!(zim, memberList, map['roomID']);
          break;
        case 'onRoomStateChanged':
          if (ZIMEventHandler.onRoomStateChanged == null) return;
          ZIMEventHandler.onRoomStateChanged!(
              zim,
              ZIMRoomStateExtension.mapValue[map['state']]!,
              ZIMRoomEventExtension.mapValue[map['event']]!,
              json.decode(map['extendedData']),
              map['roomID']);
          break;
        case 'onRoomAttributesUpdated':
          if (ZIMEventHandler.onRoomAttributesUpdated == null) return;

          ZIMEventHandler.onRoomAttributesUpdated!(
              zim,
              ZIMRoomAttributesUpdateInfo.fromMap(map['updateInfo']),
              map['roomID']);

          break;
        case 'onRoomAttributesBatchUpdated':
          if (ZIMEventHandler.onRoomAttributesBatchUpdated == null) return;

          ZIMEventHandler.onRoomAttributesBatchUpdated!(
              zim,
              (map['updateInfo'] as List)
                  .cast<Map>()
                  .map((x) => ZIMRoomAttributesUpdateInfo.fromMap(x))
                  .toList(),
              map['roomID']);
          break;
        case 'onRoomMemberAttributesUpdated':
          if (ZIMEventHandler.onRoomMemberAttributesUpdated == null) return;
          ZIMEventHandler.onRoomMemberAttributesUpdated!(
              zim,
              (map['infos'] as List)
                  .cast<Map>()
                  .map((x) => ZIMRoomMemberAttributesUpdateInfo.fromMap(x))
                  .toList(),
              ZIMRoomOperatedInfo.fromMap(map['operatedInfo']),
              map['roomID']);
          break;
        case 'onGroupStateChanged':
          if (ZIMEventHandler.onGroupStateChanged == null) return;

          ZIMEventHandler.onGroupStateChanged!(
              zim,
              ZIMGroupStateExtension.mapValue[map['state']]!,
              ZIMGroupEventExtension.mapValue[map['event']]!,
              ZIMGroupOperatedInfo.fromMap(map['operatedInfo']),
              ZIMGroupFullInfo.fromMap(map['groupInfo']));
          break;
        case 'onGroupNameUpdated':
          if (ZIMEventHandler.onGroupNameUpdated == null) return;

          ZIMEventHandler.onGroupNameUpdated!(
              zim,
              map['groupName'],
              ZIMGroupOperatedInfo.fromMap(map['operatedInfo']),
              map['groupID']);
          break;
        case 'onGroupAliasUpdated':
          if (ZIMEventHandler.onGroupAliasUpdated == null) return;

          ZIMEventHandler.onGroupAliasUpdated!(
              zim, map['groupAlias'], map['operatedUserID'], map['groupID']);
          break;
        case 'onGroupNoticeUpdated':
          if (ZIMEventHandler.onGroupNoticeUpdated == null) return;

          ZIMEventHandler.onGroupNoticeUpdated!(
              zim,
              map['groupNotice'],
              ZIMGroupOperatedInfo.fromMap(map['operatedInfo']),
              map['groupID']);
          break;
        case 'onGroupAvatarUrlUpdated':
          if (ZIMEventHandler.onGroupAvatarUrlUpdated == null) return;
          ZIMEventHandler.onGroupAvatarUrlUpdated!(
              zim,
              map['groupAvatarUrl'],
              ZIMGroupOperatedInfo.fromMap(map['operatedInfo']),
              map['groupID']);
          break;
        case 'onGroupAttributesUpdated':
          if (ZIMEventHandler.onGroupAttributesUpdated == null) return;

          ZIMEventHandler.onGroupAttributesUpdated!(
              zim,
              (map['updateInfo'] as List)
                  .cast<Map>()
                  .map((x) => ZIMGroupAttributesUpdateInfo.fromMap(x))
                  .toList(),
              ZIMGroupOperatedInfo.fromMap(map['operatedInfo']),
              map['groupID']);
          break;
        case 'onGroupMemberStateChanged':
          if (ZIMEventHandler.onGroupMemberStateChanged == null) return;

          ZIMEventHandler.onGroupMemberStateChanged!(
              zim,
              ZIMGroupMemberStateExtension.mapValue[map['state']]!,
              ZIMGroupMemberEventExtension.mapValue[map['event']]!,
              (map['userList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMGroupMemberInfo.fromMap(x))
                  .toList(),
              ZIMGroupOperatedInfo.fromMap(map['operatedInfo']),
              map['groupID']);
          break;
        case 'onGroupMemberInfoUpdated':
          if (ZIMEventHandler.onGroupMemberInfoUpdated == null) return;

          ZIMEventHandler.onGroupMemberInfoUpdated!(
              zim,
              (map['userInfo'] as List)
                  .cast<Map>()
                  .map((x) => ZIMGroupMemberInfo.fromMap(x))
                  .toList(),
              ZIMGroupOperatedInfo.fromMap(map['operatedInfo']),
              map['groupID']);
          break;
        case 'onCallInvitationReceived':
          if (ZIMEventHandler.onCallInvitationReceived == null) return;

          ZIMEventHandler.onCallInvitationReceived!(
              zim,
              ZIMCallInvitationReceivedInfo.fromMap(map['info']),
              map['callID']);
          break;
        case 'onCallInvitationCancelled':
          if (ZIMEventHandler.onCallInvitationCancelled == null) return;

          ZIMEventHandler.onCallInvitationCancelled!(
              zim,
              ZIMCallInvitationCancelledInfo.fromMap(map['info']),
              map['callID']);
          break;
        case 'onCallInvitationAccepted':
          if (ZIMEventHandler.onCallInvitationAccepted == null) return;

          ZIMEventHandler.onCallInvitationAccepted!(
              zim,
              ZIMCallInvitationAcceptedInfo.fromMap(map['info']),
              map['callID']);
          break;
        case 'onCallInvitationRejected':
          if (ZIMEventHandler.onCallInvitationRejected == null) return;

          ZIMEventHandler.onCallInvitationRejected!(
              zim,
              ZIMCallInvitationRejectedInfo.fromMap(map['info']),
              map['callID']);
          break;
        case 'onCallInvitationTimeout':
          if (ZIMEventHandler.onCallInvitationTimeout == null) return;

          ZIMEventHandler.onCallInvitationTimeout!(zim,
              ZIMCallInvitationTimeoutInfo.fromMap(map['info']), map['callID']);
          break;
        case 'onCallInviteesAnsweredTimeout':
          if (ZIMEventHandler.onCallInviteesAnsweredTimeout == null) return;

          ZIMEventHandler.onCallInviteesAnsweredTimeout!(
              zim,
              List<String>.from((map['invitees'] as List).cast<String>()),
              map['callID']);
          break;
        case 'onMessageAttached':
          int? messageAttachedCallbackID = map['messageAttachedCallbackID'];
          ZIMMessageAttachedCallback? onMessageAttached = ZIMCommonData
              .zimMessageAttachedCallbackMap[messageAttachedCallbackID];
          if (onMessageAttached != null) {
            ZIMMessage message =
                ZIMDataUtils.parseZIMMessageFromMap(map['message']);
            onMessageAttached(message);
          }
          break;
        case 'downloadMediaFileProgress':
          int? progressID = map['progressID'];
          ZIMMessage message =
              ZIMDataUtils.parseZIMMessageFromMap(map['message']);
          int currentFileSize = map['currentFileSize'];
          int totalFileSize = map['totalFileSize'];
          ZIMMediaDownloadingProgress? progress =
              ZIMCommonData.mediaDownloadingProgressMap[progressID ?? 0];
          if (progress != null) {
            progress(message, currentFileSize, totalFileSize);
          }
          break;
        case 'messageExportingProgress':
          int? progressID = map['progressID'];
          int exportedMessageCount = map['exportedMessageCount'];
          int totalMessageCount = map['totalMessageCount'];
          ZIMMessageExportingProgress? progress =
              ZIMCommonData.messageExportingProgressMap[progressID ?? 0];
          if (progress != null) {
            progress(exportedMessageCount, totalMessageCount);
          }
          break;
        case 'messageImportingProgress':
          int? progressID = map['progressID'];
          int importedMessageCount = map['importedMessageCount'];
          int totalMessageCount = map['totalMessageCount'];
          ZIMMessageImportingProgress? progress =
              ZIMCommonData.messageImportingProgressMap[progressID ?? 0];
          if (progress != null) {
            progress(importedMessageCount, totalMessageCount);
          }
          break;
        case 'uploadMediaProgress':
          int? progressID = map['mediaUploadingCallbackID'];
          ZIMMediaMessage message =
              ZIMDataUtils.parseZIMMessageFromMap(map['message'])
                  as ZIMMediaMessage;
          int currentFileSize = map['currentFileSize'];
          int totalFileSize = map['totalFileSize'];
          ZIMMediaUploadingProgress? progress =
              ZIMCommonData.mediaUploadingProgressMap[progressID ?? 0];
          if (progress != null) {
            progress(message, currentFileSize, totalFileSize);
          }
          break;
        case 'multipleUploadMediaProgress':
          int? progressID = map['multipleMediaUploadingCallbackID'];
          ZIMMessage message =
              ZIMDataUtils.parseZIMMessageFromMap(map['message']);
          int currentFileSize = map['currentFileSize'];
          int totalFileSize = map['totalFileSize'];
          int currentIndexFileSize = map['currentIndexFileSize'];
          int totalIndexFileSize = map['totalIndexFileSize'];
          int messageInfoIndex = map['messageInfoIndex'];
          ZIMMultipleMediaUploadingProgress? progress =
              ZIMCommonData.multipleMediaUploadingProgressMap[progressID ?? 0];
          if (progress != null) {
            progress(
                (message as ZIMMultipleMessage),
                currentFileSize,
                totalFileSize,
                messageInfoIndex,
                currentIndexFileSize,
                totalIndexFileSize);
          }
          break;
        case 'onMessageRevokeReceived':
          if (ZIMEventHandler.onMessageRevokeReceived == null) return;
          List<ZIMRevokeMessage> messageList = (map['messageList'] as List)
              .cast<Map>()
              .map((x) =>
                  ZIMDataUtils.parseZIMMessageFromMap(x) as ZIMRevokeMessage)
              .toList();
          ZIMEventHandler.onMessageRevokeReceived!(zim, messageList);
          break;
        case 'onMessageReceiptChanged':
          if (ZIMEventHandler.onMessageReceiptChanged == null) return;
          ZIMEventHandler.onMessageReceiptChanged!(
              zim,
              (map['infos'] as List)
                  .cast<Map>()
                  .map((x) => ZIMMessageReceiptInfo.fromMap(x))
                  .toList());
          break;
        case 'onBroadcastMessageReceived':
          if (ZIMEventHandler.onBroadcastMessageReceived == null) return;
          ZIMEventHandler.onBroadcastMessageReceived!(
              zim, ZIMDataUtils.parseZIMMessageFromMap(map['message']));
          break;
        case 'onConversationMessageReceiptChanged':
          if (ZIMEventHandler.onConversationMessageReceiptChanged == null)
            return;
          ZIMEventHandler.onConversationMessageReceiptChanged!(
              zim,
              (map['infos'] as List)
                  .cast<Map>()
                  .map((x) => ZIMMessageReceiptInfo.fromMap(x))
                  .toList());
          break;
        case 'onCallInvitationCreated':
          if (ZIMEventHandler.onCallInvitationCreated == null) return;
          ZIMEventHandler.onCallInvitationCreated!(zim,
              ZIMCallInvitationCreatedInfo.fromMap(map['info']), map['callID']);
          break;
        case 'onCallInvitationEnded':
          if (ZIMEventHandler.onCallInvitationEnded == null) return;
          ZIMEventHandler.onCallInvitationEnded!(zim,
              ZIMCallInvitationEndedInfo.fromMap(map['info']), map['callID']);
          break;
        case 'onCallUserStateChanged':
          if (ZIMEventHandler.onCallUserStateChanged == null) return;
          String callID = map['callID'];
          ZIMEventHandler.onCallUserStateChanged!(
              zim, ZIMCallUserStateChangeInfo.fromMap(map['info']), callID);
          break;
        case 'onMessageReactionsChanged':
          if (ZIMEventHandler.onMessageReactionsChanged == null) return;
          ZIMEventHandler.onMessageReactionsChanged!(zim,
              ZIMMessageReactionsChangedEventResult.fromMap(map['result']));
          break;
        case 'onFriendInfoUpdated':
          if (ZIMEventHandler.onFriendInfoUpdated == null) return;
          List<ZIMFriendInfo> friendInfoList = (map['friendInfoList'] as List)
              .cast<Map>()
              .map((x) => ZIMFriendInfo.fromMap(x))
              .toList();
          ZIMEventHandler.onFriendInfoUpdated!(zim, friendInfoList);
          break;
        case 'onFriendListChanged':
          if (ZIMEventHandler.onFriendListChanged == null) return;
          ZIMFriendListChangeAction action =
              ZIMFriendListChangeActionExtension.mapValue[map['action']]!;
          List<ZIMFriendInfo> friendInfoList = (map['friendInfoList'] as List)
              .cast<Map>()
              .map((x) => ZIMFriendInfo.fromMap(x))
              .toList();
          ZIMEventHandler.onFriendListChanged!(zim, friendInfoList, action);
          break;

        case 'onFriendApplicationUpdated':
          if (ZIMEventHandler.onFriendApplicationUpdated == null) return;
          List<ZIMFriendApplicationInfo> friendApplicationInfoList =
              (map['friendApplicationInfoList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMFriendApplicationInfo.fromMap(x))
                  .toList();
          ZIMEventHandler.onFriendApplicationUpdated!(
              zim, friendApplicationInfoList);
          break;
        case 'onFriendApplicationListChanged':
          if (ZIMEventHandler.onFriendApplicationListChanged == null) return;
          List<ZIMFriendApplicationInfo> friendApplicationInfoList =
              (map['friendApplicationInfoList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMFriendApplicationInfo.fromMap(x))
                  .toList();
          ZIMFriendApplicationListChangeAction action =
              ZIMFriendApplicationListChangeActionExtension
                  .mapValue[map['action']]!;
          ZIMEventHandler.onFriendApplicationListChanged!(
              zim, friendApplicationInfoList, action);
          break;
        case 'onBlacklistChanged':
          if (ZIMEventHandler.onBlacklistChanged == null) return;
          ZIMBlacklistChangeAction action =
              ZIMBlacklistChangeActionExtension.mapValue[map['action']]!;
          List<ZIMUserInfo> userList = (map['userList'] as List)
              .cast<Map>()
              .map((x) => ZIMUserInfo.fromMap(x))
              .toList();
          ZIMEventHandler.onBlacklistChanged!(zim, userList, action);
          break;
        case 'onGroupMutedInfoUpdated':
          if (ZIMEventHandler.onGroupMutedInfoUpdated == null) return;
          ZIMGroupMuteInfo muteInfo =
              ZIMGroupMuteInfo.fromMap(map['groupMuteInfo']);
          ZIMGroupOperatedInfo operatedInfo =
              ZIMGroupOperatedInfo.fromMap(map['operatedInfo']);
          String groupID = map['groupID'];
          ZIMEventHandler.onGroupMutedInfoUpdated!(
              zim, muteInfo, operatedInfo, groupID);
          break;
        case 'onGroupVerifyInfoUpdated':
          if (ZIMEventHandler.onGroupVerifyInfoUpdated == null) return;
          ZIMGroupVerifyInfo verifyInfo =
              ZIMGroupVerifyInfo.fromMap(map['verifyInfo']);
          ZIMGroupOperatedInfo operatedInfo =
              ZIMGroupOperatedInfo.fromMap(map['operatedInfo']);
          String groupID = map['groupID'];
          ZIMEventHandler.onGroupVerifyInfoUpdated!(
              zim, verifyInfo, operatedInfo, groupID);
          break;
        case 'onGroupApplicationListChanged':
          if (ZIMEventHandler.onGroupApplicationListChanged == null) return;
          List<ZIMGroupApplicationInfo> applicationList =
              (map['applicationList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMGroupApplicationInfo.fromMap(x))
                  .toList();
          ZIMGroupApplicationListChangeAction action =
              ZIMGroupApplicationListChangeActionExtension
                  .mapValue[map['action']]!;
          ZIMEventHandler.onGroupApplicationListChanged!(
              zim, applicationList, action);
          break;
        case 'onGroupApplicationUpdated':
          if (ZIMEventHandler.onGroupApplicationUpdated == null) return;
          List<ZIMGroupApplicationInfo> applicationList =
              (map['applicationList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMGroupApplicationInfo.fromMap(x))
                  .toList();
          ZIMEventHandler.onGroupApplicationUpdated!(zim, applicationList);
          break;
        case 'onUserRuleUpdated':
          if (ZIMEventHandler.onUserRuleUpdated == null) return;
          ZIMUserRule userRule = ZIMUserRule.fromMap(map['userRule']);
          ZIMEventHandler.onUserRuleUpdated!(zim, userRule);
          break;
        case 'onUserStatusUpdated':
          if (ZIMEventHandler.onUserStatusUpdated == null) return;
          List<ZIMUserStatus> userStatusList = (map['userStatusList'] as List)
              .cast<Map>()
              .map((x) => ZIMUserStatus.fromMap(x))
              .toList();
          ZIMEventHandler.onUserStatusUpdated!(zim, userStatusList);
          break;
        case 'onMessageRepliedCountChanged':
          if (ZIMEventHandler.onMessageRepliedCountChanged == null) return;
          List<ZIMMessageRootRepliedCountInfo> list = (map['infos'] as List)
              .cast<Map>()
              .map((x) => ZIMMessageRootRepliedCountInfo.fromMap(x))
              .toList();
          ZIMEventHandler.onMessageRepliedCountChanged!(zim, list);
          break;
        case 'onMessageRepliedInfoChanged':
          if (ZIMEventHandler.onMessageRepliedInfoChanged == null) return;
          List<ZIMMessage> messageList = (map['messageList'] as List)
              .cast<Map>()
              .map((x) => ZIMDataUtils.parseZIMMessageFromMap(x))
              .toList();
          ZIMEventHandler.onMessageRepliedInfoChanged!(zim, messageList);
          break;
        case 'onMessageEdited':
          if (ZIMEventHandler.onMessageEdited == null) return;
          List<ZIMMessage> messageList = (map['messageList'] as List)
              .cast<Map>()
              .map((x) => ZIMDataUtils.parseZIMMessageFromMap(x))
              .toList();
          ZIMEventHandler.onMessageEdited!(zim, messageList);
          break;
        case 'onMessagePinStatusChanged':
          if (ZIMEventHandler.onMessagePinStatusChanged == null) return;
          List<ZIMMessagePinStatusChangeInfo> changeInfoList =
              (map['changeInfoList'] as List)
                  .cast<Map>()
                  .map((x) => ZIMMessagePinStatusChangeInfo.fromMap(x))
                  .toList();
          ZIMEventHandler.onMessagePinStatusChanged!(zim, changeInfoList);
          break;
        default:
          break;
      }
    } catch (onError, e) {
      ZIMError error = ZIMError(
          code: -1,
          message:
              'dart execption,error:${onError.toString()},stack:${e.toString()}');
      if (ZIMEventHandler.onError == null) return;
      ZIMEventHandler.onError!(zim!, error);
    }
  }
}
