import '../zego_zim.dart';

class ZIMEventHandler {
  /// The callback for error information.
  ///
  /// When an exception occurs in the SDK, the callback will prompt detailed information.
  ///
  /// - [zim] ZIM instance.
  /// - [errorInfo] The error information
  static void Function(ZIM zim, ZIMError errorInfo)? onError;

  /// Experimental API callback.
  ///
  /// Receive experimental API callbacks in JSON string format.
  ///
  /// - [zim] ZIM instance.
  /// - [content] Callback content in JSON string format.
  static void Function(ZIM zim, String content)? onExperimentalEventReceived;

  /// A reminder callback that the token is about to expire.
  ///
  /// - [zim] ZIM instance.
  /// - [second] The remaining second before the token expires.
  static void Function(ZIM zim, int second)? onTokenWillExpire;

  /// The event callback when the connection state changes.
  ///
  /// - [zim] zim ZIM instance.
  /// - [state] The current connection state after changed.
  /// - [event] The event that caused the connection state to change.
  /// - [extendedData] Extra information when the event occurs, a standard JSON string.
  static void Function(
    ZIM zim,
    ZIMConnectionState state,
    ZIMConnectionEvent event,
    Map extendedData,
  )? onConnectionStateChanged;

  /// In the multi-terminal login scenario, after the user modifies their information on device A, other online multi-terminal devices will receive this callback. For offline devices, after the user goes online, they need to call the [ZIM.QueryUsersInfo] interface to actively query user information.
  ///
  /// - [zim] ZIM instance.
  /// - [info] The user info after updating.
  static void Function(ZIM zim, ZIMUserFullInfo info)? onUserInfoUpdated;

  /// TODO
  ///
  /// - [zim] ZIM instance.
  /// - [userRule] The user rule after updating.
  static void Function(ZIM zim, ZIMUserRule userRule)? onUserRuleUpdated;

  /// TODO
  ///
  /// - [zim] ZIM instance.
  /// - [userStatusList] The user status list after updating.
  static void Function(ZIM zim, List<ZIMUserStatus> userStatusList)?
      onUserStatusUpdated;

  /// Received notification callback for session update.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: Trigger this callback to return notification of session updates when a session is added, deleted, or modified.
  /// When to call /Trigger: Notifications are triggered when a new message is updated in the session, or when the session itself is added, deleted, or modified.
  /// Caution: ConversationID is the same as single chat toUserID and group chat GroupID.
  /// Related APIs: Through [sendPeerMessage] , [sendGroupMessage], [sendRoomMessage], [deleteConversation] [deleteMessage], [deleteMessageByConversationID] trigger.
  ///
  /// - [zim] ZIM instance.
  /// - [infoList] Changed information about the conversation.
  static void Function(ZIM zim, List<ZIMConversationChangeInfo> infoList)?
      onConversationChanged;

  /// Received notification callback for session update.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: Trigger this callback to return notification of session updates when a session is added, deleted, or modified.
  /// When to call /Trigger: Notifications are triggered when a new message is updated in the session, or when the session itself is added, deleted, or modified.
  /// Caution: ConversationID is the same as single chat toUserID and group chat GroupID.
  /// Related APIs: Through [sendPeerMessage] , [sendGroupMessage], [sendRoomMessage], [deleteConversation] [deleteMessage], [deleteMessageByConversationID] trigger.
  ///
  /// - [zim] ZIM instance.
  /// - [totalUnreadMessageCount] todo
  static void Function(ZIM zim, int totalUnreadMessageCount)?
      onConversationTotalUnreadMessageCountUpdated;

  /// Received notification callback when the message receiver has read this receipt message.
  ///
  /// Available since: 2.5.0 and above.
  /// Description: When the message receiver has read the session, the message sender knows through this callback.
  /// When to call /Trigger: Trigger a notification when the message receiver has read the session.
  /// Related APIs: triggered when the peer calls via [sendConversationMessageReceiptRead].
  ///
  /// - [zim] ZIM instance.
  /// - [infos] todo
  static void Function(ZIM zim, List<ZIMMessageReceiptInfo> infos)?
      onConversationMessageReceiptChanged;

