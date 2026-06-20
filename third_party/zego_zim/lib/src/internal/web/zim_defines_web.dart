import 'package:js/js.dart';
import 'package:zego_zim/src/internal/zim_utils_web.dart';

@JS()
class ZIM {
  external static toJSON(dynamic);
  external static setEventHandler(Function handler);
  external static String getVersion();
  external static ZIM? getInstance();
  external static ZIM? create(dynamic appConfig);
  external static void setAdvancedConfig(String key, String value);
  external static bool setGeofencingConfig(dynamic areaList, dynamic type);
  external void setLogConfig(dynamic config);
  external void destroy();
  external void logout();

  /// MARK: - Main
  external PromiseJsImpl<void> uploadLog();
  external PromiseJsImpl<void> login(String userID, dynamic config);
  external PromiseJsImpl<void> updateUserBadge(int badge);
  external PromiseJsImpl<String> callExperimentalAPI(String params);
  external PromiseJsImpl<dynamic> renewToken(dynamic config);
  external PromiseJsImpl<dynamic> updateUserName(String userName);
  external PromiseJsImpl<dynamic> updateUserAvatarUrl(String userAvatarUrl);
  external PromiseJsImpl<dynamic> updateUserExtendedData(String extendedData);
  external PromiseJsImpl<dynamic> updateUserCustomStatus(
      String customStatus, dynamic? config);
  external PromiseJsImpl<dynamic> updateUserOfflinePushRule(
      dynamic offlinePushRule);
  external PromiseJsImpl<dynamic> querySelfUserInfo();
  external PromiseJsImpl<dynamic> queryUsersInfo(
      dynamic userIDs, dynamic config);
  external PromiseJsImpl<dynamic> queryUsersStatus(dynamic userIDs);
  external PromiseJsImpl<dynamic> subscribeUsersStatus(
      dynamic userIDs, dynamic config);
  external PromiseJsImpl<dynamic> unsubscribeUsersStatus(dynamic userIDs);
  external PromiseJsImpl<dynamic> querySubscribedUserStatusList(dynamic config);

  /// MARK: - Conversation
  external PromiseJsImpl<dynamic> queryConversation(
      String conversationID, dynamic conversationType);
  external PromiseJsImpl<dynamic> queryConversationList(
      dynamic config, dynamic option);
  external PromiseJsImpl<dynamic> queryConversationPinnedList(dynamic config);
  external PromiseJsImpl<dynamic> queryConversationTotalUnreadMessageCount(
      dynamic config);
  external PromiseJsImpl<dynamic> deleteConversation(
      String conversationID, dynamic conversationType, dynamic? config);
  external PromiseJsImpl<void> deleteAllConversations(dynamic config);
  external PromiseJsImpl<void> deleteAllConversationMessages(dynamic config);
  external PromiseJsImpl<dynamic> clearConversationUnreadMessageCount(
      String conversationID, dynamic conversationType);
  external PromiseJsImpl<void> clearConversationTotalUnreadMessageCount();
  external PromiseJsImpl<dynamic> updateConversationPinnedState(
      bool isPinned, String conversationID, dynamic conversationType);
  external PromiseJsImpl<dynamic> setConversationDraft(
      String draft, String conversationID, dynamic conversationType);
  external PromiseJsImpl<dynamic> setConversationMark(
      int markType, bool enable, dynamic conversationInfos);
  external PromiseJsImpl<dynamic> setConversationNotificationStatus(
      dynamic status, String conversationID, dynamic conversationType);

  /// MARK: - Message
  external PromiseJsImpl<dynamic> sendMessage(
      Object message,
      String toConversationID,
      dynamic conversationType,
      dynamic config,
      Object notification);
  external PromiseJsImpl<dynamic> editMessage(
      Object message, dynamic config, Object notification);
  external PromiseJsImpl<dynamic> replyMessage(Object message,
      Object toOriginalMessage, dynamic config, Object notification);
  external PromiseJsImpl<dynamic> insertMessageToLocalDB(Object message,
      String conversationID, dynamic conversationType, String senderUserID);
  external PromiseJsImpl<void> cancelSendingMessage(
      Object message, dynamic config);
  external PromiseJsImpl<dynamic> deleteMessages(dynamic messageList,
      String conversationID, dynamic conversationType, dynamic config);
  external PromiseJsImpl<dynamic> deleteAllMessage(
      String conversationID, dynamic conversationType, dynamic config);
  external PromiseJsImpl<dynamic> queryHistoryMessage(
      String conversationID, int conversationType, dynamic config);
  external PromiseJsImpl<dynamic> queryMessages(
      dynamic messageSeqs, String conversationID, dynamic conversationType);
  external PromiseJsImpl<dynamic> queryMessageRepliedList(
      Object message, dynamic config);
  external PromiseJsImpl<dynamic> queryCombineMessageDetail(dynamic message);
  external PromiseJsImpl<dynamic> updateMessageLocalExtendedData(
      String localExtendedData, Object message);
  external PromiseJsImpl<dynamic> revokeMessage(Object message, dynamic config);
  external PromiseJsImpl<dynamic> sendConversationMessageReceiptRead(
      String conversationID, dynamic conversationType);
  external PromiseJsImpl<dynamic> sendMessageReceiptsRead(
      dynamic messageList, String conversationID, dynamic conversationType);
  external PromiseJsImpl<dynamic> queryMessageReceiptsInfo(
      dynamic messageList, String conversationID, dynamic conversationType);
  external PromiseJsImpl<dynamic> queryGroupMessageReceiptReadMemberList(
      Object message, String groupID, dynamic config);
  external PromiseJsImpl<dynamic> queryGroupMessageReceiptUnreadMemberList(
      Object message, String groupID, dynamic config);
  external PromiseJsImpl<dynamic> addMessageReaction(
      String reactionType, dynamic message, dynamic? config);
  external PromiseJsImpl<dynamic> deleteMessageReaction(
      String reactionType, dynamic message);
  external PromiseJsImpl<void> deleteMessageAllReactions(dynamic message);
  external PromiseJsImpl<dynamic> queryMessageReactionUserList(
      Object message, dynamic config);
  external PromiseJsImpl<void> pinMessage(
      Object message, bool isPinned, dynamic? config);
  external PromiseJsImpl<dynamic> queryPinnedMessageList(
      String conversationID, dynamic conversationType);

