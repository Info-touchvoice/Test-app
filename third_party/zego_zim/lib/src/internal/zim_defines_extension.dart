part of 'package:zego_zim/src/zim_defines.dart';

extension ZIMConnectionStateExtension on ZIMConnectionState {
  static const valueMap = {
    ZIMConnectionState.disconnected: 0,
    ZIMConnectionState.connecting: 1,
    ZIMConnectionState.connected: 2,
    ZIMConnectionState.reconnecting: 3,
  };

  static const mapValue = {
    0: ZIMConnectionState.disconnected,
    1: ZIMConnectionState.connecting,
    2: ZIMConnectionState.connected,
    3: ZIMConnectionState.reconnecting,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMConnectionEventExtension on ZIMConnectionEvent {
  static const valueMap = {
    ZIMConnectionEvent.success: 0,
    ZIMConnectionEvent.activeLogin: 1,
    ZIMConnectionEvent.loginTimeout: 2,
    ZIMConnectionEvent.interrupted: 3,
    ZIMConnectionEvent.kickedOut: 4,
    ZIMConnectionEvent.tokenExpired: 5,
    ZIMConnectionEvent.unregistered: 6,
  };

  static const mapValue = {
    0: ZIMConnectionEvent.success,
    1: ZIMConnectionEvent.activeLogin,
    2: ZIMConnectionEvent.loginTimeout,
    3: ZIMConnectionEvent.interrupted,
    4: ZIMConnectionEvent.kickedOut,
    5: ZIMConnectionEvent.tokenExpired,
    6: ZIMConnectionEvent.unregistered,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMConversationEventExtension on ZIMConversationEvent {
  static const valueMap = {
    ZIMConversationEvent.added: 0,
    ZIMConversationEvent.updated: 1,
    ZIMConversationEvent.disabled: 2,
    ZIMConversationEvent.deleted: 3,
  };

  static const mapValue = {
    0: ZIMConversationEvent.added,
    1: ZIMConversationEvent.updated,
    2: ZIMConversationEvent.disabled,
    3: ZIMConversationEvent.deleted,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMConversationNotificationStatusExtension
    on ZIMConversationNotificationStatus {
  static const valueMap = {
    ZIMConversationNotificationStatus.notify: 1,
    ZIMConversationNotificationStatus.doNotDisturb: 2,
  };

  static const mapValue = {
    1: ZIMConversationNotificationStatus.notify,
    2: ZIMConversationNotificationStatus.doNotDisturb,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMConversationTypeExtension on ZIMConversationType {
  static const valueMap = {
    ZIMConversationType.unknown: -1,
    ZIMConversationType.peer: 0,
    ZIMConversationType.room: 1,
    ZIMConversationType.group: 2,
  };

  static const mapValue = {
    -1: ZIMConversationType.unknown,
    0: ZIMConversationType.peer,
    1: ZIMConversationType.room,
    2: ZIMConversationType.group,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMConversationSyncStateExtension on ZIMConversationSyncState {
  static const valueMap = {
    ZIMConversationSyncState.started: 0,
    ZIMConversationSyncState.finished: 1,
    ZIMConversationSyncState.failed: 2,
  };

  static const mapValue = {
    0: ZIMConversationSyncState.started,
    1: ZIMConversationSyncState.finished,
    2: ZIMConversationSyncState.failed,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMConversationPinnedFilterExtension on ZIMConversationPinnedFilter {
  static const valueMap = {
    ZIMConversationPinnedFilter.all: 0,
    ZIMConversationPinnedFilter.onlyPinned: 1,
    ZIMConversationPinnedFilter.onlyUnpinned: 2,
  };

  static const mapValue = {
    0: ZIMConversationPinnedFilter.all,
    1: ZIMConversationPinnedFilter.onlyPinned,
    2: ZIMConversationPinnedFilter.onlyUnpinned,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMConversationSearchModeExtension on ZIMConversationSearchMode {
  static const valueMap = {
    ZIMConversationSearchMode.matchMessage: 0,
    ZIMConversationSearchMode.matchConversationName: 1,
  };

  static const mapValue = {
    0: ZIMConversationSearchMode.matchMessage,
    1: ZIMConversationSearchMode.matchConversationName,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMediaFileTypeExtension on ZIMMediaFileType {
  static const valueMap = {
    ZIMMediaFileType.originalFile: 1,
    ZIMMediaFileType.largeImage: 2,
    ZIMMediaFileType.thumbnail: 3,
    ZIMMediaFileType.videoFirstFrame: 4,
  };

  static const mapValue = {
    1: ZIMMediaFileType.originalFile,
    2: ZIMMediaFileType.largeImage,
    3: ZIMMediaFileType.thumbnail,
    4: ZIMMediaFileType.videoFirstFrame,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageDirectionExtension on ZIMMessageDirection {
  static const valueMap = {
    ZIMMessageDirection.send: 0,
    ZIMMessageDirection.receive: 1,
  };

  static const mapValue = {
    0: ZIMMessageDirection.send,
    1: ZIMMessageDirection.receive,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageOrderExtension on ZIMMessageOrder {
  static const valueMap = {
    ZIMMessageOrder.descending: 0,
    ZIMMessageOrder.ascending: 1,
  };

  static const mapValue = {
    0: ZIMMessageOrder.descending,
    1: ZIMMessageOrder.ascending,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessagePriorityExtension on ZIMMessagePriority {
  static const valueMap = {
    ZIMMessagePriority.low: 1,
    ZIMMessagePriority.medium: 2,
    ZIMMessagePriority.high: 3,
  };

  static const mapValue = {
    1: ZIMMessagePriority.low,
    2: ZIMMessagePriority.medium,
    3: ZIMMessagePriority.high,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageQueryModeExtension on ZIMMessageQueryMode {
  static const valueMap = {
    ZIMMessageQueryMode.general: 0,
    ZIMMessageQueryMode.preferServer: 1,
    ZIMMessageQueryMode.onlyLocal: 2,
  };

  static const mapValue = {
    0: ZIMMessageQueryMode.general,
    1: ZIMMessageQueryMode.preferServer,
    2: ZIMMessageQueryMode.onlyLocal,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageReceiptStatusExtension on ZIMMessageReceiptStatus {
  static const valueMap = {
    ZIMMessageReceiptStatus.unknown: -1,
    ZIMMessageReceiptStatus.none: 0,
    ZIMMessageReceiptStatus.processing: 1,
    ZIMMessageReceiptStatus.done: 2,
    ZIMMessageReceiptStatus.expired: 3,
    ZIMMessageReceiptStatus.failed: 4,
  };

  static const mapValue = {
    -1: ZIMMessageReceiptStatus.unknown,
    0: ZIMMessageReceiptStatus.none,
    1: ZIMMessageReceiptStatus.processing,
    2: ZIMMessageReceiptStatus.done,
    3: ZIMMessageReceiptStatus.expired,
    4: ZIMMessageReceiptStatus.failed,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageRevokeStatusExtension on ZIMMessageRevokeStatus {
  static const valueMap = {
    ZIMMessageRevokeStatus.unknown: -1,
    ZIMMessageRevokeStatus.selfRevoke: 0,
    ZIMMessageRevokeStatus.systemRevoke: 1,
    ZIMMessageRevokeStatus.serviceAPIRevoke: 2,
    ZIMMessageRevokeStatus.groupAdminRevoke: 3,
    ZIMMessageRevokeStatus.groupOwnerRevoke: 4,
    ZIMMessageRevokeStatus.auditRejectRevoke: 5,
  };

  static const mapValue = {
    -1: ZIMMessageRevokeStatus.unknown,
    0: ZIMMessageRevokeStatus.selfRevoke,
    1: ZIMMessageRevokeStatus.systemRevoke,
    2: ZIMMessageRevokeStatus.serviceAPIRevoke,
    3: ZIMMessageRevokeStatus.groupAdminRevoke,
    4: ZIMMessageRevokeStatus.groupOwnerRevoke,
    5: ZIMMessageRevokeStatus.auditRejectRevoke,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageSentStatusExtension on ZIMMessageSentStatus {
  static const valueMap = {
    ZIMMessageSentStatus.sending: 0,
    ZIMMessageSentStatus.success: 1,
    ZIMMessageSentStatus.failed: 2,
  };

  static const mapValue = {
    0: ZIMMessageSentStatus.sending,
    1: ZIMMessageSentStatus.success,
    2: ZIMMessageSentStatus.failed,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageTypeExtension on ZIMMessageType {
  static const valueMap = {
    ZIMMessageType.unknown: 0,
    ZIMMessageType.text: 1,
    ZIMMessageType.command: 2,
    ZIMMessageType.multiple: 10,
    ZIMMessageType.image: 11,
    ZIMMessageType.file: 12,
    ZIMMessageType.audio: 13,
    ZIMMessageType.video: 14,
    ZIMMessageType.barrage: 20,
    ZIMMessageType.system: 30,
    ZIMMessageType.revoke: 31,
    ZIMMessageType.tips: 32,
    ZIMMessageType.combine: 100,
    ZIMMessageType.custom: 200,
  };

  static const mapValue = {
    0: ZIMMessageType.unknown,
    1: ZIMMessageType.text,
    2: ZIMMessageType.command,
    10: ZIMMessageType.multiple,
    11: ZIMMessageType.image,
    12: ZIMMessageType.file,
    13: ZIMMessageType.audio,
    14: ZIMMessageType.video,
    20: ZIMMessageType.barrage,
    30: ZIMMessageType.system,
    31: ZIMMessageType.revoke,
    32: ZIMMessageType.tips,
    100: ZIMMessageType.combine,
    200: ZIMMessageType.custom,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMRevokeTypeExtension on ZIMRevokeType {
  static const valueMap = {
    ZIMRevokeType.unknown: -1,
    ZIMRevokeType.twoWay: 0,
    ZIMRevokeType.oneWay: 1,
  };

  static const mapValue = {
    -1: ZIMRevokeType.unknown,
    0: ZIMRevokeType.twoWay,
    1: ZIMRevokeType.oneWay,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMTipsMessageEventExtension on ZIMTipsMessageEvent {
  static const valueMap = {
    ZIMTipsMessageEvent.unknown: 0,
    ZIMTipsMessageEvent.groupCreated: 1,
    ZIMTipsMessageEvent.groupDismissed: 2,
    ZIMTipsMessageEvent.groupJoined: 3,
    ZIMTipsMessageEvent.groupInvited: 4,
    ZIMTipsMessageEvent.groupLeft: 5,
    ZIMTipsMessageEvent.groupKickedOut: 6,
    ZIMTipsMessageEvent.groupInfoChanged: 7,
    ZIMTipsMessageEvent.groupMemberInfoChanged: 8,
    ZIMTipsMessageEvent.groupMessagePinned: 9,
  };

  static const mapValue = {
    0: ZIMTipsMessageEvent.unknown,
    1: ZIMTipsMessageEvent.groupCreated,
    2: ZIMTipsMessageEvent.groupDismissed,
    3: ZIMTipsMessageEvent.groupJoined,
    4: ZIMTipsMessageEvent.groupInvited,
    5: ZIMTipsMessageEvent.groupLeft,
    6: ZIMTipsMessageEvent.groupKickedOut,
    7: ZIMTipsMessageEvent.groupInfoChanged,
    8: ZIMTipsMessageEvent.groupMemberInfoChanged,
    9: ZIMTipsMessageEvent.groupMessagePinned,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMTipsMessageChangeInfoTypeExtension
    on ZIMTipsMessageChangeInfoType {
  static const valueMap = {
    ZIMTipsMessageChangeInfoType.unknown: 0,
    ZIMTipsMessageChangeInfoType.groupDataChanged: 1,
    ZIMTipsMessageChangeInfoType.groupNoticeChanged: 2,
    ZIMTipsMessageChangeInfoType.groupNameChanged: 3,
    ZIMTipsMessageChangeInfoType.groupAvatarUrlChanged: 4,
    ZIMTipsMessageChangeInfoType.groupMuteChanged: 5,
    ZIMTipsMessageChangeInfoType.groupOwnerTransferred: 10,
    ZIMTipsMessageChangeInfoType.groupMemberRoleChanged: 11,
    ZIMTipsMessageChangeInfoType.groupMemberMuteChanged: 12,
    ZIMTipsMessageChangeInfoType.groupMessagePinInfoChanged: 21,
  };

  static const mapValue = {
    0: ZIMTipsMessageChangeInfoType.unknown,
    1: ZIMTipsMessageChangeInfoType.groupDataChanged,
    2: ZIMTipsMessageChangeInfoType.groupNoticeChanged,
    3: ZIMTipsMessageChangeInfoType.groupNameChanged,
    4: ZIMTipsMessageChangeInfoType.groupAvatarUrlChanged,
    5: ZIMTipsMessageChangeInfoType.groupMuteChanged,
    10: ZIMTipsMessageChangeInfoType.groupOwnerTransferred,
    11: ZIMTipsMessageChangeInfoType.groupMemberRoleChanged,
    12: ZIMTipsMessageChangeInfoType.groupMemberMuteChanged,
    21: ZIMTipsMessageChangeInfoType.groupMessagePinInfoChanged,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageMentionedTypeExtension on ZIMMessageMentionedType {
  static const valueMap = {
    ZIMMessageMentionedType.unknown: 0,
    ZIMMessageMentionedType.mentionMe: 1,
    ZIMMessageMentionedType.mentionAll: 2,
    ZIMMessageMentionedType.mentionAllAndMe: 3,
  };

  static const mapValue = {
    0: ZIMMessageMentionedType.unknown,
    1: ZIMMessageMentionedType.mentionMe,
    2: ZIMMessageMentionedType.mentionAll,
    3: ZIMMessageMentionedType.mentionAllAndMe,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageDeleteTypeExtension on ZIMMessageDeleteType {
  static const valueMap = {
    ZIMMessageDeleteType.messageListDeleted: 0,
    ZIMMessageDeleteType.conversationAllMessagesDeleted: 1,
    ZIMMessageDeleteType.allConversationMessagesDeleted: 2,
  };

  static const mapValue = {
    0: ZIMMessageDeleteType.messageListDeleted,
    1: ZIMMessageDeleteType.conversationAllMessagesDeleted,
    2: ZIMMessageDeleteType.allConversationMessagesDeleted,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageRepliedInfoStateExtension on ZIMMessageRepliedInfoState {
  static const valueMap = {
    ZIMMessageRepliedInfoState.normal: 0,
    ZIMMessageRepliedInfoState.deleted: 1,
    ZIMMessageRepliedInfoState.notFound: 2,
  };

  static const mapValue = {
    0: ZIMMessageRepliedInfoState.normal,
    1: ZIMMessageRepliedInfoState.deleted,
    2: ZIMMessageRepliedInfoState.notFound,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessagePinStatusExtension on ZIMMessagePinStatus {
  static const valueMap = {
    ZIMMessagePinStatus.notPinned: 0,
    ZIMMessagePinStatus.pinned: 1,
    ZIMMessagePinStatus.updated: 2,
  };

  static const mapValue = {
    0: ZIMMessagePinStatus.notPinned,
    1: ZIMMessagePinStatus.pinned,
    2: ZIMMessagePinStatus.updated,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMMessageReactionUserChangeActionExtension
    on ZIMMessageReactionUserChangeAction {
  static const valueMap = {
    ZIMMessageReactionUserChangeAction.added: 0,
    ZIMMessageReactionUserChangeAction.deleted: 1,
  };

  static const mapValue = {
    0: ZIMMessageReactionUserChangeAction.added,
    1: ZIMMessageReactionUserChangeAction.deleted,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMRoomEventExtension on ZIMRoomEvent {
  static const valueMap = {
    ZIMRoomEvent.success: 0,
    ZIMRoomEvent.interrupted: 1,
    ZIMRoomEvent.disconnected: 2,
    ZIMRoomEvent.roomNotExist: 3,
    ZIMRoomEvent.activeCreate: 4,
    ZIMRoomEvent.createFailed: 5,
    ZIMRoomEvent.activeEnter: 6,
    ZIMRoomEvent.enterFailed: 7,
    ZIMRoomEvent.kickedOut: 8,
    ZIMRoomEvent.connectTimeout: 9,
    ZIMRoomEvent.kickedOutByOtherDevice: 10,
    ZIMRoomEvent.activeSwitch: 11,
    ZIMRoomEvent.switchFailed: 12,
  };

  static const mapValue = {
    0: ZIMRoomEvent.success,
    1: ZIMRoomEvent.interrupted,
    2: ZIMRoomEvent.disconnected,
    3: ZIMRoomEvent.roomNotExist,
    4: ZIMRoomEvent.activeCreate,
    5: ZIMRoomEvent.createFailed,
    6: ZIMRoomEvent.activeEnter,
    7: ZIMRoomEvent.enterFailed,
    8: ZIMRoomEvent.kickedOut,
    9: ZIMRoomEvent.connectTimeout,
    10: ZIMRoomEvent.kickedOutByOtherDevice,
    11: ZIMRoomEvent.activeSwitch,
    12: ZIMRoomEvent.switchFailed,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMRoomStateExtension on ZIMRoomState {
  static const valueMap = {
    ZIMRoomState.disconnected: 0,
    ZIMRoomState.connecting: 1,
    ZIMRoomState.connected: 2,
  };

  static const mapValue = {
    0: ZIMRoomState.disconnected,
    1: ZIMRoomState.connecting,
    2: ZIMRoomState.connected,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMRoomAttributesUpdateActionExtension
    on ZIMRoomAttributesUpdateAction {
  static const valueMap = {
    ZIMRoomAttributesUpdateAction.set: 0,
    ZIMRoomAttributesUpdateAction.delete: 1,
  };

  static const mapValue = {
    0: ZIMRoomAttributesUpdateAction.set,
    1: ZIMRoomAttributesUpdateAction.delete,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupStateExtension on ZIMGroupState {
  static const valueMap = {ZIMGroupState.quit: 0, ZIMGroupState.enter: 1};

  static const mapValue = {0: ZIMGroupState.quit, 1: ZIMGroupState.enter};

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupEventExtension on ZIMGroupEvent {
  static const valueMap = {
    ZIMGroupEvent.created: 1,
    ZIMGroupEvent.dismissed: 2,
    ZIMGroupEvent.joined: 3,
    ZIMGroupEvent.invited: 4,
    ZIMGroupEvent.left: 5,
    ZIMGroupEvent.kickedout: 6,
  };

  static const mapValue = {
    1: ZIMGroupEvent.created,
    2: ZIMGroupEvent.dismissed,
    3: ZIMGroupEvent.joined,
    4: ZIMGroupEvent.invited,
    5: ZIMGroupEvent.left,
    6: ZIMGroupEvent.kickedout,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupMemberEventExtension on ZIMGroupMemberEvent {
  static const valueMap = {
    ZIMGroupMemberEvent.joined: 1,
    ZIMGroupMemberEvent.left: 2,
    ZIMGroupMemberEvent.kickedout: 4,
    ZIMGroupMemberEvent.invited: 5,
  };

  static const mapValue = {
    1: ZIMGroupMemberEvent.joined,
    2: ZIMGroupMemberEvent.left,
    4: ZIMGroupMemberEvent.kickedout,
    5: ZIMGroupMemberEvent.invited,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupMemberStateExtension on ZIMGroupMemberState {
  static const valueMap = {
    ZIMGroupMemberState.quit: 0,
    ZIMGroupMemberState.enter: 1,
  };

  static const mapValue = {
    0: ZIMGroupMemberState.quit,
    1: ZIMGroupMemberState.enter,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupMessageNotificationStatusExtension
    on ZIMGroupMessageNotificationStatus {
  static const valueMap = {
    ZIMGroupMessageNotificationStatus.notify: 1,
    ZIMGroupMessageNotificationStatus.doNotDisturb: 2,
  };

  static const mapValue = {
    1: ZIMGroupMessageNotificationStatus.notify,
    2: ZIMGroupMessageNotificationStatus.doNotDisturb,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupAttributesUpdateActionExtension
    on ZIMGroupAttributesUpdateAction {
  static const valueMap = {
    ZIMGroupAttributesUpdateAction.set: 0,
    ZIMGroupAttributesUpdateAction.delete: 1,
  };

  static const mapValue = {
    0: ZIMGroupAttributesUpdateAction.set,
    1: ZIMGroupAttributesUpdateAction.delete,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupMuteModeExtension on ZIMGroupMuteMode {
  static const valueMap = {
    ZIMGroupMuteMode.none: 0,
    ZIMGroupMuteMode.normal: 1,
    ZIMGroupMuteMode.all: 2,
    ZIMGroupMuteMode.custom: 3,
  };

  static const mapValue = {
    0: ZIMGroupMuteMode.none,
    1: ZIMGroupMuteMode.normal,
    2: ZIMGroupMuteMode.all,
    3: ZIMGroupMuteMode.custom,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupJoinModeExtension on ZIMGroupJoinMode {
  static const valueMap = {
    ZIMGroupJoinMode.any: 0,
    ZIMGroupJoinMode.auth: 1,
    ZIMGroupJoinMode.forbid: 2,
  };

  static const mapValue = {
    0: ZIMGroupJoinMode.any,
    1: ZIMGroupJoinMode.auth,
    2: ZIMGroupJoinMode.forbid,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupInviteModeExtension on ZIMGroupInviteMode {
  static const valueMap = {
    ZIMGroupInviteMode.any: 0,
    ZIMGroupInviteMode.admin: 1,
  };

  static const mapValue = {
    0: ZIMGroupInviteMode.any,
    1: ZIMGroupInviteMode.admin,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupBeInviteModeExtension on ZIMGroupBeInviteMode {
  static const valueMap = {
    ZIMGroupBeInviteMode.none: 0,
    ZIMGroupBeInviteMode.auth: 1,
  };

  static const mapValue = {
    0: ZIMGroupBeInviteMode.none,
    1: ZIMGroupBeInviteMode.auth,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupEnterTypeExtension on ZIMGroupEnterType {
  static const valueMap = {
    ZIMGroupEnterType.unknown: 0,
    ZIMGroupEnterType.created: 1,
    ZIMGroupEnterType.joinApply: 2,
    ZIMGroupEnterType.joined: 3,
    ZIMGroupEnterType.invited: 4,
    ZIMGroupEnterType.inviteApply: 5,
  };

  static const mapValue = {
    0: ZIMGroupEnterType.unknown,
    1: ZIMGroupEnterType.created,
    2: ZIMGroupEnterType.joinApply,
    3: ZIMGroupEnterType.joined,
    4: ZIMGroupEnterType.invited,
    5: ZIMGroupEnterType.inviteApply,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupApplicationTypeExtension on ZIMGroupApplicationType {
  static const valueMap = {
    ZIMGroupApplicationType.unknown: -1,
    ZIMGroupApplicationType.none: 0,
    ZIMGroupApplicationType.join: 1,
    ZIMGroupApplicationType.invite: 2,
    ZIMGroupApplicationType.beInvite: 3,
  };

  static const mapValue = {
    -1: ZIMGroupApplicationType.unknown,
    0: ZIMGroupApplicationType.none,
    1: ZIMGroupApplicationType.join,
    2: ZIMGroupApplicationType.invite,
    3: ZIMGroupApplicationType.beInvite,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupApplicationStateExtension on ZIMGroupApplicationState {
  static const valueMap = {
    ZIMGroupApplicationState.unknown: -1,
    ZIMGroupApplicationState.waiting: 1,
    ZIMGroupApplicationState.accepted: 2,
    ZIMGroupApplicationState.rejected: 3,
    ZIMGroupApplicationState.expired: 4,
    ZIMGroupApplicationState.disabled: 5,
  };

  static const mapValue = {
    -1: ZIMGroupApplicationState.unknown,
    1: ZIMGroupApplicationState.waiting,
    2: ZIMGroupApplicationState.accepted,
    3: ZIMGroupApplicationState.rejected,
    4: ZIMGroupApplicationState.expired,
    5: ZIMGroupApplicationState.disabled,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGroupApplicationListChangeActionExtension
    on ZIMGroupApplicationListChangeAction {
  static const valueMap = {ZIMGroupApplicationListChangeAction.added: 0};

  static const mapValue = {0: ZIMGroupApplicationListChangeAction.added};

  int get value => valueMap[this] ?? -1;
}

extension ZIMCallInvitationModeExtension on ZIMCallInvitationMode {
  static const valueMap = {
    ZIMCallInvitationMode.unknown: -1,
    ZIMCallInvitationMode.general: 0,
    ZIMCallInvitationMode.advanced: 1,
  };

  static const mapValue = {
    -1: ZIMCallInvitationMode.unknown,
    0: ZIMCallInvitationMode.general,
    1: ZIMCallInvitationMode.advanced,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMCallStateExtension on ZIMCallState {
  static const valueMap = {
    ZIMCallState.unknown: -1,
    ZIMCallState.started: 1,
    ZIMCallState.ended: 2,
  };

  static const mapValue = {
    -1: ZIMCallState.unknown,
    1: ZIMCallState.started,
    2: ZIMCallState.ended,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMCallUserStateExtension on ZIMCallUserState {
  static const valueMap = {
    ZIMCallUserState.unknown: -1,
    ZIMCallUserState.inviting: 0,
    ZIMCallUserState.accepted: 1,
    ZIMCallUserState.rejected: 2,
    ZIMCallUserState.cancelled: 3,
    ZIMCallUserState.offline: 4,
    ZIMCallUserState.received: 5,
    ZIMCallUserState.timeout: 6,
    ZIMCallUserState.quited: 7,
    ZIMCallUserState.ended: 8,
    ZIMCallUserState.notYetReceived: 9,
    ZIMCallUserState.beCancelled: 10,
  };

  static const mapValue = {
    -1: ZIMCallUserState.unknown,
    0: ZIMCallUserState.inviting,
    1: ZIMCallUserState.accepted,
    2: ZIMCallUserState.rejected,
    3: ZIMCallUserState.cancelled,
    4: ZIMCallUserState.offline,
    5: ZIMCallUserState.received,
    6: ZIMCallUserState.timeout,
    7: ZIMCallUserState.quited,
    8: ZIMCallUserState.ended,
    9: ZIMCallUserState.notYetReceived,
    10: ZIMCallUserState.beCancelled,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMFriendListChangeActionExtension on ZIMFriendListChangeAction {
  static const valueMap = {
    ZIMFriendListChangeAction.added: 0,
    ZIMFriendListChangeAction.deleted: 1,
  };

  static const mapValue = {
    0: ZIMFriendListChangeAction.added,
    1: ZIMFriendListChangeAction.deleted,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMFriendApplicationListChangeActionExtension
    on ZIMFriendApplicationListChangeAction {
  static const valueMap = {
    ZIMFriendApplicationListChangeAction.added: 0,
    ZIMFriendApplicationListChangeAction.deleted: 1,
  };

  static const mapValue = {
    0: ZIMFriendApplicationListChangeAction.added,
    1: ZIMFriendApplicationListChangeAction.deleted,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMFriendApplicationTypeExtension on ZIMFriendApplicationType {
  static const valueMap = {
    ZIMFriendApplicationType.unknown: -1,
    ZIMFriendApplicationType.none: 0,
    ZIMFriendApplicationType.received: 1,
    ZIMFriendApplicationType.sent: 2,
    ZIMFriendApplicationType.both: 3,
  };

  static const mapValue = {
    -1: ZIMFriendApplicationType.unknown,
    0: ZIMFriendApplicationType.none,
    1: ZIMFriendApplicationType.received,
    2: ZIMFriendApplicationType.sent,
    3: ZIMFriendApplicationType.both,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMFriendApplicationStateExtension on ZIMFriendApplicationState {
  static const valueMap = {
    ZIMFriendApplicationState.unknown: -1,
    ZIMFriendApplicationState.waiting: 1,
    ZIMFriendApplicationState.accepted: 2,
    ZIMFriendApplicationState.rejected: 3,
    ZIMFriendApplicationState.expired: 4,
    ZIMFriendApplicationState.disabled: 5,
  };

  static const mapValue = {
    -1: ZIMFriendApplicationState.unknown,
    1: ZIMFriendApplicationState.waiting,
    2: ZIMFriendApplicationState.accepted,
    3: ZIMFriendApplicationState.rejected,
    4: ZIMFriendApplicationState.expired,
    5: ZIMFriendApplicationState.disabled,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMFriendRelationCheckTypeExtension on ZIMFriendRelationCheckType {
  static const valueMap = {
    ZIMFriendRelationCheckType.both: 0,
    ZIMFriendRelationCheckType.single: 1,
  };

  static const mapValue = {
    0: ZIMFriendRelationCheckType.both,
    1: ZIMFriendRelationCheckType.single,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMFriendDeleteTypeExtension on ZIMFriendDeleteType {
  static const valueMap = {
    ZIMFriendDeleteType.both: 0,
    ZIMFriendDeleteType.single: 1,
  };

  static const mapValue = {
    0: ZIMFriendDeleteType.both,
    1: ZIMFriendDeleteType.single,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMUserRelationTypeExtension on ZIMUserRelationType {
  static const valueMap = {
    ZIMUserRelationType.unknown: 0,
    ZIMUserRelationType.singleNo: 1,
    ZIMUserRelationType.singleHave: 2,
    ZIMUserRelationType.bothAllNo: 3,
    ZIMUserRelationType.bothSelfHave: 4,
    ZIMUserRelationType.bothOtherHave: 5,
    ZIMUserRelationType.bothAllHave: 6,
  };

  static const mapValue = {
    0: ZIMUserRelationType.unknown,
    1: ZIMUserRelationType.singleNo,
    2: ZIMUserRelationType.singleHave,
    3: ZIMUserRelationType.bothAllNo,
    4: ZIMUserRelationType.bothSelfHave,
    5: ZIMUserRelationType.bothOtherHave,
    6: ZIMUserRelationType.bothAllHave,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMBlacklistChangeActionExtension on ZIMBlacklistChangeAction {
  static const valueMap = {
    ZIMBlacklistChangeAction.added: 0,
    ZIMBlacklistChangeAction.removed: 1,
  };

  static const mapValue = {
    0: ZIMBlacklistChangeAction.added,
    1: ZIMBlacklistChangeAction.removed,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMCXHandleTypeExtension on ZIMCXHandleType {
  static const valueMap = {
    ZIMCXHandleType.generic: 1,
    ZIMCXHandleType.phoneNumber: 2,
    ZIMCXHandleType.emailAddress: 3,
  };

  static const mapValue = {
    1: ZIMCXHandleType.generic,
    2: ZIMCXHandleType.phoneNumber,
    3: ZIMCXHandleType.emailAddress,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMGeofencingTypeExtension on ZIMGeofencingType {
  static const valueMap = {
    ZIMGeofencingType.none: 0,
    ZIMGeofencingType.include: 1,
    ZIMGeofencingType.exclude: 2,
  };

  static const mapValue = {
    0: ZIMGeofencingType.none,
    1: ZIMGeofencingType.include,
    2: ZIMGeofencingType.exclude,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMPlatformTypeExtension on ZIMPlatformType {
  static const valueMap = {
    ZIMPlatformType.win: 1,
    ZIMPlatformType.iPhoneOS: 2,
    ZIMPlatformType.android: 3,
    ZIMPlatformType.macOS: 4,
    ZIMPlatformType.linux: 5,
    ZIMPlatformType.web: 6,
    ZIMPlatformType.miniProgram: 7,
    ZIMPlatformType.iPadOS: 9,
    ZIMPlatformType.ohos: 10,
    ZIMPlatformType.unknown: 32,
  };

  static const mapValue = {
    1: ZIMPlatformType.win,
    2: ZIMPlatformType.iPhoneOS,
    3: ZIMPlatformType.android,
    4: ZIMPlatformType.macOS,
    5: ZIMPlatformType.linux,
    6: ZIMPlatformType.web,
    7: ZIMPlatformType.miniProgram,
    9: ZIMPlatformType.iPadOS,
    10: ZIMPlatformType.ohos,
    32: ZIMPlatformType.unknown,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMUserOnlineStatusExtension on ZIMUserOnlineStatus {
  static const valueMap = {
    ZIMUserOnlineStatus.online: 0,
    ZIMUserOnlineStatus.offline: 1,
    ZIMUserOnlineStatus.logout: 2,
    ZIMUserOnlineStatus.unknown: 99,
  };

  static const mapValue = {
    0: ZIMUserOnlineStatus.online,
    1: ZIMUserOnlineStatus.offline,
    2: ZIMUserOnlineStatus.logout,
    99: ZIMUserOnlineStatus.unknown,
  };

  int get value => valueMap[this] ?? -1;
}

extension ZIMLogUploadedResultExtension on ZIMLogUploadedResult {
  static String get callbackMethodName {
    return 'onLogUploaded';
  }
}

extension ZIMLoggedInResultExtension on ZIMLoggedInResult {
  static String get callbackMethodName {
    return 'onLoggedIn';
  }
}

extension ZIMTokenRenewedResultExtension on ZIMTokenRenewedResult {
  static String get callbackMethodName {
    return 'onTokenRenewed';
  }
}

extension ZIMUserNameUpdatedResultExtension on ZIMUserNameUpdatedResult {
  static String get callbackMethodName {
    return 'onUserNameUpdated';
  }
}

extension ZIMUserAvatarUrlUpdatedResultExtension
    on ZIMUserAvatarUrlUpdatedResult {
  static String get callbackMethodName {
    return 'onUserAvatarUrlUpdated';
  }
}

extension ZIMUserExtendedDataUpdatedResultExtension
    on ZIMUserExtendedDataUpdatedResult {
  static String get callbackMethodName {
    return 'onUserExtendedDataUpdated';
  }
}

extension ZIMUserCustomStatusUpdatedResultExtension
    on ZIMUserCustomStatusUpdatedResult {
  static String get callbackMethodName {
    return 'onUserCustomStatusUpdated';
  }
}

extension ZIMUsersInfoQueriedResultExtension on ZIMUsersInfoQueriedResult {
  static String get callbackMethodName {
    return 'onUsersInfoQueried';
  }
}

extension ZIMUserOfflinePushRuleUpdatedResultExtension
    on ZIMUserOfflinePushRuleUpdatedResult {
  static String get callbackMethodName {
    return 'onUserOfflinePushRuleUpdated';
  }
}

extension ZIMSelfUserInfoQueriedResultExtension
    on ZIMSelfUserInfoQueriedResult {
  static String get callbackMethodName {
    return 'onSelfUserInfoQueried';
  }
}

extension ZIMUsersStatusQueriedResultExtension on ZIMUsersStatusQueriedResult {
  static String get callbackMethodName {
    return 'onUsersStatusQueried';
  }
}

extension ZIMUsersStatusSubscribedResultExtension
    on ZIMUsersStatusSubscribedResult {
  static String get callbackMethodName {
    return 'onUsersStatusSubscribed';
  }
}

extension ZIMUsersStatusUnsubscribedResultExtension
    on ZIMUsersStatusUnsubscribedResult {
  static String get callbackMethodName {
    return 'onUsersStatusUnsubscribed';
  }
}

extension ZIMSubscribedUserStatusListQueriedResultExtension
    on ZIMSubscribedUserStatusListQueriedResult {
  static String get callbackMethodName {
    return 'onSubscribedUserStatusListQueried';
  }
}

extension ZIMConversationQueriedResultExtension
    on ZIMConversationQueriedResult {
  static String get callbackMethodName {
    return 'onConversationQueried';
  }
}

extension ZIMConversationListQueriedResultExtension
    on ZIMConversationListQueriedResult {
  static String get callbackMethodName {
    return 'onConversationListQueried';
  }
}

extension ZIMConversationTotalUnreadMessageCountQueriedResultExtension
    on ZIMConversationTotalUnreadMessageCountQueriedResult {
  static String get callbackMethodName {
    return 'onConversationTotalUnreadMessageCountQueried';
  }
}

extension ZIMConversationDeletedResultExtension
    on ZIMConversationDeletedResult {
  static String get callbackMethodName {
    return 'onConversationDeleted';
  }
}

extension ZIMConversationsAllDeletedResultExtension
    on ZIMConversationsAllDeletedResult {
  static String get callbackMethodName {
    return 'onConversationsAllDeleted';
  }
}

extension ZIMConversationUnreadMessageCountClearedResultExtension
    on ZIMConversationUnreadMessageCountClearedResult {
  static String get callbackMethodName {
    return 'onConversationUnreadMessageCountCleared';
  }
}

extension ZIMConversationTotalUnreadMessageCountClearedResultExtension
    on ZIMConversationTotalUnreadMessageCountClearedResult {
  static String get callbackMethodName {
    return 'onConversationTotalUnreadMessageCountCleared';
  }
}

extension ZIMConversationNotificationStatusSetResultExtension
    on ZIMConversationNotificationStatusSetResult {
  static String get callbackMethodName {
    return 'onConversationNotificationStatusSet';
  }
}

extension ZIMConversationMessageReceiptReadSentResultExtension
    on ZIMConversationMessageReceiptReadSentResult {
  static String get callbackMethodName {
    return 'onConversationMessageReceiptReadSent';
  }
}

extension ZIMConversationPinnedStateUpdatedResultExtension
    on ZIMConversationPinnedStateUpdatedResult {
  static String get callbackMethodName {
    return 'onConversationPinnedStateUpdated';
  }
}

extension ZIMConversationPinnedListQueriedResultExtension
    on ZIMConversationPinnedListQueriedResult {
  static String get callbackMethodName {
    return 'onConversationPinnedListQueried';
  }
}

extension ZIMConversationDraftSetResultExtension
    on ZIMConversationDraftSetResult {
  static String get callbackMethodName {
    return 'onConversationDraftSet';
  }
}

extension ZIMConversationMarkSetResultExtension
    on ZIMConversationMarkSetResult {
  static String get callbackMethodName {
    return 'onConversationMarkSet';
  }
}

extension ZIMConversationsSearchedResultExtension
    on ZIMConversationsSearchedResult {
  static String get callbackMethodName {
    return 'onConversationsSearched';
  }
}

extension ZIMMessageSentResultExtension on ZIMMessageSentResult {
  static String get callbackMethodName {
    return 'onMessageSent';
  }
}

extension ZIMMessageQueriedResultExtension on ZIMMessageQueriedResult {
  static String get callbackMethodName {
    return 'onMessageQueried';
  }
}

extension ZIMMessageDeletedResultExtension on ZIMMessageDeletedResult {
  static String get callbackMethodName {
    return 'onMessageDeleted';
  }
}

extension ZIMConversationMessagesAllDeletedResultExtension
    on ZIMConversationMessagesAllDeletedResult {
  static String get callbackMethodName {
    return 'onConversationMessagesAllDeleted';
  }
}

extension ZIMMessageRevokedResultExtension on ZIMMessageRevokedResult {
  static String get callbackMethodName {
    return 'onMessageRevoked';
  }
}

extension ZIMMessageInsertedResultExtension on ZIMMessageInsertedResult {
  static String get callbackMethodName {
    return 'onMessageInserted';
  }
}

extension ZIMMessageLocalExtendedDataUpdatedResultExtension
    on ZIMMessageLocalExtendedDataUpdatedResult {
  static String get callbackMethodName {
    return 'onMessageLocalExtendedDataUpdated';
  }
}

extension ZIMMessageReceiptsReadSentResultExtension
    on ZIMMessageReceiptsReadSentResult {
  static String get callbackMethodName {
    return 'onMessageReceiptsReadSent';
  }
}

extension ZIMMessageReceiptsInfoQueriedResultExtension
    on ZIMMessageReceiptsInfoQueriedResult {
  static String get callbackMethodName {
    return 'onMessageReceiptsInfoQueried';
  }
}

extension ZIMMediaDownloadedResultExtension on ZIMMediaDownloadedResult {
  static String get callbackMethodName {
    return 'onMediaDownloaded';
  }
}

extension ZIMMessagesSearchedResultExtension on ZIMMessagesSearchedResult {
  static String get callbackMethodName {
    return 'onMessagesSearched';
  }
}

extension ZIMMessagesGlobalSearchedResultExtension
    on ZIMMessagesGlobalSearchedResult {
  static String get callbackMethodName {
    return 'onMessagesGlobalSearched';
  }
}

extension ZIMMessageReactionAddedResultExtension
    on ZIMMessageReactionAddedResult {
  static String get callbackMethodName {
    return 'onMessageReactionAdded';
  }
}

extension ZIMMessageReactionDeletedResultExtension
    on ZIMMessageReactionDeletedResult {
  static String get callbackMethodName {
    return 'onMessageReactionDeleted';
  }
}

extension ZIMMessageReactionUserListQueriedResultExtension
    on ZIMMessageReactionUserListQueriedResult {
  static String get callbackMethodName {
    return 'onMessageReactionUserListQueried';
  }
}

extension ZIMCombineMessageDetailQueriedResultExtension
    on ZIMCombineMessageDetailQueriedResult {
  static String get callbackMethodName {
    return 'onCombineMessageDetailQueried';
  }
}

extension ZIMMessageRepliedListQueriedResultExtension
    on ZIMMessageRepliedListQueriedResult {
  static String get callbackMethodName {
    return 'onMessageRepliedListQueried';
  }
}

extension ZIMMessageEditedResultExtension on ZIMMessageEditedResult {
  static String get callbackMethodName {
    return 'onMessageEdited';
  }
}

extension ZIMSendingMessageCancelledResultExtension
    on ZIMSendingMessageCancelledResult {
  static String get callbackMethodName {
    return 'onSendingMessageCancelled';
  }
}

extension ZIMMessagePinnedResultExtension on ZIMMessagePinnedResult {
  static String get callbackMethodName {
    return 'onMessagePinned';
  }
}

extension ZIMPinnedMessageListQueriedResultExtension
    on ZIMPinnedMessageListQueriedResult {
  static String get callbackMethodName {
    return 'onPinnedMessageListQueried';
  }
}

extension ZIMMessageImportedResultExtension on ZIMMessageImportedResult {
  static String get callbackMethodName {
    return 'onMessageImported';
  }
}

extension ZIMMessageExportedResultExtension on ZIMMessageExportedResult {
  static String get callbackMethodName {
    return 'onMessageExported';
  }
}

extension ZIMFileCacheQueriedResultExtension on ZIMFileCacheQueriedResult {
  static String get callbackMethodName {
    return 'onFileCacheQueried';
  }
}

extension ZIMFileCacheClearedResultExtension on ZIMFileCacheClearedResult {
  static String get callbackMethodName {
    return 'onFileCacheCleared';
  }
}

extension ZIMRoomCreatedResultExtension on ZIMRoomCreatedResult {
  static String get callbackMethodName {
    return 'onRoomCreated';
  }
}

extension ZIMRoomJoinedResultExtension on ZIMRoomJoinedResult {
  static String get callbackMethodName {
    return 'onRoomJoined';
  }
}

extension ZIMRoomEnteredResultExtension on ZIMRoomEnteredResult {
  static String get callbackMethodName {
    return 'onRoomEntered';
  }
}

extension ZIMRoomSwitchedResultExtension on ZIMRoomSwitchedResult {
  static String get callbackMethodName {
    return 'onRoomSwitched';
  }
}

extension ZIMRoomLeftResultExtension on ZIMRoomLeftResult {
  static String get callbackMethodName {
    return 'onRoomLeft';
  }
}

extension ZIMRoomAllLeftResultExtension on ZIMRoomAllLeftResult {
  static String get callbackMethodName {
    return 'onRoomAllLeft';
  }
}

extension ZIMRoomMemberQueriedResultExtension on ZIMRoomMemberQueriedResult {
  static String get callbackMethodName {
    return 'onRoomMemberQueried';
  }
}

extension ZIMRoomMembersQueriedResultExtension on ZIMRoomMembersQueriedResult {
  static String get callbackMethodName {
    return 'onRoomMembersQueried';
  }
}

extension ZIMRoomOnlineMemberCountQueriedResultExtension
    on ZIMRoomOnlineMemberCountQueriedResult {
  static String get callbackMethodName {
    return 'onRoomOnlineMemberCountQueried';
  }
}

extension ZIMRoomAttributesOperatedCallResultExtension
    on ZIMRoomAttributesOperatedCallResult {
  static String get callbackMethodName {
    return 'onRoomAttributesOperated';
  }
}

extension ZIMRoomAttributesBatchOperatedResultExtension
    on ZIMRoomAttributesBatchOperatedResult {
  static String get callbackMethodName {
    return 'onRoomAttributesBatchOperated';
  }
}

extension ZIMRoomAttributesQueriedResultExtension
    on ZIMRoomAttributesQueriedResult {
  static String get callbackMethodName {
    return 'onRoomAttributesQueried';
  }
}

extension ZIMRoomMembersAttributesOperatedResultExtension
    on ZIMRoomMembersAttributesOperatedResult {
  static String get callbackMethodName {
    return 'onRoomMembersAttributesOperated';
  }
}

extension ZIMRoomMembersAttributesQueriedResultExtension
    on ZIMRoomMembersAttributesQueriedResult {
  static String get callbackMethodName {
    return 'onRoomMembersAttributesQueried';
  }
}

extension ZIMRoomMemberAttributesListQueriedResultExtension
    on ZIMRoomMemberAttributesListQueriedResult {
  static String get callbackMethodName {
    return 'onRoomMemberAttributesListQueried';
  }
}

extension ZIMGroupCreatedResultExtension on ZIMGroupCreatedResult {
  static String get callbackMethodName {
    return 'onGroupCreated';
  }
}

extension ZIMGroupDismissedResultExtension on ZIMGroupDismissedResult {
  static String get callbackMethodName {
    return 'onGroupDismissed';
  }
}

extension ZIMGroupJoinedResultExtension on ZIMGroupJoinedResult {
  static String get callbackMethodName {
    return 'onGroupJoined';
  }
}

extension ZIMGroupLeftResultExtension on ZIMGroupLeftResult {
  static String get callbackMethodName {
    return 'onGroupLeft';
  }
}

extension ZIMGroupUsersInvitedResultExtension on ZIMGroupUsersInvitedResult {
  static String get callbackMethodName {
    return 'onGroupUsersInvited';
  }
}

extension ZIMGroupMemberKickedResultExtension on ZIMGroupMemberKickedResult {
  static String get callbackMethodName {
    return 'onGroupMemberKicked';
  }
}

extension ZIMGroupOwnerTransferredResultExtension
    on ZIMGroupOwnerTransferredResult {
  static String get callbackMethodName {
    return 'onGroupOwnerTransferred';
  }
}

extension ZIMGroupNameUpdatedResultExtension on ZIMGroupNameUpdatedResult {
  static String get callbackMethodName {
    return 'onGroupNameUpdated';
  }
}

extension ZIMGroupAvatarUrlUpdatedResultExtension
    on ZIMGroupAvatarUrlUpdatedResult {
  static String get callbackMethodName {
    return 'onGroupAvatarUrlUpdated';
  }
}

extension ZIMGroupNoticeUpdatedResultExtension on ZIMGroupNoticeUpdatedResult {
  static String get callbackMethodName {
    return 'onGroupNoticeUpdated';
  }
}

extension ZIMGroupAliasUpdatedResultExtension on ZIMGroupAliasUpdatedResult {
  static String get callbackMethodName {
    return 'onGroupAliasUpdated';
  }
}

extension ZIMGroupInfoQueriedResultExtension on ZIMGroupInfoQueriedResult {
  static String get callbackMethodName {
    return 'onGroupInfoQueried';
  }
}

extension ZIMGroupAttributesOperatedResultExtension
    on ZIMGroupAttributesOperatedResult {
  static String get callbackMethodName {
    return 'onGroupAttributesOperated';
  }
}

extension ZIMGroupAttributesQueriedResultExtension
    on ZIMGroupAttributesQueriedResult {
  static String get callbackMethodName {
    return 'onGroupAttributesQueried';
  }
}

extension ZIMGroupMemberRoleUpdatedResultExtension
    on ZIMGroupMemberRoleUpdatedResult {
  static String get callbackMethodName {
    return 'onGroupMemberRoleUpdated';
  }
}

extension ZIMGroupMemberNicknameUpdatedResultExtension
    on ZIMGroupMemberNicknameUpdatedResult {
  static String get callbackMethodName {
    return 'onGroupMemberNicknameUpdated';
  }
}

extension ZIMGroupMemberInfoQueriedResultExtension
    on ZIMGroupMemberInfoQueriedResult {
  static String get callbackMethodName {
    return 'onGroupMemberInfoQueried';
  }
}

extension ZIMGroupListQueriedResultExtension on ZIMGroupListQueriedResult {
  static String get callbackMethodName {
    return 'onGroupListQueried';
  }
}

extension ZIMGroupMemberListQueriedResultExtension
    on ZIMGroupMemberListQueriedResult {
  static String get callbackMethodName {
    return 'onGroupMemberListQueried';
  }
}

extension ZIMGroupMemberCountQueriedResultExtension
    on ZIMGroupMemberCountQueriedResult {
  static String get callbackMethodName {
    return 'onGroupMemberCountQueried';
  }
}

extension ZIMGroupMessageReceiptMemberListQueriedResultExtension
    on ZIMGroupMessageReceiptMemberListQueriedResult {
  static String get callbackMethodName {
    return 'onGroupMessageReceiptMemberListQueried';
  }
}

extension ZIMGroupMutedResultExtension on ZIMGroupMutedResult {
  static String get callbackMethodName {
    return 'onGroupMuted';
  }
}

extension ZIMGroupMembersMutedResultExtension on ZIMGroupMembersMutedResult {
  static String get callbackMethodName {
    return 'onGroupMembersMuted';
  }
}

extension ZIMGroupMemberMutedListQueriedResultExtension
    on ZIMGroupMemberMutedListQueriedResult {
  static String get callbackMethodName {
    return 'onGroupMemberMutedListQueried';
  }
}

extension ZIMGroupsSearchedResultExtension on ZIMGroupsSearchedResult {
  static String get callbackMethodName {
    return 'onGroupsSearched';
  }
}

extension ZIMGroupMembersSearchedResultExtension
    on ZIMGroupMembersSearchedResult {
  static String get callbackMethodName {
    return 'onGroupMembersSearched';
  }
}

extension ZIMGroupJoinModeUpdatedResultExtension
    on ZIMGroupJoinModeUpdatedResult {
  static String get callbackMethodName {
    return 'onGroupJoinModeUpdated';
  }
}

extension ZIMGroupInviteModeUpdatedResultExtension
    on ZIMGroupInviteModeUpdatedResult {
  static String get callbackMethodName {
    return 'onGroupInviteModeUpdated';
  }
}

extension ZIMGroupBeInviteModeUpdatedResultExtension
    on ZIMGroupBeInviteModeUpdatedResult {
  static String get callbackMethodName {
    return 'onGroupBeInviteModeUpdated';
  }
}

extension ZIMGroupJoinApplicationSentResultExtension
    on ZIMGroupJoinApplicationSentResult {
  static String get callbackMethodName {
    return 'onGroupJoinApplicationSent';
  }
}

extension ZIMGroupJoinApplicationAcceptedResultExtension
    on ZIMGroupJoinApplicationAcceptedResult {
  static String get callbackMethodName {
    return 'onGroupJoinApplicationAccepted';
  }
}

extension ZIMGroupJoinApplicationRejectedResultExtension
    on ZIMGroupJoinApplicationRejectedResult {
  static String get callbackMethodName {
    return 'onGroupJoinApplicationRejected';
  }
}

extension ZIMGroupInviteApplicationsSentResultExtension
    on ZIMGroupInviteApplicationsSentResult {
  static String get callbackMethodName {
    return 'onGroupInviteApplicationsSent';
  }
}

extension ZIMGroupInviteApplicationAcceptedResultExtension
    on ZIMGroupInviteApplicationAcceptedResult {
  static String get callbackMethodName {
    return 'onGroupInviteApplicationAccepted';
  }
}

extension ZIMGroupInviteApplicationRejectedResultExtension
    on ZIMGroupInviteApplicationRejectedResult {
  static String get callbackMethodName {
    return 'onGroupInviteApplicationRejected';
  }
}

extension ZIMGroupApplicationListQueriedResultExtension
    on ZIMGroupApplicationListQueriedResult {
  static String get callbackMethodName {
    return 'onGroupApplicationListQueried';
  }
}

extension ZIMCallInvitationSentResultExtension on ZIMCallInvitationSentResult {
  static String get callbackMethodName {
    return 'onCallInvitationSent';
  }
}

extension ZIMCallingInvitationSentResultExtension
    on ZIMCallingInvitationSentResult {
  static String get callbackMethodName {
    return 'onCallingInvitationSent';
  }
}

extension ZIMCallCancelSentResultExtension on ZIMCallCancelSentResult {
  static String get callbackMethodName {
    return 'onCallCancelSent';
  }
}

extension ZIMCallAcceptanceSentResultExtension on ZIMCallAcceptanceSentResult {
  static String get callbackMethodName {
    return 'onCallAcceptanceSent';
  }
}

extension ZIMCallRejectionSentResultExtension on ZIMCallRejectionSentResult {
  static String get callbackMethodName {
    return 'onCallRejectionSent';
  }
}

extension ZIMCallJoinSentResultExtension on ZIMCallJoinSentResult {
  static String get callbackMethodName {
    return 'onCallJoinSent';
  }
}

extension ZIMCallQuitSentResultExtension on ZIMCallQuitSentResult {
  static String get callbackMethodName {
    return 'onCallQuitSent';
  }
}

extension ZIMCallEndSentResultExtension on ZIMCallEndSentResult {
  static String get callbackMethodName {
    return 'onCallEndSent';
  }
}

extension ZIMCallInvitationListQueriedResultExtension
    on ZIMCallInvitationListQueriedResult {
  static String get callbackMethodName {
    return 'onCallInvitationListQueried';
  }
}

extension ZIMFriendAddedResultExtension on ZIMFriendAddedResult {
  static String get callbackMethodName {
    return 'onFriendAdded';
  }
}

extension ZIMFriendsDeletedResultExtension on ZIMFriendsDeletedResult {
  static String get callbackMethodName {
    return 'onFriendsDeleted';
  }
}

extension ZIMFriendListQueriedResultExtension on ZIMFriendListQueriedResult {
  static String get callbackMethodName {
    return 'onFriendListQueried';
  }
}

extension ZIMFriendsInfoQueriedResultExtension on ZIMFriendsInfoQueriedResult {
  static String get callbackMethodName {
    return 'onFriendsInfoQueried';
  }
}

extension ZIMFriendsRelationCheckedResultExtension
    on ZIMFriendsRelationCheckedResult {
  static String get callbackMethodName {
    return 'onFriendsRelationChecked';
  }
}

extension ZIMFriendApplicationSentResultExtension
    on ZIMFriendApplicationSentResult {
  static String get callbackMethodName {
    return 'onFriendApplicationSent';
  }
}

extension ZIMFriendApplicationAcceptedResultExtension
    on ZIMFriendApplicationAcceptedResult {
  static String get callbackMethodName {
    return 'onFriendApplicationAccepted';
  }
}

extension ZIMFriendApplicationRejectedResultExtension
    on ZIMFriendApplicationRejectedResult {
  static String get callbackMethodName {
    return 'onFriendApplicationRejected';
  }
}

extension ZIMFriendApplicationListQueriedResultExtension
    on ZIMFriendApplicationListQueriedResult {
  static String get callbackMethodName {
    return 'onFriendApplicationListQueried';
  }
}

extension ZIMFriendAliasUpdatedResultExtension on ZIMFriendAliasUpdatedResult {
  static String get callbackMethodName {
    return 'onFriendAliasUpdated';
  }
}

extension ZIMFriendAttributesUpdatedResultExtension
    on ZIMFriendAttributesUpdatedResult {
  static String get callbackMethodName {
    return 'onFriendAttributesUpdated';
  }
}

extension ZIMFriendsSearchedResultExtension on ZIMFriendsSearchedResult {
  static String get callbackMethodName {
    return 'onFriendsSearched';
  }
}

extension ZIMBlacklistUsersAddedResultExtension
    on ZIMBlacklistUsersAddedResult {
  static String get callbackMethodName {
    return 'onBlacklistUsersAdded';
  }
}

extension ZIMBlacklistUsersRemovedResultExtension
    on ZIMBlacklistUsersRemovedResult {
  static String get callbackMethodName {
    return 'onBlacklistUsersRemoved';
  }
}

extension ZIMBlacklistQueriedResultExtension on ZIMBlacklistQueriedResult {
  static String get callbackMethodName {
    return 'onBlacklistQueried';
  }
}

extension ZIMBlacklistCheckedResultExtension on ZIMBlacklistCheckedResult {
  static String get callbackMethodName {
    return 'onBlacklistChecked';
  }
}