  /// When multiple login ends delete all sessions, the local end triggers the callback to notify the local end that all sessions are deleted.
  ///
  /// Available since: 2.12.0 and above.
  /// Description: When multiple login ends delete all sessions, the local end triggers the callback to notify the local end that all sessions are deleted.
  /// When to call /Trigger: When another end clears all unread sessions, the local end triggers a notification.
  /// Related APIs: Triggered by [deleteAllConversations].
  ///
  /// - [zim] ZIM instance.
  /// - [info] todo
  static void Function(ZIM zim, ZIMConversationsAllDeletedInfo info)?
      onConversationsAllDeleted;

  /// Notification of synchronization status change events between the conversation list and the server
  ///
  /// Available since: 2.21.0 and above.
  ///
  /// - [zim] ZIM instance.
  /// - [state] Sync status
  static void Function(ZIM zim, ZIMConversationSyncState state)?
      onConversationSyncStateChanged;

  /// The callback for receiving peer-to-peer message.
  ///
  /// When receiving peer-to-peer message from other user, you will receive this callback.
  ///
  /// @deprecated This callback is deprecated. Please use [onPeerMessageReceived] instead.
  /// - [zim] ZIM instance.
  /// - [messageList] List of received messages.
  /// - [fromUserID] The user ID of the message sender.
  @Deprecated(
    'This callback is deprecated. Please use [onPeerMessageReceived] instead.',
  )
  static void Function(
    ZIM zim,
    List<ZIMMessage> messageList,
    String fromUserID,
  )? onReceivePeerMessage;

  /// The callback for receiving room message.
  ///
  /// This callback will be triggered when new message is received in a room.
  ///
  /// @deprecated This callback is deprecated. Please use [onRoomMessageReceived] instead.
  /// - [zim] ZIM instance.
  /// - [messageList] List of received messages.
  /// - [fromRoomID] The room ID of the message source.
  @Deprecated(
    'This callback is deprecated. Please use [onRoomMessageReceived] instead.',
  )
  static void Function(
    ZIM zim,
    List<ZIMMessage> messageList,
    String fromRoomID,
  )? onReceiveRoomMessage;

  /// The callback for receiving group message.
  ///
  /// This callback will be triggered when new message is received in a group.
  ///
  /// @deprecated This callback is deprecated. Please use [onGroupMessageReceived] instead.
  /// - [zim] ZIM instance.
  /// - [messageList] List of received messages.
  /// - [fromGroupID] The group ID of the message source.
  @Deprecated(
    'This callback is deprecated. Please use [onGroupMessageReceived] instead.',
  )
  static void Function(
    ZIM zim,
    List<ZIMMessage> messageList,
    String fromGroupID,
  )? onReceiveGroupMessage;

  /// The callback for receiving peer-to-peer message.
  ///
  /// When receiving peer-to-peer message from other user, you will receive this callback.
  ///
  /// - [zim] ZIM instance.
  /// - [messageList] List of received messages.
  /// - [info] The message receive extra information.
  /// - [fromUserID] The user ID of the message source.
  static void Function(
    ZIM zim,
    List<ZIMMessage> messageList,
    ZIMMessageReceivedInfo info,
    String fromUserID,
  )? onPeerMessageReceived;

  /// The callback for receiving room message.
  ///
  /// - [zim] ZIM instance.
  /// - [messageList] List of received messages.
  /// - [info] The message receive extra information.
  /// - [fromRoomID] The room ID of the message source.
  static void Function(
    ZIM zim,
    List<ZIMMessage> messageList,
    ZIMMessageReceivedInfo info,
    String fromRoomID,
  )? onRoomMessageReceived;

  /// The callback for receiving group message.
  ///
  /// - [zim] ZIM instance.
  /// - [messageList] List of received messages.
  /// - [info] The message receive extra information.
  /// - [fromGroupID] The group ID of the message source.
  static void Function(
    ZIM zim,
    List<ZIMMessage> messageList,
    ZIMMessageReceivedInfo info,
    String fromGroupID,
  )? onGroupMessageReceived;