  /// MARK: - Room
  external PromiseJsImpl<dynamic> createRoom(dynamic roomInfo, dynamic? config);
  external PromiseJsImpl<dynamic> enterRoom(dynamic roomInfo, dynamic? config);
  external PromiseJsImpl<dynamic> joinRoom(String roomID);
  external PromiseJsImpl<dynamic> switchRoom(String fromRoomID,
      dynamic toRoomInfo, bool isCreateWhenRoomNotExisted, dynamic? config);
  external PromiseJsImpl<dynamic> leaveRoom(String roomID);
  external PromiseJsImpl<dynamic> leaveAllRoom();
  external PromiseJsImpl<dynamic> queryRoomMembers(
      dynamic userIDs, String roomID);
  external PromiseJsImpl<dynamic> queryRoomMemberList(
      String roomID, dynamic config);
  external PromiseJsImpl<dynamic> queryRoomOnlineMemberCount(String roomID);
  external PromiseJsImpl<dynamic> queryRoomAllAttributes(String roomID);
  external PromiseJsImpl<dynamic> setRoomAttributes(
      dynamic roomAttributes, String roomID, dynamic config);
  external PromiseJsImpl<dynamic> deleteRoomAttributes(
      dynamic keys, String roomID, dynamic config);
  external void beginRoomAttributesBatchOperation(
      String roomID, dynamic config);
  external PromiseJsImpl<dynamic> endRoomAttributesBatchOperation(
      String roomID);
  external PromiseJsImpl<dynamic> setRoomMembersAttributes(
      dynamic attributes, dynamic userIDs, String roomID, dynamic config);
  external PromiseJsImpl<dynamic> queryRoomMembersAttributes(
      dynamic userIDs, String roomID);
  external PromiseJsImpl<dynamic> queryRoomMemberAttributesList(
      String roomID, dynamic config);