  /// The callback for receiving broadcast message.
  ///
  /// Supported version: 2.10.0 or later.
  /// Description: The callback is received when the server interface [SendMessageToAllUsers] sends a message.
  /// Call time: This callback is received after logging in to the ZIM service and the server call the [SendMessageToAllUsers] interface to send a message.
  /// - zim ZIM instance.
  /// - message Received message.
  ///
  /// - [zim] ZIM instance.
  /// - [message] Received broadcast message.
  static void Function(ZIM zim, ZIMMessage message)? onBroadcastMessageReceived;

  /// The callback for message sent status changed.
  ///
  /// - [zim] ZIM instance.
  /// - [infos] List of message sent status change information.
  static void Function(ZIM zim, List<ZIMMessageSentStatusChangeInfo> infos)?
      onMessageSentStatusChanged;

  /// Received notification callback when the message receiver confirms that the message has been read.
  ///
  /// Available since: 2.5.0 and above.
  /// Description: When the message receiver confirms that the message has been read, the message sender knows through this callback.
  /// When to call /Trigger: Trigger a notification when the message receiver has read the message.
  /// Related APIs: Triggered when the peer calls via [sendMessageReceiptsRead].
  ///
  /// - [zim] ZIM instance.
  /// - [infos] List of message receipt change information.
  static void Function(ZIM zim, List<ZIMMessageReceiptInfo> infos)?
      onMessageReceiptChanged;

  /// Received notification callback when some one else sends a message and then revoke a message sent by themselves.
  ///
  /// Available since: 2.5.0 and above.
  /// Description: This callback is received when some one else sends a message and then revoke.
  /// When to call /Trigger: This callback occurs when a ZIM instance is created with [create] and the other user revoke a message.
  /// Related APIs: You can revoke message to other members via [revokeMessage].
  ///
  /// - [zim] ZIM instance.
  /// - [messageList] List of message revoke information.
  static void Function(ZIM zim, List<ZIMRevokeMessage> messageList)?
      onMessageRevokeReceived;

  /// The callback is received when reactions change
  ///
  /// Supported version: 2.10.0 or later.
  /// When to Call: This callback can be registered after the ZIM instance is created by [create] and before login.
  /// When to Trigger: After other users add or delete reactions to messages in private or group chats.
  /// Related APIs: [addMessageReaction]、[deleteMessageReaction]
  ///
  /// - [zim] ZIM instance.
  /// - [result] The message reaction change event callback result
  static void Function(ZIM zim, ZIMMessageReactionsChangedEventResult result)?
      onMessageReactionsChanged;

  /// The callback is received when a message is deleted.
  ///
  /// - [zim] ZIM instance.
  /// - [deletedInfo] todo
  static void Function(ZIM zim, ZIMMessageDeletedInfo deletedInfo)?
      onMessageDeleted;

  /// The callback is received when the message replied information changes.
  ///
  /// - [zim] ZIM instance.
  /// - [messageList] List of message information.
  static void Function(ZIM zim, List<ZIMMessage> messageList)?
      onMessageRepliedInfoChanged;

  /// The callback is received when the message replied count changes.
  ///
  /// - [zim] ZIM instance.
  /// - [infos] List of message root reply count change information.
  static void Function(ZIM zim, List<ZIMMessageRootRepliedCountInfo> infos)?
      onMessageRepliedCountChanged;

  /// The callback is received when a message is edited.
  ///
  /// - [zim] ZIM instance.
  /// - [messageList] The message list.
  static void Function(ZIM zim, List<ZIMMessage> messageList)? onMessageEdited;

  /// The callback is received when a message is pinned.
  ///
  /// - [zim] ZIM instance.
  /// - [changeInfoList] The message list.
  static void Function(
    ZIM zim,
    List<ZIMMessagePinStatusChangeInfo> changeInfoList,
  )? onMessagePinStatusChanged;

  /// The event callback when the room connection status changes.
  ///
  /// Description:event callback when the room connection status changes.
  /// When to call::After creating a ZIM instance through [create], you can call this interface.
  /// Related APIs:through [onTokenWillExpire], the callback will be received when the token is about to expire.
  ///
  /// - [zim] ZIM instance.
  /// - [state] Room state.
  /// - [event] Room event.
  /// - [extendedData] Extended data.
  /// - [roomID] Room ID.
  static void Function(
    ZIM zim,
    ZIMRoomState state,
    ZIMRoomEvent event,
    Map extendedData,
    String roomID,
  )? onRoomStateChanged;

  /// Callback when other members join the room.
  ///
  /// After joining a room, this callback will be triggered when other members also join this room.
  ///
  /// - [zim] ZIM instance.
  /// - [memberList] List of members who joined the room.
  /// - [roomID] The ID of the room where this event occurred.
  static void Function(ZIM zim, List<ZIMUserInfo> memberList, String roomID)?
      onRoomMemberJoined;

  /// Callback when other members leave the room.
  ///
  /// After joining a room, this callback will be triggered when other members leave this room.
  ///
  /// - [zim] ZIM instance.
  /// - [memberList] List of members who left the room.
  /// - [roomID] The ID of the room where this event occurred.
  static void Function(ZIM zim, List<ZIMUserInfo> memberList, String roomID)?
      onRoomMemberLeft;

  /// Event callback when the room attributes changes.
  ///
  /// Available since:  1.3.0.
  /// Description:When the room attribute in the room changes, it will be notified through this callback.
  ///
  /// - [zim] ZIM instance.
  /// - [info] Room attribute change information
  /// - [roomID] The ID of the room where this event occurred.
  static void Function(
    ZIM zim,
    ZIMRoomAttributesUpdateInfo info,
    String roomID,
  )? onRoomAttributesUpdated;

  /// Event callback when the room attributes batch changes.
  ///
  /// Available since:  1.3.0.
  /// Description:When the room attribute in the room changes, it will be notified through this callback.
  ///
  /// - [zim] ZIM instance.
  /// - [infos] Room attribute change information list
  /// - [roomID] The ID of the room where this event occurred.
  static void Function(
    ZIM zim,
    List<ZIMRoomAttributesUpdateInfo> infos,
    String roomID,
  )? onRoomAttributesBatchUpdated;

  /// Event callback when the room member attributes changes.
  ///
  /// - [zim] ZIM instance.
  /// - [infos] Room member attribute change information list
  /// - [operatedInfo] Operation information
  /// - [roomID] The ID of the room where this event occurred.
  static void Function(
    ZIM zim,
    List<ZIMRoomMemberAttributesUpdateInfo> infos,
    ZIMRoomOperatedInfo operatedInfo,
    String roomID,
  )? onRoomMemberAttributesUpdated;

  /// Event callback when the group state changes.
  ///
  /// Description: allback notification of group status change.
  /// Use cases: Scenarios that require interaction based on the group status.
  /// When to call /Trigger: A notification is triggered when a group is created, joined, left, or dismissed.
  /// Related APIs: [createGroup] : creates a group. [joinGroup] : joins a group. [leaveGroup], leave the group. [dismissGroup]; dismiss the group.
  ///
  /// - [zim] ZIM instance.
  /// - [state] Group status.
  /// - [event] Group related events.
  /// - [operatedInfo] Group operation information.
  /// - [groupInfo] Group detailed information.
  static void Function(
    ZIM zim,
    ZIMGroupState state,
    ZIMGroupEvent event,
    ZIMGroupOperatedInfo operatedInfo,
    ZIMGroupFullInfo groupInfo,
  )? onGroupStateChanged;

  /// Event callback when the group name changes.
  ///
  /// Description: Group name change notification callback.
  /// Use cases: If the group name is changed, you need to synchronize the latest group name.
  /// When to call /Trigger: The group name is changed. Procedure
  /// Related APIs: [updateGroupName] : updates the group name.
  ///
  /// - [zim] ZIM instance.
  /// - [groupName] Group name.
  /// - [operatedInfo] Group operation information.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    String groupName,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )? onGroupNameUpdated;

  /// Event callback when the group avatar changes.
  ///
  /// todo
  ///
  /// - [zim] ZIM instance.
  /// - [groupAvatarUrl] Group avatar.
  /// - [operatedInfo] Group operation information.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    String groupAvatarUrl,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )? onGroupAvatarUrlUpdated;

  /// Event callback when the group notice changes.
  ///
  /// Description: Group bulletin Change notification callback.
  /// Use cases: If a group bulletin changes, you need to synchronize the latest bulletin content.
  /// When to call /Trigger: The group bulletin is changed. Procedure.
  /// Related APIs: [updateGroupNotice], which updates the group notice.
  ///
  /// - [zim] ZIM instance.
  /// - [groupNotice] Group notice.
  /// - [operatedInfo] Group operation information.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    String groupNotice,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )? onGroupNoticeUpdated;