  /// MARK: - Group
  external PromiseJsImpl<dynamic> createGroup(
      dynamic groupInfo, dynamic userIDs, dynamic? config);
  external PromiseJsImpl<dynamic> joinGroup(String groupID);
  external PromiseJsImpl<dynamic> leaveGroup(String groupID);
  external PromiseJsImpl<dynamic> dismissGroup(String groupID);
  external PromiseJsImpl<dynamic> queryGroupList(int count, dynamic? config);
  external PromiseJsImpl<dynamic> updateGroupName(
      String groupName, String groupID);
  external PromiseJsImpl<dynamic> updateGroupAvatarUrl(
      String groupAvatarUrl, String groupID);
  external PromiseJsImpl<dynamic> updateGroupNotice(
      String groupNotice, String groupID);
  external PromiseJsImpl<dynamic> updateGroupAlias(
      String groupAlias, String groupID);
  external PromiseJsImpl<dynamic> queryGroupInfo(String groupID);
  external PromiseJsImpl<dynamic> setGroupAttributes(
      dynamic groupAttributes, String groupID);
  external PromiseJsImpl<dynamic> deleteGroupAttributes(
      dynamic keys, String groupID);
  external PromiseJsImpl<dynamic> queryGroupAttributes(
      dynamic keys, String groupID);
  external PromiseJsImpl<dynamic> queryGroupAllAttributes(String groupID);
  external PromiseJsImpl<dynamic> inviteUsersIntoGroup(
      dynamic userIDs, String groupID);
  external PromiseJsImpl<dynamic> kickGroupMembers(
      dynamic userIDs, String groupID);
  external PromiseJsImpl<dynamic> transferGroupOwner(
      String toUserID, String groupID);
  external PromiseJsImpl<dynamic> setGroupMemberRole(
      int role, String forUserID, String groupID);
  external PromiseJsImpl<dynamic> setGroupMemberNickname(
      String nickname, String forUserID, String groupID);
  external PromiseJsImpl<dynamic> queryGroupMemberInfo(
      String userID, String groupID);
  external PromiseJsImpl<dynamic> queryGroupMemberList(
      String groupID, dynamic? config);
  external PromiseJsImpl<dynamic> queryGroupMemberCount(String groupID);
  external PromiseJsImpl<dynamic> muteGroup(
      bool isMute, String groupID, dynamic config);
  external PromiseJsImpl<dynamic> muteGroupMembers(
      bool isMute, dynamic userIDs, String groupID, dynamic config);
  external PromiseJsImpl<dynamic> queryGroupMemberMutedList(
      String groupID, dynamic config);
  external PromiseJsImpl<dynamic> updateGroupJoinMode(
      dynamic mode, String groupID);
  external PromiseJsImpl<dynamic> updateGroupInviteMode(
      dynamic mode, String groupID);
  external PromiseJsImpl<dynamic> updateGroupBeInviteMode(
      dynamic mode, String groupID);
  external PromiseJsImpl<dynamic> sendGroupJoinApplication(
      String groupID, dynamic config);
  external PromiseJsImpl<dynamic> acceptGroupJoinApplication(
      String userID, String groupID, dynamic config);
  external PromiseJsImpl<dynamic> rejectGroupJoinApplication(
      String userID, String groupID, dynamic config);
  external PromiseJsImpl<dynamic> sendGroupInviteApplications(
      dynamic userIDs, String groupID, dynamic config);
  external PromiseJsImpl<dynamic> acceptGroupInviteApplication(
      String inviterUserID, String groupID, dynamic config);
  external PromiseJsImpl<dynamic> rejectGroupInviteApplication(
      String inviterUserID, String groupID, dynamic config);
  external PromiseJsImpl<dynamic> queryGroupApplicationList(dynamic config);

  /// MARK: - Call
  external PromiseJsImpl<dynamic> callInvite(dynamic invitees, dynamic? config);
  external PromiseJsImpl<dynamic> callCancel(
      dynamic invitees, String callID, dynamic config);
  external PromiseJsImpl<dynamic> callAccept(String callID, dynamic config);
  external PromiseJsImpl<dynamic> callReject(String callID, dynamic config);
  external PromiseJsImpl<dynamic> callJoin(String callID, dynamic config);
  external PromiseJsImpl<dynamic> callQuit(String callID, dynamic config);
  external PromiseJsImpl<dynamic> callEnd(String callID, dynamic config);
  external PromiseJsImpl<dynamic> callingInvite(
      dynamic invitees, String callID, dynamic config);
  external PromiseJsImpl<dynamic> queryCallInvitationList(dynamic config);

  /// MARK: - Friend
  external PromiseJsImpl<dynamic> addFriend(String userID, dynamic config);
  external PromiseJsImpl<dynamic> deleteFriends(
      dynamic userIDs, dynamic config);
  external PromiseJsImpl<dynamic> checkFriendsRelation(
      dynamic userIDs, dynamic config);
  external PromiseJsImpl<dynamic> updateFriendAlias(
      String friendAlias, String userID);
  external PromiseJsImpl<dynamic> updateFriendAttributes(
      dynamic friendAttributes, String userID);
  external PromiseJsImpl<dynamic> sendFriendApplication(
      String userID, dynamic config);
  external PromiseJsImpl<dynamic> acceptFriendApplication(
      String userID, dynamic config);
  external PromiseJsImpl<dynamic> rejectFriendApplication(
      String userID, dynamic config);
  external PromiseJsImpl<dynamic> queryFriendsInfo(dynamic userIDs);
  external PromiseJsImpl<dynamic> queryFriendList(dynamic config);
  external PromiseJsImpl<dynamic> queryFriendApplicationList(dynamic config);

  /// MARK: - Blacklist
  external PromiseJsImpl<dynamic> addUsersToBlacklist(dynamic userIDs);
  external PromiseJsImpl<dynamic> removeUsersFromBlacklist(dynamic userIDs);
  external PromiseJsImpl<dynamic> checkUserIsInBlacklist(String userID);
  external PromiseJsImpl<dynamic> queryBlacklist(dynamic config);

  /// MARK: - DB Search
  external PromiseJsImpl<dynamic> searchLocalConversations(dynamic config);
  external PromiseJsImpl<dynamic> searchGlobalLocalMessages(dynamic config);
  external PromiseJsImpl<dynamic> searchLocalMessages(
      String conversationID, dynamic conversationType, dynamic config);
  external PromiseJsImpl<dynamic> searchLocalGroups(dynamic config);
  external PromiseJsImpl<dynamic> searchLocalGroupMembers(
      String groupID, dynamic config);
  external PromiseJsImpl<dynamic> searchLocalFriends(dynamic config);
}