  /// Event callback when the group alias changes.
  ///
  /// Description: Group alias change notification callback.
  /// Use cases: If the group alias is changed, you need to synchronize the latest alias content.
  /// When to call /Trigger: The group alias is changed. Procedure.
  /// Related APIs: [updateGroupAlias], which updates the group alias.
  ///
  /// - [zim] ZIM instance.
  /// - [groupAlias] Group alias.
  /// - [operatedUserID] Operated user ID.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    String groupAlias,
    String operatedUserID,
    String groupID,
  )? onGroupAliasUpdated;

  /// Event callback when the group attributes change.
  ///
  /// Group attributes update notification callback.
  /// Description: Group attribute change notification callback.
  /// Use cases: When group attributes are changed, you need to synchronize the latest group attributes.
  /// When to call /Trigger: Triggered when group properties are set, updated, or deleted.
  /// Impacts on other APIs:  [setGroupAttributes] updates group attributes. [deleteGroupAttributes], delete the group attribute.
  ///
  /// - [zim] ZIM instance.
  /// - [infoList] Group attribute change information.
  /// - [operatedInfo] Group operation information.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    List<ZIMGroupAttributesUpdateInfo> infoList,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )? onGroupAttributesUpdated;

  /// Event callback when the group is muted.
  ///
  /// - [zim] ZIM instance.
  /// - [mutedInfo] Group mute information.
  /// - [operatedInfo] Group operation information.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    ZIMGroupMuteInfo mutedInfo,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )? onGroupMutedInfoUpdated;

  /// Event callback when the group verification information changes.
  ///
  /// - [zim] ZIM instance.
  /// - [verifyInfo] Group verification information.
  /// - [operatedInfo] Group operation information.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    ZIMGroupVerifyInfo verifyInfo,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )? onGroupVerifyInfoUpdated;

  /// Event callback when the group member status changes.
  ///
  /// Use cases: Scenarios that require interaction based on group member states.
  /// When to call /Trigger: Notification is triggered when a group is created, joined, left, or dismissed, or a user is invited to join or kicked out of the group.
  /// Related APIs: [createGroup] : creates a group. [joinGroup] : joins a group. [leaveGroup], leave the group. [dismissGroup]; dismiss the group. [intiveUsersIntoGroup], which invites users to join the group. [kickoutGroupMember] kicks the user out of the group.
  ///
  /// - [zim] zim
  /// - [state] Group member status.
  /// - [event] Group member event.
  /// - [userList] Group member information list.
  /// - [operatedInfo] Group operation information.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    ZIMGroupMemberState state,
    ZIMGroupMemberEvent event,
    List<ZIMGroupMemberInfo> userList,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )? onGroupMemberStateChanged;

  /// Event callback when the group member information changes.
  ///
  /// Use cases: After the basic information of group members is changed, you need to display or interact with group members on the page.
  /// When to call /Trigger: The result is displayed after the group member information is changed.
  /// Related APIs: [setGroupMemberNickname] : updates the nickname of a group member. [setGroupMemberRole] : updates the group member role. [transferGroupOwner], group master transfer.
  ///
  /// - [zim] ZIM instance.
  /// - [userList] Group member information list.
  /// - [operatedInfo] Group operation information.
  /// - [groupID] Group ID.
  static void Function(
    ZIM zim,
    List<ZIMGroupMemberInfo> userList,
    ZIMGroupOperatedInfo operatedInfo,
    String groupID,
  )? onGroupMemberInfoUpdated;

  /// Event callback when the group application list changes.
  ///
  /// - [zim] ZIM instance.
  /// - [applicationList] Group application list.
  /// - [action] Group operation information.
  static void Function(
    ZIM zim,
    List<ZIMGroupApplicationInfo> applicationList,
    ZIMGroupApplicationListChangeAction action,
  )? onGroupApplicationListChanged;

  /// Event callback when the group application information changes.
  ///
  /// - [zim] ZIM instance.
  /// - [applicationList] Group application list.
  static void Function(ZIM zim, List<ZIMGroupApplicationInfo> applicationList)?
      onGroupApplicationUpdated;

  /// Event callback when the call invitation is created.
  ///
  /// - [zim] ZIM instance.
  /// - [info] Call invitation information.
  /// - [callID] Call ID.
  static void Function(
    ZIM zim,
    ZIMCallInvitationCreatedInfo info,
    String callID,
  )? onCallInvitationCreated;

  /// Event callback when the call invitation is received.
  ///
  /// Supported versions: 2.0.0 and above.
  /// Business scenario: The invitee will call this callback after the inviter sends a call invitation.
  /// When to call: After creating a ZIM instance through [create].
  /// Note: If the user is not in the invitation list or not online, this callback will not be called.
  /// Related interface: [callInvite].
  ///
  /// - [zim] ZIM instance.
  /// - [info] Call invitation information.
  /// - [callID] Call ID.
  static void Function(
    ZIM zim,
    ZIMCallInvitationReceivedInfo info,
    String callID,
  )? onCallInvitationReceived;

  /// Event callback when the call invitation is cancelled.
  ///
  /// Supported versions: 2.0.0 and above.
  /// Business scenario: The invitee will call this callback after the inviter cancels the call invitation.
  /// When to call: After creating a ZIM instance through [create].
  /// Note: If the user is not in the cancel invitation list or is offline, this callback will not be called.
  /// Related interface: [callCancel].
  ///
  /// - [zim] ZIM instance.
  /// - [info] Call invitation cancellation information.
  /// - [callID] Call ID.
  static void Function(
    ZIM zim,
    ZIMCallInvitationCancelledInfo info,
    String callID,
  )? onCallInvitationCancelled;

  /// Event callback when the call invitation is ended.
  ///
  /// - [zim] ZIM instance.
  /// - [info] Call invitation end information.
  /// - [callID] Call ID.
  static void Function(ZIM zim, ZIMCallInvitationEndedInfo info, String callID)?
      onCallInvitationEnded;

  /// Event callback when the call invitation is rejected.
  ///
  /// Supported versions: 2.0.0 and above.
  /// Detail description: After the invitee accepts the call invitation, this callback will be received when the inviter is online.
  /// Business scenario: The inviter will receive this callback after the inviter accepts the call invitation.
  /// When to call: After creating a ZIM instance through [create].
  /// Note: This callback will not be called if the user is not online.
  /// Related interface: [callAccept].
  ///
  /// @deprecated Deprecated since 2.9.0, pleace use [onCallUserStateChanged] instead.
  /// - [zim] ZIM instance.
  /// - [info] todo
  /// - [callID] Call ID.
  @Deprecated(
    'Deprecated since 2.9.0, pleace use [onCallUserStateChanged] instead.',
  )
  static void Function(
    ZIM zim,
    ZIMCallInvitationRejectedInfo info,
    String callID,
  )? onCallInvitationRejected;

  /// Event callback when the call invitation is accepted.
  ///
  /// Detail description: After the invitee accepts the call invitation, this callback will be received when the inviter is online.
  /// Business scenario: The inviter will receive this callback after the inviter accepts the call invitation.
  /// When to call: After creating a ZIM instance through [create].
  /// Note: This callback will not be called if the user is not online.
  /// Related interface: [callAccept].
  ///
  /// @deprecated Deprecated since 2.9.0, pleace use  [onCallUserStateChanged] instead.
  /// - [zim] ZIM instance.
  /// - [info] Call invitation acceptance information.
  /// - [callID] Call ID.
  @Deprecated(
    'Deprecated since 2.9.0, pleace use  [onCallUserStateChanged] instead.',
  )
  static void Function(
    ZIM zim,
    ZIMCallInvitationAcceptedInfo info,
    String callID,
  )? onCallInvitationAccepted;

  /// Event callback when the call invitation times out.
  ///
  /// Supported versions: 2.9.0 and above.
  /// Detail description: When the call invitation times out, the invitee does not respond and will receive a callback.
  /// Business scenario: If the invitee does not respond before the timeout period, this callback will be received.
  /// When to call: After creating a ZIM instance through [create].
  /// Note: If the user is not on the invitation list or is not online, the callback will not be received.
  /// Related interfaces: [callInvite], [callAccept], [callReject].
  ///
  /// - [zim] ZIM instance.
  /// - [info] Call invitation timeout information.
  /// - [callID] Call ID.
  static void Function(
    ZIM zim,
    ZIMCallInvitationTimeoutInfo info,
    String callID,
  )? onCallInvitationTimeout;

  /// Event callback when the call invitation invitee times out.
  ///
  /// Supported versions: 2.0.0 and above.
  /// Detail description: When the call invitation times out, the invitee does not respond, and the inviter will receive a callback.
  /// Business scenario: The invitee does not respond before the timeout period, and the inviter will receive this callback.
  /// When to call: After creating a ZIM instance through [create].
  /// Note: If the user is not the inviter who initiated this call invitation or is not online, the callback will not be received.
  /// Related interfaces: [callInvite], [callAccept], [callReject].
  /// - zim ZIM instance.
  /// - invitees Timeout invitee ID.
  /// - callID The number of invitees that have timed out.
  ///
  /// @deprecated Deprecated since 2.9.0, pleace use [onCallUserStateChanged] instead.
  /// - [zim] ZIM instance.
  /// - [invitees] Invitee ID.
  /// - [callID] Call ID.
  @Deprecated(
    'Deprecated since 2.9.0, pleace use [onCallUserStateChanged] instead.',
  )
  static void Function(ZIM zim, List<String> invitees, String callID)?
      onCallInviteesAnsweredTimeout;

  /// Event callback when the call invitation user status changes.
  ///
  /// Supported versions: 2.9.0 and above.
  /// Detail description: Listen for calling user status changes.
  /// When to call: When a new member is invited to a call, or a member accepts, rejects, exits, or a member response times out, all users on the current call invitation whose status is "Inviting," "Accepted," and "Received" receive the callback here. If the member is not online at the time of notification, the call is still ongoing when the login succeeds. The status changes of all members during the offline period will be sent to the user at one time.
  /// Note: If the user is not the inviter who initiated this call invitation or is not online, the callback will not be received.
  /// Related APIs: [callInvite], [callingInvite], [callAccept], [callReject],[callQuit].
  /// - zim ZIM instance.
  /// - info Information about the status change of a call member.
  /// - Unique identifier of the call.
  ///
  /// - [zim] ZIM instance.
  /// - [info] Call invitation user status change information.
  /// - [callID] Call ID.
  static void Function(ZIM zim, ZIMCallUserStateChangeInfo info, String callID)?
      onCallUserStateChanged;

  /// Event callback when the friend list changes.
  ///
  /// - [zim] ZIM instance.
  /// - [friendInfoList] Friend information list.
  /// - [action] Friend list change operation.
  static void Function(
    ZIM zim,
    List<ZIMFriendInfo> friendInfoList,
    ZIMFriendListChangeAction action,
  )? onFriendListChanged;

  /// Event callback when the friend information changes.
  ///
  /// - [zim] zim
  /// - [friendInfoList] todo
  static void Function(ZIM zim, List<ZIMFriendInfo> friendInfoList)?
      onFriendInfoUpdated;

  /// Event callback when the friend application list changes.
  ///
  /// - [zim] ZIM instance.
  /// - [friendApplicationInfoList] Friend application information list.
  /// - [action] Friend application list change operation.
  static void Function(
    ZIM zim,
    List<ZIMFriendApplicationInfo> friendApplicationInfoList,
    ZIMFriendApplicationListChangeAction action,
  )? onFriendApplicationListChanged;

  /// Event callback when the friend application information changes.
  ///
  /// - [zim] ZIM instance.
  /// - [friendApplicationInfoList] Friend application information list.
  static void Function(
    ZIM zim,
    List<ZIMFriendApplicationInfo> friendApplicationInfoList,
  )? onFriendApplicationUpdated;

  /// Event callback when the blacklist changes.
  ///
  /// - [zim] ZIM instance.
  /// - [userList] Blacklist user list.
  /// - [action] Blacklist change operation.
  static void Function(
    ZIM zim,
    List<ZIMUserInfo> userList,
    ZIMBlacklistChangeAction action,
  )? onBlacklistChanged;
}
