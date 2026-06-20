import 'internal/zim_manager.dart';
import 'zim_defines.dart';

abstract class ZIM {
  /// Gets the SDK's version number.
  ///
  /// Available since: 1.1.0.
  /// Description: Get the SDK version.
  /// Use cases:
  /// 1. When the SDK is running, the developer finds that it does not match the expected situation and submits the problem and related logs to the ZEGO technical staff for locating. The ZEGO technical staff may need the information of the engine version to assist in locating the problem.
  /// 2. Developers can also collect this information as the version information of the engine used by the app, so that the SDK corresponding to each version of the app on the line.
  /// When to call : It can be called at any time.
  static Future<String> getVersion() async {
    return await ZIMManager.getVersion();
  }

  /// Initialize ZIM SDK
  ///
  /// Supported versions: 1.1.0 and above.
  /// Detailed description: Create a ZIM instance for subsequent calls to other member functions.
  /// When to call: Before calling other member functions, you must call this API to create a ZIM example.
  /// Usage restrictions: Currently only one instance is supported, repeated calls will return [null].
  /// Precautions:
  /// 1. Currently, the [create] function can only create one instance at most. If it is called multiple times, only the first one will return a valid instance, and the rest will be [null]. The developer should save the ZIM instance by himself, and ensure that the life cycle of the instance is available in the process of using the ZIM business function; or after calling [create], he can use [getInstance] to obtain its singleton object and call other member functions.
  /// 2. If you use this function to create an instance, you must pass in both AppID and AppSign (exclude Web platform).
  /// Scope of Impact: Failure to call this function will prevent other member functions from being called.
  /// Platform difference: When calling this function on the Android platform, in addition to the appID, the Application class object must also be passed in.
  ///
  /// - [config] ZIMAppConfig
  static ZIM? create(ZIMAppConfig config) {
    return ZIMManager.create(config);
  }

  /// Get the ZIM singleton object.
  ///
  /// Supported versions: 2.3.0 and above.
  /// Detailed description: Get the ZIM singleton object for subsequent calls to other member functions.
  /// When to call: You must call [create] to create an instance before calling this function to obtain a singleton object, otherwise it will return [null].
  /// Related interface: [create].
  static ZIM? getInstance() {
    return ZIMManager.getInstance();
  }

  /// Set ZIM advanced configuration.
  ///
  /// When you need to customize the set advanced configurations, you need to call this function.
  /// It must be set before calling [create] to take effect. If it is set after [create], it will take effect at the next [create].
  ///
  /// - [key] Configuration Key
  /// - [value] Configuration value
  static void setAdvancedConfig(String key, String value) {
    ZIMManager.setAdvancedConfig(key, value);
  }

  /// Set geofence-related configurations.
  ///
  /// Available since: 2.12.0 and above.
  /// Description: Geofencing means that instant messaging data transmission is limited to a certain area to meet regional data privacy and security regulations, that is, to restrict access to communication services in a specific area.
  /// When to call /Trigger: The [setGeofencingConfig] interface needs to be called before the [create] interface.
  /// Restrictions: If you need to use this function, please contact ZEGO technical support.
  /// Caution: If you need to update geo fencing information, please call the [destroy] interface to destroy the current ZIM instance, and then call this interface.
  ///
  /// - [areaList] Geofencing area list
  /// - [type] Geofencing type
  static Future<bool> setGeofencingConfig(
    List<int> areaList,
    ZIMGeofencingType type,
  ) async {
    return await ZIMManager.setGeofencingConfig(areaList, type);
  }

  ///  Set log related configuration.
  ///
  /// Supported version: 1.1.0 and above.
  /// Detailed description: Set log related configuration, including log path and log size. Since there is a default log path inside the SDK, unless the developer has a strong need to customize the log path, it is generally not recommended that customers set it by themselves.
  /// Defaults:
  /// Android: /storage/Android/data/[packageName]/files/ZIMLogs
  /// iOS: ~/Library/Caches/ZIMLogs
  /// macOS: (sandbox) ~/Library/Containers/[Bundle ID]/Data/Library/Caches/ZIMLogs /; (non-sandbox) ~/Library/Caches/ZIMLogs
  /// Windows: C:/Users/[Your UserName]/AppData/[App Name]ZEGO.SDK/ZIMLogs
  /// When to call: It must be called before [create].
  /// Note: If the developer calls after [create], the SDK will save this configuration until the next time [create] takes effect.
  /// Life cycle: Set before calling [create], and take effect when calling [create]. If the developer does not set a new log configuration in the next [create], the previous configuration will still take effect.
  /// Platform difference: The default path of different platforms is different, please refer to the default value.
  /// Related reference: For details, please refer to https://doc-zh.zego.im/faq/IM_sdkLog?product=IM&platform=all.
  ///
  /// - [config] Custom log configuration
  static void setLogConfig(ZIMLogConfig config) {
    ZIMManager.setLogConfig(config);
  }

  /// Set cache related configuration.
  ///
  ///  Supported version: 1.1.0 and above.
  ///  Detailed description: Example Set the SDK cache file path. Because the SDK has a default path, it is generally not recommended that you set your own path unless there is a strong need to do so.
  ///  Default value:Android：/storage/Android/data/[packageName]/files/ZIMCaches
  ///  iOS：~/Library/Caches/ZIMCaches
  ///  macOS：（sandbox）~/Library/Containers/[Bundle ID]/Data/Library/Caches/ZIMCaches / ~/Library/Caches/ZIMCaches
  ///  Windows：C:/Users/[Your UserName]/AppData/[App Name]ZEGO.SDK/ZIMCaches
  ///  Call timing: It must be called before [create].
  ///  Note: If the developer calls after [create], the SDK saves the configuration until it takes effect the next time [Create] is invoked.
  ///  Related callbacks: In addition to getting the login result in the callback parameter, the developer will also receive the [onConnectionStateChanged] callback during the login request and after the login is successful/failed to determine the current user's login status.
  ///  Life cycle: Set before calling [create] and takes effect when calling [create]. If the developer does not set the new logging configuration the next time [create] is created, the previous configuration will still take effect.
  ///  Platform difference: The default path varies with platforms. Please refer to the default value.
  ///  - config Cache configuration object.
  ///
  /// - [config] Custom cache configuration
  static void setCacheConfig(ZIMCacheConfig config) {
    ZIMManager.setCacheConfig(config);
  }

  /// Destroy the ZIM instance.
  ///
  /// Supported version: 1.1.0 and above.
  /// Detailed description: Release the resources used by the ZIM instance. This function must be called to release the occupied memory resources when ZIM is no longer needed, otherwise a memory leak may occur.
  /// Call timing: call when ZIM is no longer needed, usually before emptying the ZIM object.
  /// Note: After calling this function, ZIM internal functions can no longer be used, and all callback notifications will no longer be triggered. If you need to continue using the ZIM function, please call [create] again to create a new instance.
  destroy();

  /// Upload log and call after setting up log path.
  ///
  /// Supported version: 1.2.0 and above.
  /// Detailed description: By default, the SDK will create and print log files in the default directory of the App. By default, the maximum value of each log file is 5MB, and the three log files are written in a cycle. When this function is called, the SDK automatically packages and uploads the log file to the ZEGO server.
  /// Use case: Developers can provide business "feedback" channels in the App. When user feedback problems belong to ZEGO SDK, they can call this function to upload the local log information of SDK and contact ZEGO technical support to help locate user problems.
  /// Calling timing: It must be after calling [create] to create an instance.
  /// Usage Restriction: If this interface is invoked repeatedly within 10 minutes, only the last invocation takes effect.
  /// Note: If you call [destory] or exit the App too quickly after calling this interface to upload logs, it may fail. You are advised to wait a few seconds and then call [destory] or exit the App after receiving the callback for successful upload.
  /// Related callbacks: Developers can get the upload results through the callback parameter.
  Future<void> uploadLog();

  /// Login, you must log in before using all functions.
  ///
  /// Supported version: 2.13.0 and above.
  /// Detailed description: Log in to the ZIM service. [login] is the most important step of the ZIM function. You need to log in before using any other functions.
  /// Call timing: This function must be called after calling [create] to create an instance and before calling other instance functions.
  /// Note: Before using ZIM's single chat, room, message sending and receiving functions, you must first call this function to log in, and the UI can be displayed to the user through the login result.
  /// Privacy protection statement: remind users not to pass in sensitive information involving personal privacy in the userID parameter, including but not limited to mobile phone number, ID number, passport number, real name, etc.
  /// Related callbacks: In addition to getting the login result in the callback parameter, the developer will also receive the [onConnectionStateChanged] callback during the login request and after the login is successful/failed to determine the current user's login status.
  /// FAQ: How is the RTC login different from ZEGO's? RTC login refers to the login to the room, ZIM login to the account.
  /// Related reference: For details, please refer to Authentication (https://docs.zegocloud.com/article/13772).
  ///
  /// - [userID] Used to identify user information, the unique ID of the user.
  /// - [config] Various parameters used for specific login actions.
  Future<void> login(String userID, ZIMLoginConfig config);

  /// Log out of ZIM service.
  ///
  /// Available since: 1.1.0 or above.
  /// Description: Log out of the ZIM service.
  /// Use cases: This function must be called from the instance after it has been created by calling [create].
  /// When to call: After invoking [logout], you can no longer use ZIM's chat, room, send and receive, and other functions. To use the ZIM service again, the developer must call [login] to login again.
  /// Caution: Upon logout, the developer will receive the [onConnectionStateChanged] callback with the login state being [Disconnected].
  logout();

  /// Update the authentication token.
  ///
  /// Available since: 1.1.0 or above.
  /// Description: Update the authentication token so that the authentication token can be updated in time after it expires, so as to continue to use ZIM functions normally.
  /// Use cases: When you need to create a multi-person chat scene, you can create and join a room by this API.
  /// When to call: This function must be called through the instance after calling [create] to create the instance.
  /// Caution: After the developer receives the [onTokenWillExpire] callback, the developer needs to request the authentication server to regenerate a token in time.
  ///
  /// - [token] The token issued by the developer's business server, used to ensure security. The generation rules are detailed in ZEGO document website.
  Future<ZIMTokenRenewedResult> renewToken(String token);

  /// Call the experimental API.
  ///
  /// ZEGO provides some technical previews or special customization functions in ZIM business through this API. If you need to get the use of the function or the details, please consult ZEGO technical support.
  ///
  /// - [params] Parameters in the format of a JSON string, please consult ZEGO technical support for details.
  Future<String> callExperimentalAPI(String params);

  /// Update user's user name.
  ///
  /// Available since: 2.2.0 or above.
  /// Description: After user logs in, calling this interface could update the user's own user name.
  /// When to call: After the user is logged in.
  /// Note: This interface does not support modifying user names in rooms.
  /// Privacy reminder: Try not to pass in sensitive information involving personal privacy, including but not limited to mobile phone numbers, ID numbers, passport numbers, real names, etc.
  /// Related callbacks: [ZIMUserNameUpdatedCallback].
  /// Related APIs: [updateUserExtendedData] and [queryUsersInfo].
  ///
  /// - [userName] User name , It is customized by the developer. For version 2.0.0 and onwards, the string has a maximum length of 256 bytes.
  Future<ZIMUserNameUpdatedResult> updateUserName(String userName);

  /// Update user's avatar URL.
  ///
  /// Supported versions: 2.3.0 and above.
  /// Detail description: After the user logs in, calling this interface can set or update the user's own user avatar URL.
  /// Call timing/notify timing: After the user logs in.
  /// Note: The user avatar itself needs to be stored by the developer, and ZIM only saves its user information as a pass-through URL.
  /// Usage Restriction: There is no limit on special characters and a maximum of 500 bytes.
  /// Related callback: [ZIMUserAvatarUrlUpdatedCallback].
  /// Related interface: [queryUsersInfo].
  ///
  /// - [userAvatarUrl] User avatar URL wanted to changed to.
  Future<ZIMUserAvatarUrlUpdatedResult> updateUserAvatarUrl(
    String userAvatarUrl,
  );

  /// Update user's user extended data.
  ///
  /// Available since: 2.2.0 or above.
  /// Description: After user logs in, calling this interface could update the user's own user extended data.
  /// When to call: After the user is logged in.
  /// Privacy reminder: Try not to pass in sensitive information involving personal privacy, including but not limited to mobile phone numbers, ID numbers, passport numbers, real names, etc.
  /// Related callbacks: [ onUserNameUpdatedCallback ].
  /// Related APIs: [updateUserName] and [ queryUsersInfo ].
  ///
  /// - [extendedData] User extended data wanted to changed to .
  Future<ZIMUserExtendedDataUpdatedResult> updateUserExtendedData(
    String extendedData,
  );

  /// Update user's custom rule of offline push.
  ///
  /// Available since: 2.15.0 or above.
  /// Description: This interface is used to modify the custom rule of offline push for the current user.
  /// Use cases: For example, in the multi-terminal login scenario, the developer hopes that when the desktop is online, the mobile terminal does not want to receive offline push. In this scenario, the interface can be invoked to achieve this function.
  /// When to call /Trigger: You can call it after you log in and the network is in good condition.
  /// Caution:After the interface is successfully invoked, all ends will receive onUserRuleUpdate notifying the user that the rule has been updated.
  /// Related callbacks: [ZIMUserOfflinePushRuleUpdatedCallback]、[onUserRuleUpdate].
  ///
  /// - [offlinePushRule] The user pushes the rule information offline, and the interface will be fully updated with the member properties of the input object each time the interface is called.
  Future<ZIMUserOfflinePushRuleUpdatedResult> updateUserOfflinePushRule(
    ZIMUserOfflinePushRule offlinePushRule,
  );

  /// Update user's custom status.
  ///
  /// - [customStatus] User custom status.
  /// - [config] Config of user custom status.
  Future<ZIMUserCustomStatusUpdatedResult> updateUserCustomStatus({
    required String customStatus,
    ZIMUserCustomStatusUpdateConfig? config,
  });

  /// Update the user’s app badge value.
  ///
  /// Available since: 2.28.0 or above.
  /// Description: This API updates the APP badge count on the current user’s mobile clients. It applies to the user on mobile devices where they have logged in.
  /// Use cases: In multi-device login scenarios, after the developer clears unread counts (or when unread counts change) on desktop or web, and wants mobile users’ APP badge counts to reflect and sync to the corresponding value, this API can be called to achieve that.
  /// When to call: After login, with a good network connection, and when the total unread count changes. It only needs to be called on non-mobile platforms that do not support ZPNs (such as desktop and web).
  /// Caution: After a successful call, the APP badge value will be updated to the specified value on all offline mobile clients where the user has logged in.
  /// Related callbacks: [ZIMUserBadgeUpdatedCallback].
  ///
  /// - [badge] The user’s expected APP badge value.
  Future<void> updateUserBadge({required int badge});

  /// Query user information.
  ///
  /// Available since: 2.3.0 or above.
  /// Description: Through this interface, you can query and obtain the corresponding UserInfo by userID.
  /// When to call /Trigger: It is available only after calling [create] to create the instance and then calling [login] to login.
  /// Related callbacks: [ZIMUsersInfoQueriedCallback].
  /// Usage restrictions: No more than 10 userids can be queried by invoking the interface at a time. If the interface is invoked multiple times within 10 seconds, the total number of userids queried cannot exceed 10.
  ///
  /// - [userIDs] userID list.
  /// - [config] Query user information configuration.
  Future<ZIMUsersInfoQueriedResult> queryUsersInfo(
    List<String> userIDs,
    ZIMUserInfoQueryConfig config,
  );

  /// Query user status.
  ///
  /// - [userIDs] User ID list.
  Future<ZIMUsersStatusQueriedResult> queryUsersStatus(List<String> userIDs);

  /// Query user information and user rules.
  ///
  /// Available since: 2.15.0 or above.
  /// Description: Query information about the current user and user rules. In offline state, you can query local data.
  /// Use cases: If you need to display the user information and rules, you can invoke the query, for example, to enter the personal page of the current user.
  /// When to call /Trigger: Call after login.
  /// Related callbacks: [ZIMSelfUserInfoQueriedCallback].
  Future<ZIMSelfUserInfoQueriedResult> querySelfUserInfo();

  /// Subscribe to user status.
  ///
  /// - [userIDs] User ID list.
  /// - [config] Configuration for subscribing to user status.
  Future<ZIMUsersStatusSubscribedResult> subscribeUsersStatus(
    List<String> userIDs,
    ZIMUserStatusSubscribeConfig config,
  );

  /// Unsubscribe from user status.
  ///
  /// - [userIDs] User ID list.
  Future<ZIMUsersStatusUnsubscribedResult> unsubscribeUsersStatus(
    List<String> userIDs,
  );

  /// Query subscribed user status list.
  ///
  /// - [config] Configuration for querying subscribed user status list.
  Future<ZIMSubscribedUserStatusListQueriedResult>
      querySubscribedUserStatusList(ZIMSubscribedUserStatusQueryConfig config);

  /// Query the conversation list.
  ///
  /// - [config] Configuration for session queries.
  /// - [option] Filter options for session queries.
  Future<ZIMConversationListQueriedResult> queryConversationList(
    ZIMConversationQueryConfig config, [
    ZIMConversationFilterOption? option,
  ]);

  /// Query a conversation by conversation ID and conversation type.
  ///
  /// Available since: 2.8.0 and above.
  /// Description: This method displays the session list of the logged in user.
  /// Use cases: When you need to know the relevant information of the specified conversation, you can call this interface to obtain the data source.
  /// When to call /Trigger: Can be invoked after login.
  /// Restrictions:There is no limit to the frequency of use, available after login, unavailable after logout.
  /// Related callbacks: [ZIMConversationQueriedCallback].
  ///
  /// - [conversationID] Conversation ID.
  /// - [conversationType] Conversation type.
  Future<ZIMConversationQueriedResult> queryConversation(
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// Query the conversation pinned list.
  ///
  /// Available since: 2.8.0 and above.
  /// Description: This method displays the pinned conversation list of the logged in user.
  /// Use cases: This interface can be invoked to get the data source when you need to display an existing pinned message conversation after logging in.
  /// When to call /Trigger: Can be invoked after login.
  /// Restrictions:There is no limit to the frequency of use, available after login, unavailable after logout.
  /// Caution: NextConversation is the riveting point of the query message, which can be null for the first query. In subsequent query, the earliest conversation can be used as nextConversation to query earlier sessions. In paging query, Count in [ZIMConversationQueryConfig] fill each pull the number of sessions.
  ///
  /// - [config] Configuration for session queries.
  Future<ZIMConversationPinnedListQueriedResult> queryConversationPinnedList(
    ZIMConversationQueryConfig config,
  );

  /// Modify the conversation pinned state.
  ///
  /// Available since: 2.8.0 and above.
  /// Description: This method can modify the pinned state of the specified conversation of the logged-in user.
  /// Use cases: You can call this interface when you need to modify the pinned state of a conversation.
  /// When to call /Trigger: Can be invoked after login.
  /// Restrictions: Available after login, unavailable after logout.
  /// Related callbacks: [ZIMConversationPinnedStateUpdatedCallback].
  ///
  /// - [isPinned] Whether the conversation is pinned, true is pinned, false is unpinned.
  /// - [conversationID] Conversation ID.
  /// - [conversationType] Conversation type.
  Future<ZIMConversationPinnedStateUpdatedResult> updateConversationPinnedState(
    bool isPinned,
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// delete the conversation.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: This interface is invoked when a session needs to be deleted. All members in the session can invoke this interface.
  /// Use cases: You can invoke this interface implementation to delete an entire session when it is no longer needed.
  /// When to call /Trigger: his parameter is invoked when a session needs to be deleted and can be invoked after a ZIM instance is created. The call takes effect after login and becomes invalid after logout.
  /// Impacts on other APIs: call success will trigger onConversationchanged callback, if the deleted session include unread message triggers [onConversationTotalUnreadMessageCountUpdated] callback.
  /// Related callbacks: [ZIMConversationDeletedCallback]
  ///
  /// - [conversationID] conversationID.
  /// - [conversationType] conversationtype.
  /// - [config] delete the session's configuration.
  Future<ZIMConversationDeletedResult> deleteConversation(
    String conversationID,
    ZIMConversationType conversationType,
    ZIMConversationDeleteConfig config,
  );

  /// delete all conversations.
  ///
  /// Available since: 2.12.0 and above.
  /// Description: This interface is invoked when all conversations needs to be deleted. All members in conversations can invoke this interface.
  /// Use cases: If you want to delete all conversations when they are no longer needed, you can call this interface implementation.
  /// When to call /Trigger: his parameter is invoked when conversations needs to be deleted and can be invoked after a ZIM instance is created. The call takes effect after login and becomes invalid after logout.
  /// Impacts on other APIs: If deleted conversations include unread message will trigger the [onConversationTotalUnreadMessageCountUpdated] callback, the call is successful at login, and the other end will trigger [onConversationsAllDeleted] callback.
  /// Related callbacks: [ZIMConversationsAllDeletedCallback]
  ///
  /// - [config] delete all conversation's configuration.
  Future<void> deleteAllConversations(ZIMConversationDeleteConfig config);

  /// clear session unreads.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: Used to clear unread for the current user target session.
  /// Use cases: This interface is called when a chat page is entered from a session and the original message readings of the session need to be cleared.
  /// When to call /Trigger: Called when a target needs to be cleared without readings.
  /// Restrictions: Valid after login, invalid after logout.
  /// Impacts on other APIs: Calling this method will trigger a total readings not updated callback [conversationTotalUnreadMessageCountUpdated], would trigger a session to update callbacks [conversationChanged].
  /// Related callbacks:[ZIMConversationUnreadMessageCountClearedCallback].
  /// Related APIs:[conversationTotalUnreadMessageCountUpdated]、[conversationChanged].
  ///
  /// - [conversationID] conversationID.
  /// - [conversationType] conversation type.
  Future<ZIMConversationUnreadMessageCountClearedResult>
      clearConversationUnreadMessageCount(
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// clear all conversations unreads.
  ///
  /// Available since: 2.12.0 and above.
  /// Description: Used to clear unread for all conversations.
  /// Use cases: You can call this interface when you need to clear all unread conversations to zero.
  /// When to call /Trigger: Called when all conversation readings need to be cleared.
  /// Restrictions: Valid after login, invalid after logout.
  /// Related callbacks:[ZIMConversationTotalUnreadMessageCountClearedCallback].
  /// Impacts on other APIs: Calling this method will trigger a total readings not updated callback [onConversationTotalUnreadMessageCountUpdated].
  /// Related APIs:[onConversationTotalUnreadMessageCountUpdated].
  Future<void> clearConversationTotalUnreadMessageCount();

  /// Query the total unread count of the conversation.
  ///
  /// - [config] Configuration for querying the total unread count of the conversation.
  Future<ZIMConversationTotalUnreadMessageCountQueriedResult>
      queryConversationTotalUnreadMessageCount(
    ZIMConversationTotalUnreadMessageCountQueryConfig config,
  );

  /// Set the conversation notification state.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: This method enables DND by selecting whether the unread of the target session is updated when a message is received.
  /// Use cases: If the user selects MESSAGE DO not Disturb (DND), the user can call the corresponding method.
  /// Default value: Message DND is disabled by default.
  /// When to call /Trigger: If the target session exists after login, invoke this interface if you want to enable the DND status of the target session.
  /// Restrictions:  Valid after login, invalid after logout.
  /// Impacts on other APIs: After the DND state is enabled, receiving messages is not triggered [conversationTotalUnreadMessageCountUpdated]。
  /// Related callbacks: [ZIMConversationNotificationStatusSetCallback]。
  /// Related APIs: [conversationTotalUnreadMessageCountUpdated]。
  ///
  /// - [status] the session notification state.
  /// - [conversationID] Conversation ID. Currently, only "group" conversations and "peer"(only for 2.14.0 or above version)  conversations can be set by notification state.
  /// - [conversationType] todo
  Future<ZIMConversationNotificationStatusSetResult>
      setConversationNotificationStatus(
    ZIMConversationNotificationStatus status,
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// Sets all received receipts for the conversation as read.
  ///
  /// Available since: 2.5.0 and above.
  /// Description: Set all received receipts of the conversation to be read.
  /// Use cases: Set all received receipt messages in the entire conversation to be read, and the sender of the message receipt in the conversation will receive the [onConversationMessageReceiptChanged] callback from ZIMEventHandler.
  /// When to call /Trigger: It can be called after login. It is recommended to call before entering the message list page. In the message list page, it is recommended to call [sendMessageReceiptsRead] to batch set the messages that need to be read.
  /// Caution: Only single chat conversation are allowed.
  /// Related callbacks: [ZIMConversationMessageReceiptReadSentCallback].
  /// Related APIs: [sendMessageReceiptsRead], [sendMessage].
  ///
  /// - [conversationID] Conversation ID.
  /// - [conversationType] todo
  Future<ZIMConversationMessageReceiptReadSentResult>
      sendConversationMessageReceiptRead(
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// Set the conversation notification state.
  ///
  /// Available since: 2.14.0 and above.
  /// Description: When you need to set a draft for a session, call this interface, and members of the session can call this interface.
  /// Use cases: This interface can be invoked when you need to temporarily save the text message that the user is editing but has not yet sent.
  /// When to call /Trigger:  Call when you need to set session draft, call after creating ZIM instance, take effect after login, invalid after logout.
  /// Impacts on other APIs: A successful call triggers the [onConversationchanged] callback.
  /// Related callbacks: [ZIMConversationDraftSetCallback].
  ///
  /// - [draft] Drafts that need to be set.
  /// - [conversationID] Conversation ID.
  /// - [conversationType] todo
  Future<ZIMConversationDraftSetResult> setConversationDraft(
    String draft,
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// Set the conversation marked status.
  ///
  /// - [mark] Mark value that needs to be set.
  /// - [enable] Whether to enable the mark value.
  /// - [conversationInfos] Conversation information list that needs to be set.
  Future<ZIMConversationMarkSetResult> setConversationMark(
    int mark,
    bool enable,
    List<ZIMConversationBaseInfo> conversationInfos,
  );

  /// Search local conversations on local messages.
  ///
  /// Supported versions: 2.9.0 and above.
  /// Detailed description: This method is used for searching local conversations based on local messages.
  /// Business scenario: When there is a need to search conversations using keywords or other conditions, this API can be called for searching.
  /// Call timing/Notification timing: It should be invoked when there is a requirement to search conversations using keywords or other conditions.
  /// Restrictions: effective after logging in and becomes invalid after logging out. Searching is not supported in room scenarios (conversationType=1).
  /// Related callbacks: [ZIMConversationsSearchedCallback].
  ///
  /// - [config] Global search conversation config.
  Future<ZIMConversationsSearchedResult> searchLocalConversations(
    ZIMConversationSearchConfig config,
  );

  /// Send peer-to-peer messages.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: After this function is called, a message is sent to the specified user. At the same time, a [ZIMMessageSentCallback] callback is received, which can be used to determine whether the message is sent successfully.
  /// Use cases: This function is used in 1V1 chat scenarios.
  /// Call timing/Notification timing: Can be invoked after login.
  /// Caution: Be aware of the [ZIMMessageSentCallback] callback when sending. This callback can be used to determine if the send fails for some reason.Pushconfig Is required only when the offline push function is required.
  /// Usage limit: no more than 10 /s, available after login, unavailable after logout.
  /// Scope of influence: Using this method triggers the [receivePeerMessage] callback of the message receiver and the [onConversationChanged] callback of the sender and receiver. If message DND is not set for the session where the message is sent, Triggers [conversationTotalUnreadMessageCountUpdated] callback.
  /// Related callbacks:[ZIMMessageSentCallback]、[receivePeerMessage]、[onConversationChanged]、[conversationTotalUnreadMessageCountUpdated]。
  /// Related API: [queryHistoryMessage]、[deleteMessageByConversationID]、[deleteMessage]
  ///
  /// @deprecated Deprecated since ZIM 2.4.0, please use [sendMessage] instead.
  /// - [message] The message to be sent.
  /// - [toUserID] The ID of the user who will receive the message.
  /// - [config] Related configuration for sending single chat messages.
  @Deprecated('Deprecated since ZIM 2.4.0, please use [sendMessage] instead.')
  Future<ZIMMessageSentResult> sendPeerMessage(
    ZIMMessage message,
    String toUserID,
    ZIMMessageSendConfig config,
  );

  /// Send room messages.
  ///
  /// Available since: 1.1.0 or above
  /// Description: When this function is called, the message will be sent in the room. At the same time, the [ZIMMessageSentCallback] callback will be received, which can be used to determine whether the message was sent successfully.
  /// Use Cases: This feature is required for scenarios where multiple people in the room are chatting.
  ///
  /// @deprecated This API has been deprecated since 2.4.0, use [sendMessage] instead.
  /// - [message] The message to be sent.
  /// - [toRoomID] The ID of the room which will receive the message.
  /// - [config] Related configuration for sending room messages.
  @Deprecated(
    'This API has been deprecated since 2.4.0, use [sendMessage] instead.',
  )
  Future<ZIMMessageSentResult> sendRoomMessage(
    ZIMMessage message,
    String toRoomID,
    ZIMMessageSendConfig config,
  );

  /// Send group messages.
  ///
  /// Supported version: 2.0.0 or later.
  /// Description: This interface is invoked when a group chat message needs to be sent.
  /// Service scenario: This interface can be used when sending group messages.
  /// Call timing/Notification timing: This interface is called when a group chat message needs to be sent.
  /// Usage restrictions: No more than 10 pieces /s, available after login, unavailable after logout.
  /// Note: pushconfig is only required to use the offline push function.
  /// Scope of influence: Using this method triggers the onReceiveGroupMessage callback of the message recipient and the onConversationChanged callback of the sender and receiver. If messages are not set for the session where the message resides, Trigger onConversationTotalUnreadMessageCountUpdated  callback.
  /// The callback: [ZIMMessageSentCallback]、[onReceiveGroupMessage]、[onConversationChanged]、[onConversationTotalUnreadMessageCountUpdated].
  /// Relevant interface: [queryHistoryMessage], [deleteMessage].
  ///
  /// @deprecated Deprecated since ZIM 2.4.0, please use [sendMessage] instead.
  /// - [message] The message to be sent.
  /// - [toGroupID] The ID of the user who will receive the message.
  /// - [config] Related configuration for sending single chat messages.
  @Deprecated('Deprecated since ZIM 2.4.0, please use [sendMessage] instead.')
  Future<ZIMMessageSentResult> sendGroupMessage(
    ZIMMessage message,
    String toGroupID,
    ZIMMessageSendConfig config,
  );

  /// send message.
  ///
  /// Supported versions: 2.4.0 and above.
  /// Detailed description: This method can be used to send messages in single chat, room and group chat.
  /// Business scenario: When you need to send message to the target user, target message room, and target group chat after logging in, send it through this interface.
  /// Call timing: It can be called after login.
  /// Usage limit: The interval between sending messages should be greater than 100ms. Available after login, unavailable after logout.
  /// Related callback: [ZIMMessageSentCallback], [ZIMMessageSendNotification], [onReceivePeMessage], [onReceiveRoomMessage], [onReceiveGroupMessage], [onConversationChanged], [onConversationTotalUnreadMessageCountUpdated].
  /// Related APIs: [queryHistoryMessage], [deleteAllMessage], [deleteMessages],[sendMediaMessage].
  ///
  /// - [message] The message to be sent.
  /// - [toConversationID] The conversation ID the message needs to be sent.
  /// - [conversationType] The conversation type the message needs to be sent.
  /// - [config] Related configuration for sending messages.
  /// - [notification] Related notifications when messages are sent.
  Future<ZIMMessageSentResult> sendMessage(
    ZIMMessage message,
    String toConversationID,
    ZIMConversationType conversationType,
    ZIMMessageSendConfig config, [
    ZIMMessageSendNotification? notification,
  ]);

  /// Send media messages.
  ///
  /// Supported versions: 2.4.0 and above.
  /// Detailed description: This method can be used to send messages in single chat, room and group chat.
  /// Business scenario: When you need to send media to the target user, target message room, and target group chat after logging in, send it through this interface.
  /// Call timing: It can be called after login.
  /// Usage limit: no more than 10/s, available after login, unavailable after logout. Only video files with video encoding formats of H264 and H265 are supported. After the message is sent successfully, the width and height information of the first frame of the video is obtained.
  /// Impacts on other APIs: [onReceivePeerMessage]/[ReceiveGroupMessage] sessions and session-scoped [onReceiveGroupMessage] sessions did not fire message receiver's [ConversationR] fires [onversationTotalUnreadMessageCountUpdated] objection.
  /// Note: Only required if you need to use the threaded update feature when pushing configuration. Push notifications are not supported, nor are [onContationChanged] and [ConTotalUnreadMessageCountUpdated] supported if media messages are broadcast to the world.
  /// Related callbacks: [ZIMMessageSentCallback], [ZIMMediaMessageSendNotification], [onReceivePeMessage], [onReceiveRoomMessage], [onReceiveGroupMessage], [onConversationChanged], [onConversationTotalUnreadMessageCountUpdated].
  /// Related APIs: [queryHistoryMessage], [deleteAllMessage], [deleteMessages]
  ///
  /// @deprecated Deprecated since ZIM 2.19.0, please use [sendMessage] instead
  /// - [message] When using the message to be sent, modify the type of message according to the type of multimedia message. For example, when sending image messages, use ZIMImageMessage.
  /// - [toConversationID] The conversation ID of the message recipient, supports single chat, room and group chat.
  /// - [conversationType] Conversation type, supports single chat, room and group chat.
  /// - [config] Related configuration for sending messages.
  /// - [notification] Relevant notifications when sending media messages, including upload progress, etc.
  @Deprecated('Deprecated since ZIM 2.19.0, please use [sendMessage] instead')
  Future<ZIMMessageSentResult> sendMediaMessage(
    ZIMMediaMessage message,
    String toConversationID,
    ZIMConversationType conversationType,
    ZIMMessageSendConfig config,
    ZIMMediaMessageSendNotification? notification,
  );

  /// Download media message content.
  ///
  /// Supported versions: 2.19.0 and above.
  /// Detailed description: This method can be used to download the content of media messages, including the original image, large image, thumbnail image, file message, audio message, video message and the first frame of the image message.
  /// Service scenario: After the user receives a message, if the message is a media message, he can call this API to download its content.You cannot Download Network urls before 2.9.0.
  /// Invoke timing/notification timing: can be invoked after logging in and receiving a media message.
  /// Note: If [sendMediaMessage] sends a network URL, SDK earlier than 2.9.0 cannot be downloaded through this interface.
  /// Restrictions: If you download an external URL, you can only download a maximum of 200MB of resources. For configuration, please contact ZEGO technical support.
  /// Related callbacks: [ZIMMediaDownloadedCallback], [ZIMMediaDownloadingProgress].
  ///
  /// - [message] The media message to download.
  /// - [fileType] Media file type.
  /// - [config] Download media file configuration.
  /// - [progress] Progress callback for downloading media files.
  Future<ZIMMediaDownloadedResult> downloadMediaFile(
    ZIMMessage message,
    ZIMMediaFileType fileType,
    ZIMMediaDownloadConfig config,
    ZIMMediaDownloadingProgress progress,
  );

  /// Query historical messages.
  ///
  /// Supported versions: 2.0.0 and above.
  /// Detailed description: This method is used to query historical messages.
  /// Business scenario: When you need to obtain past historical messages, you can call this interface to query historical messages by paging.
  /// Call timing/Notification timing: Called when historical messages need to be queried.
  /// Restrictions: Effective after login, invalid after logout. In the default room scenario (conversationType=1), offline message is disabled. If you need to enable it, please contact the corresponding technical support.
  /// Related callbacks: [ZIMMessageQueriedCallback].
  ///
  /// - [conversationID] The session ID of the queried historical message.
  /// - [conversationType] conversation type.
  /// - [config] Query the configuration of historical messages.
  Future<ZIMMessageQueriedResult> queryHistoryMessage(
    String conversationID,
    ZIMConversationType conversationType,
    ZIMMessageQueryConfig config,
  );

  /// Batch query messages by sequence.
  ///
  /// Supported versions: 2.19.0 and above.
  ///
  /// - [messageSeqs] The list of message sequence numbers to query.
  /// - [conversationID] The session ID of the queried message.
  /// - [conversationType] conversation type.
  Future<ZIMMessageQueriedResult> queryMessages(
    List<int> messageSeqs,
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// delete message.
  ///
  /// Supported versions: 2.0.0 and above.
  /// Detail description: This method implements the function of deleting messages.
  /// Business scenario: The user needs to delete a message. When the user does not need to display a message, this method can be used to delete it.
  /// Call timing/Notification timing: Called when the message needs to be deleted.
  /// Note: The impact of deleting messages is limited to this account.
  /// Restrictions: Effective after login.
  /// Impacts on other APIs: If the deleted message is the latest message of the session, the [conversationChanged] callback will be triggered, and if the message is unread, the [conversationTotalUnreadMessageCountUpdated] callback will be triggered.
  /// Related callbacks：[ZIMMessageDeletedCallback]、[conversationChanged]、[conversationTotalUnreadMessageCountUpdated].
  ///
  /// - [messageList] List of deleted messages.
  /// - [conversationID] The session ID of the deleted message.
  /// - [conversationType] conversation type.
  /// - [config] Delete the configuration of the message.
  Future<ZIMMessageDeletedResult> deleteMessages(
    List<ZIMMessage> messageList,
    String conversationID,
    ZIMConversationType conversationType,
    ZIMMessageDeleteConfig config,
  );

  /// Delete all message.
  ///
  /// Supported versions: 2.0.0 and above.
  /// Detail description: When you need to delete all messages under the target session, call this method.
  /// Business scenario: If you want to implement a group setting page to clear the chat information under the current session, you can call this interface.
  /// Call timing/Notify timing: The target session exists and the user is a member of this session.
  /// Restrictions: Effective after login, invalid after logout.
  /// Note: The impact of deleting messages is limited to this account, and messages from other accounts will not be deleted.
  /// Impacts on other APIs: The [conversationChanged] callback is triggered, and if there are unread messages, the [conversationTotalUnreadMessageCountUpdated] callback is triggered.
  /// Related callbacks: [ZIMMessageDeletedCallback].
  ///
  /// - [conversationID] The session ID of the message to be deleted.
  /// - [conversationType] conversation type.
  /// - [config] delete message configuration.
  Future<ZIMMessageDeletedResult> deleteAllMessage(
    String conversationID,
    ZIMConversationType conversationType,
    ZIMMessageDeleteConfig config,
  );

  /// Delete all messages for all conversations.
  ///
  /// Supported versions: 2.14.0 and above.
  /// Detail description: This method implements the function of deleting all messages for all conversations.
  /// Business scenario: The user needs to delete a message. When the user does not need to display a message, this method can be used to delete it.
  /// Call timing/Notify timing: Effective after login, invalid after logout.
  /// Note: IsAlsoDeleteServerMessage decided whether to delete a server message, the impact of deleting messages is limited to this account.
  /// Impacts on other APIs: Call the interface trigger [onMessageDeleted] callback, if there are unread messages at this time, will trigger  [onConversationTotalUnreadMessageCountUpdated] callback.
  /// Related callbacks: [ZIMConversationMessagesAllDeletedCallback]、[onMessageDeleted]、[onConversationTotalUnreadMessageCountUpdated].
  ///
  /// - [config] delete message configuration.
  Future<void> deleteAllConversationMessages(ZIMMessageDeleteConfig config);

  /// Insert a message to the local DB.
  ///
  /// Available since: 2.4.0 and above.
  /// Description: This method can insert a message directly to the local DB on the client side.
  /// Use cases: The developer can combine the system message type, and convert the callback notification (for example, invite someone into the group, remove someone from the group, etc.) to the system message type on the client side and insert it into the local DB to achieve the effect of the system prompt .
  /// When to call: It can be called after login.
  /// Caution: Inserting "command" messages is not supported. To insert a "room" message, upgrade the SDK to 2.13.0 and above.
  /// Related callbacks: [ZIMMessageInsertedCallback].
  /// Related APIs: [queryHistoryMessage], [deleteAllMessage], [deleteMessages].
  ///
  /// - [message] The message to be sent.
  /// - [conversationID] Conversation ID.
  /// - [conversationType] Conversation type.
  /// - [senderUserID] The sender ID of this message.
  Future<ZIMMessageInsertedResult> insertMessageToLocalDB(
    ZIMMessage message,
    String conversationID,
    ZIMConversationType conversationType,
    String senderUserID,
  );

  /// Set the receipt of a batch of messages to become read.
  ///
  /// Available since: 2.5.0 and above.
  /// Description: This method can set the receipt of a batch of messages to become read.
  /// Use cases: Developers can use this method to set a batch of messages with receipts that have been read. If the sender is online, it will receive the [onMessageReceiptChanged] callback.
  /// When to call: Callable after login. It is recommended to set the settings for the messages that need to be read on the message list page. It is not recommended to mix with [sendConversationMessageReceiptRead].
  /// Restrictions: Only support the settings for received messages with receipt status as PROCESSING.
  /// Related callbacks: [ZIMMessageReceiptsReadSentCallback].
  /// Related APIs: [sendMessage].
  ///
  /// - [messageList] The list of messages to be read with no more than 10 messages.
  /// - [conversationID] Conversation ID.
  /// - [conversationType] Conversation type.
  Future<ZIMMessageReceiptsReadSentResult> sendMessageReceiptsRead(
    List<ZIMMessage> messageList,
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// Query the receipt information of a batch of messages.
  ///
  /// Available since: 2.5.0 and above.
  /// Description: This method can query the receipt information of a batch of messages, including the status, the number of unread users and the number of read users.
  /// Use cases: If you need to query the receipt status of the message, the number of unread users and the number of read users, you can call this interface.
  /// When to call: Callable after login. If you need to query the detailed member list, you can query through the interface [queryGroupMessageReceiptReadMemberList] or [queryGroupMessageReceiptUnreadMemberList].
  /// Restrictions: Only messages whose statuses are not NONE and UNKNOWN are supported.
  /// Related callbacks: [ZIMMessageReceiptsInfoQueriedCallback].
  /// Related APIs: [queryGroupMessageReceiptReadMemberList] , [queryGroupMessageReceiptUnreadMemberList].
  ///
  /// - [messageList] list of messages to query.
  /// - [conversationID] Conversation ID.
  /// - [conversationType] Conversation type.
  Future<ZIMMessageReceiptsInfoQueriedResult> queryMessageReceiptsInfo(
    List<ZIMMessage> messageList,
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// revoke message.
  ///
  /// Available sinces: 2.5.0 and above.
  /// Detail description: This method implements the function of message recall. The interface only allows recalling messages within 2 minutes. If you need to recall messages sent earlier, please contact technical support.
  /// Use cases: The user needs to recall a message. This method can be used when the user does not want other users to see the message.
  /// When to call: Called when the message needs to be revoked.
  /// Note: Room message revoke is not supported.
  /// Restrictions: Login is required to use. To revoke messages from other members within the group, the group owner needs to use version 2.9.0 or above.
  /// Related callbacks: If the revoked message is the latest message of the session, the [conversationChanged] callback will be triggered, and if the message is unread, the [conversationTotalUnreadMessageCountUpdated] callback will be triggered.
  ///
  /// - [message] The message needs to be revoke.
  /// - [config] Revoke the configuration of the message.
  Future<ZIMMessageRevokedResult> revokeMessage(
    ZIMMessage message,
    ZIMMessageRevokeConfig config,
  );

  /// Update the local expandable field of the message.
  ///
  /// Available since: 2.2.0 or above.
  /// Description: After the user logs in, calling this interface allows updating the local expandable field of the message.
  /// When to call: After the user is logged in.
  /// Privacy reminder: Please avoid passing sensitive personal information, including but not limited to phone numbers, ID card numbers, passport numbers, real names, etc.
  /// Related callbacks: [ ZIMMessageLocalExtendedDataUpdatedCallback ].
  ///
  /// - [localExtendedData] The expandable message field visible only on this end can store additional information locally and currently has a length limit of 128K. If you have special requirements, please contact ZEGO technical support for configuration.
  /// - [message] Message body to be updated
  Future<ZIMMessageLocalExtendedDataUpdatedResult>
      updateMessageLocalExtendedData(
          String localExtendedData, ZIMMessage message);

  /// Edit message.
  ///
  /// - [message] The message needs to be edited.
  /// - [config] Edit the configuration of the message.
  /// - [notification] notification
  Future<ZIMMessageEditedResult> editMessage(
    ZIMMessage message,
    ZIMMessageEditConfig config,
    ZIMMessageSendNotification? notification,
  );

  /// Cancel sending message.
  ///
  /// - [message] The message needs to be cancelled to be sent.
  /// - [config] The configuration of cancelling to be sent message.
  Future<void> cancelSendingMessage(
    ZIMMessage message,
    ZIMSendingMessageCancelConfig config,
  );

  /// Search local message list.
  ///
  /// Supported versions: 2.9.0 and above.
  /// Detailed description: This method is used to search local messages.
  /// Business scenario: When it is necessary to search for past local messages based on keywords or other conditions, this interface can be called to perform pagination search for local messages.
  /// Restrictions: Effective after login, invalid after logout. Searching is not supported in the room scene (conversationType=1).
  /// Related callbacks: [ZIMMessagesSearchedCallback].
  ///
  /// - [conversationID] The conversation ID of the local message to be search.
  /// - [conversationType] conversation type.
  /// - [config] Search the configuration of local messages.
  Future<ZIMMessagesSearchedResult> searchLocalMessages(
    String conversationID,
    ZIMConversationType conversationType,
    ZIMMessageSearchConfig config,
  );

  /// Search global local message list.
  ///
  /// Supported versions: 2.9.0 and above.
  /// Detailed description: This method is used to search global local messages.
  /// Business scenario: When there is a need to perform a global search of previous local messages based on keywords or other conditions, you can invoke this interface to search local messages by grouping them according to conversations.
  /// Restrictions: Effective after login, invalid after logout. Searching global is not supported in the room scene (conversationType=1).
  /// Related callbacks: [ZIMMessagesGlobalSearchedCallback].
  ///
  /// - [config] Search global the configuration of local messages.
  Future<ZIMMessagesGlobalSearchedResult> searchGlobalLocalMessages(
    ZIMMessageSearchConfig config,
  );

  /// add message reaction
  ///
  /// Available sinces: 2.28.0 and above.
  /// Detail description: Message reaction refers to the user's response to a message. It can generally be used to add or remove emoticons for single chat or group chat messages, as well as to initiate group voting, confirm group results, and other operations.
  /// Use cases: Users need to express their position on a certain message, such as liking, and this method can be used to express their position.
  /// Note: Room message reaction is not supported.
  /// Restrictions: You can only use it after logging in. And only supports message reactions for single chat and group chat
  /// Related callbacks: If the addition is successful, the [onMessageReactionsChanged] callback will be triggered. If the reaction is made to the latest message in the conversation, the [onConversationChanged] callback will be triggered when the addition is successful.
  ///
  /// - [reactionType] Type of reaction, defined by you, with a maximum length of 32 bytes.
  /// - [message] The message needs reaction.
  /// - [config] Added configuration for reactions. It now supports reacting multiple times to the same item and increases the aggregated count accordingly.
  Future<ZIMMessageReactionAddedResult> addMessageReaction({
    required String reactionType,
    required ZIMMessage message,
    ZIMMessageReactionAddConfig? config,
  });

  /// delete message reaction
  ///
  /// Available sinces: 2.10.0 and above.
  /// Detail description: Delete the reaction made by the local user.
  /// Use cases: Users need to delete the status of a message that has already been stated, which can be done using this method.
  /// Note: Room message reaction is not supported.
  /// Restrictions: You can only use it after logging in. And only supports message statements for single chat and group chat
  /// Related callbacks: If the deletion is successful, the [onMessageReactionsChanged] callback will be triggered. If the reaction is deleted from the latest message in the conversation, the [onConversationChanged] callback will be triggered when the addition is successful.
  ///
  /// - [reactionType] Reaction type. It must be the type of reaction made by the local user.
  /// - [message] The message needs reaction delete.
  Future<ZIMMessageReactionDeletedResult> deleteMessageReaction({
    required String reactionType,
    required ZIMMessage message,
  });

  /// Delete all of your reactions under this message
  ///
  /// Available sinces: 2.28.0 and above.
  /// Detail description: Delete the reaction made by the local user.
  /// Use cases: Users need to delete the status of a message that has already been stated, which can be done using this method.
  /// Note: Room message reaction is not supported.
  /// Restrictions: You can only use it after logging in. And only supports message statements for single chat and group chat
  /// Related callbacks: If the deletion is successful, the [onMessageReactionsChanged] callback will be triggered. If the reaction is deleted from the latest message in the conversation, the [onConversationChanged] callback will be triggered when the addition is successful.
  ///
  /// - [message] The message needs reaction delete.
  Future<void> deleteMessageAllReactions({required ZIMMessage message});

  /// query message reaction userlist
  ///
  /// Available sinces: 2.10.0 and above.
  /// Detail description: This method is used to query specific user information under a certain state of a message.
  /// Use cases: When it is necessary to obtain specific user information under a certain state of a message, this interface can be called to query state user messages in a paginated manner.
  /// Restrictions: You can only use it after logging in. And only supports message statements for single chat and group chat
  ///
  /// - [message] The message needs querying reaction user list.
  /// - [config] reaction user query config.
  Future<ZIMMessageReactionUserListQueriedResult> queryMessageReactionUserList(
    ZIMMessage message,
    ZIMMessageReactionUserQueryConfig config,
  );

  /// query combine message detail
  ///
  /// Available sinces: 2.14.0 and above.
  /// Detail description: This method is used to query the sub-messages of the combine message.
  /// Use cases: If you need to obtain the specific sub-messages under the combine message, you can call this API to query.
  /// Restrictions: You can only use it after logging in.
  ///
  /// - [message] The combine message needs querying message list.
  Future<ZIMCombineMessageDetailQueriedResult> queryCombineMessageDetail(
    ZIMCombineMessage message,
  );

  /// Reply message.
  ///
  /// - [message] The message needs to be sent.
  /// - [toOriginalMessage] The message needs to be replied.
  /// - [config] The configuration of the message needs to be sent.
  /// - [notification] The notification of the message needs to be sent.
  Future<ZIMMessageSentResult> replyMessage(
    ZIMMessage message,
    ZIMMessage toOriginalMessage,
    ZIMMessageSendConfig config,
    ZIMMessageSendNotification? notification,
  );

  /// Query message replied list.
  ///
  /// - [message] The message needs to be queried replied list.
  /// - [config] The configuration of the message needs to be queried replied list.
  Future<ZIMMessageRepliedListQueriedResult> queryMessageRepliedList(
    ZIMMessage message,
    ZIMMessageRepliedListQueryConfig config,
  );

  /// Pin message.
  ///
  /// - [message] The message needs to be pinned.
  /// - [isPinned] Whether to pin.
  /// - [config] Pinning configuration parameters.
  Future<void> pinMessage({
    required ZIMMessage message,
    required bool isPinned,
    ZIMMessagePinConfig? config,
  });

  /// Query pinned message list.
  ///
  /// - [conversationID] Conversation ID.
  /// - [conversationType] Conversation type.
  Future<ZIMPinnedMessageListQueriedResult> queryPinnedMessageList(
    String conversationID,
    ZIMConversationType conversationType,
  );

  /// Example Export the local message of the current user.
  ///
  /// Available sinces: 2.15.0 and above.
  /// Detail description: This method is used to export the local message of the current user.
  /// Use cases: It can be used to migrate local chat records by calling this interface to export local message files.
  /// Restrictions: You can only use it after logging in.
  /// Caution: The name of the message file exported by this interface is zim_backup_msg_text. If the passed in path is the same when calling this interface multiple times, the ZIM SDK will rename the old zim_backup_msg_text file by itself to ensure that the latest exported file name is zim_backup_msg_text.
  /// Related callbacks: [ZIMMessageExportedCallback].
  ///
  /// - [folderPath] The path of the export file to be output.
  /// - [config] todo
  /// - [progress] todo
  Future<void> exportLocalMessages(
    String folderPath,
    ZIMMessageExportConfig config,
    ZIMMessageExportingProgress progress,
  );

  /// Import local messages of the current user.
  ///
  /// Available sinces: 2.15.0 and above.
  /// Detail description: This method is used to import the local message of the current user.
  /// Use cases: It can be used to migrate local chat records by calling this interface to import local message files.
  /// Restrictions: You can only use it after logging in.
  /// Caution: The ZIM SDK reads a file named zim_backup_msg_text in the directory by default. If there are multiple backups in this path, please confirm whether the name of the file to be imported is zim_backup_msg_text.
  /// Related callbacks: [ZIMMessageImportedCallback].
  ///
  /// - [folderPath] The path of the import file to be output.
  /// - [config] todo
  /// - [progress] todo
  Future<void> importLocalMessages(
    String folderPath,
    ZIMMessageImportConfig config,
    ZIMMessageImportingProgress progress,
  );

  /// Query the local message cache of the current user.
  ///
  /// Supported versions: 2.15.0 and above.
  /// Detail description: Query the local message cache of the current user.
  /// Business scenario: This interface is invoked when the local message cache needs to be queried.
  /// Restrictions: This takes effect after the login and becomes invalid after the logout.
  /// Related callbacks: [ZIMFileCacheQueriedCallback].
  ///
  /// - [config] Query the cache configuration.
  Future<ZIMFileCacheQueriedResult> queryLocalFileCache(
    ZIMFileCacheQueryConfig config,
  );

  /// Clear the local message cache of the current user.
  ///
  /// Supported versions: 2.15.0 and above.
  /// Detail description: Clear the local message cache of the current user.
  /// Business scenario: This interface is invoked when the local message cache needs to be cleared.
  /// Restrictions: This takes effect after the login and becomes invalid after the logout.
  /// Related callbacks: [ZIMFileCacheClearedCallback].
  ///
  /// - [config] Clear the cache configuration.
  Future<void> clearLocalFileCache(ZIMFileCacheClearConfig config);

  /// Create a room with advanced settings
  ///
  /// Available since: 1.3.0.
  /// Description: Users can create and join rooms through this api, other users can join this room through [joinRoom] function.
  ///
  /// - [roomInfo] The configuration information of the room to be created.
  /// - [config] The advanced properties of the room to be created.
  Future<ZIMRoomCreatedResult> createRoom(
    ZIMRoomInfo roomInfo, [
    ZIMRoomAdvancedConfig? config,
  ]);

  /// Join a room.
  ///
  /// Available since: 1.1.0 or above.
  /// Description: If the room does not exist, the join fails and you need to call [createRoom] to create the room first.
  /// Use cases: In a multi-person chat scenario, users can call this interface to enter the room when they need to join the room.
  /// When to call: It can be called after creating a ZIM instance through [create].
  /// Caution: When everyone leaves the room, the room will be automatically destroyed.
  /// Related callbacks: The result of joining the room can be obtained through the [ZIMRoomJoinedCallback] callback.
  /// Related APIs: You can create a room with [createRoom] and leave the room with [leaveRoom].
  ///
  /// - [roomID] ID of the room to join.
  Future<ZIMRoomJoinedResult> joinRoom(String roomID);

  /// Enter the room. If the room does not exist, it will be created automatically.
  ///
  /// Supported version: 2.1.0.
  /// Detail description: After calling this API, If the room already exists, join the room directly; if the room does not exist, create a room and join. At the same time, if the room does not exist, after calling this interface, the room advanced properties set by the user will take effect.
  /// Business scenario: When you need to enter a multi-person chat scene with custom attributes, and you do not need to distinguish whether the room is created or added, you can enter a room through this interface.
  /// When to call: It can be called after logging in.
  /// Note: When everyone leaves the room, the room will be automatically destroyed, and a user can be in a maximum of 5 rooms at the same time. [enterRoom] is equivalent to [createRoom] and [joinRoom], so you only need to choose one of the APIs.
  /// Related callbacks: The result of entering the room can be obtained through the [onRoomEntered] callback.
  /// Related APIs: You can enter the room through [enterRoom], and leave the room through [leaveRoom].
  ///
  /// - [roomInfo] Configuration information for the room that will be created. Only the first user who enters the room creates roomName and takes effect.
  /// - [config] Advanced properties of the room that will be created. Only the first user who enters the room is configured to take effect.
  Future<ZIMRoomEnteredResult> enterRoom(
    ZIMRoomInfo roomInfo,
    ZIMRoomAdvancedConfig config,
  );

  /// Switch room.
  ///
  /// - [fromRoomID] ID of the source room to switch.
  /// - [toRoomInfo] Configuration information for the room to switch to.
  /// - [isCreateWhenRoomNotExisted] Whether to create the room if it does not exist.
  /// - [config] Advanced properties for the room to switch to.
  Future<ZIMRoomSwitchedResult> switchRoom(
    String fromRoomID,
    ZIMRoomInfo toRoomInfo,
    bool isCreateWhenRoomNotExisted,
    ZIMRoomAdvancedConfig config,
  );

  /// Leave a room.
  ///
  /// Available since: 1.1.0 or above.
  /// Description: When the user in the room needs to leave the room, use [leaveRoom] to leave the room. If the room does not exist, the leave fails.
  /// Use cases: In the multi-person chat scenario, when users in the room need to leave the room, they can leave the room through this interface.
  /// When to call: After creating a ZIM instance via [create], it can be called when the user is in the room.
  /// Caution: If the current user is not in this room, the exit fails. When everyone leaves the room, the room will be automatically destroyed.
  /// Related callbacks: The result of leaving the room can be obtained through the [ZIMRoomLeftCallback] callback.
  /// Related APIs: You can create a room through [createRoom] and join a room with [joinRoom].
  ///
  /// - [roomID] ID of the room to leave.
  Future<ZIMRoomLeftResult> leaveRoom(String roomID);

  /// Leave all rooms.
  ///
  /// Available since: 2.15.0 or above.
  /// Description: Call this interface to exit all rooms you have entered at once.
  /// When to call: After creating a ZIM instance via [create], it can be called when the user is in the room.
  /// Caution: If the current user is not in this room, leaving will fail; and calling this interface can only leave the room entered under the current terminal, and will not affect the rooms entered by other terminals with multi-terminal login.
  /// Related callbacks: The result of leaving the room can be obtained through the [ZIMRoomAllLeftCallback] callback.
  Future<ZIMRoomAllLeftResult> leaveAllRoom();

  /// Query the list of members in the room.
  ///
  /// Available since: 1.1.0 or above.
  /// Description: After joining a room, you can use this function to get the list of members in the room.
  /// Use cases: When a developer needs to obtain a list of room members for other business operations, this interface can be called to obtain a list of members.
  /// When to call: After creating a ZIM instance through [create], and the user is in the room that needs to be queried, you can call this interface.
  /// Caution: If the user is not currently in this room, the query fails. When there are more than 500 room members, the result of querying the list of room members can only contain the information of a maximum of 500 members.
  /// Related callbacks: Through the [ZIMRoomMemberQueriedCallback] callback, you can get the result of querying the room member list.
  /// Related APIs: You can check the online number of people in the room through [queryRoomOnlineMemberCount].
  ///
  /// - [roomID] ID of the room to query.
  /// - [config] Configuration of query room member operation.
  Future<ZIMRoomMemberQueriedResult> queryRoomMemberList(
    String roomID,
    ZIMRoomMemberQueryConfig config,
  );

  /// Query the information of the specified userID in the specified room.
  ///
  /// Available since: 2.8.0 and above.
  /// Description: This method can query the information of up to ten users in the specified room of the logged-in user.
  /// Use cases: When you need to know the user information in the specified room, you can call this interface to obtain the data source.
  /// When to call /Trigger: Can be invoked after login.
  /// Restrictions: Available after login, unavailable after logout, up to ten users can be queried at one time.
  ///
  /// - [userIDs] List of user IDs to query.
  /// - [roomID] The room ID of the specified room.
  Future<ZIMRoomMembersQueriedResult> queryRoomMembers(
    List<String> userIDs,
    String roomID,
  );

  /// Query the number of online members in the room.
  ///
  /// Available since: 1.1.0 or above.
  /// Description: After joining a room, you can use this function to get the number of online members in the room.
  /// Use cases: When a developer needs to obtain the number of room members who are online, this interface can be called.
  /// Calling time: After creating a ZIM instance through [create], and the user is in the room that needs to be queried, this interface can be called.
  /// Caution: If the user is not currently in this room, the query will fail.
  /// Related callbacks: The result of querying the online number of room members can be obtained through the [ZIMRoomOnlineMemberCountQueriedCallback] callback.
  /// Related APIs: the room member can be inquired through [queryRoomMember].
  ///
  /// - [roomID] ID of the room to query.
  Future<ZIMRoomOnlineMemberCountQueriedResult> queryRoomOnlineMemberCount(
    String roomID,
  );

  /// Set room attributes (use this for all additions and changes).
  ///
  /// Available since: 1.3.0.
  /// Description: Used to set room properties.
  /// Use cases: This interface is used when you need to set the mic bit in a chat room.
  /// When to call /Trigger: after login, and in the relevant room to call.
  /// Restrictions: You can set a maximum of 20 properties per room.
  /// Notice: Key-value of the room property. The default key length is 16 and the default value length is 1024.
  /// Default value: [ZIMRoomAttributesSetConfig] the space-time of the default configuration is optional, and do not update the owner, and involves the room properties in the owner is not automatically deleted after exit.
  /// Privacy reminder: Try not to introduce sensitive information related to personal privacy into the property of the room, including but not limited to mobile phone number, ID number, passport number, real name, etc.
  /// Privacy reminder: Adds or modifies room properties to an existing room.
  /// Related callbacks: [ZIMRoomAttributesOperatedCallback].
  /// Related APIs: [DeleteRoomAttributes] to delete room attributes. [QueryRoomAllAttributes], queries the room attributes.
  ///
  /// - [roomAttributes] Room attributes to be set.
  /// - [roomID] To modify the room number of the room attribute.
  /// - [config] Behavior configuration of the operation.
  Future<ZIMRoomAttributesOperatedCallResult> setRoomAttributes(
    Map<String, String> roomAttributes,
    String roomID,
    ZIMRoomAttributesSetConfig config,
  );

  /// Delete room attributes.
  ///
  /// Available since: 1.3.0.
  /// Description: Used to delete room attributes.
  ///
  /// - [keys] The key of the room attribute to be deleted.
  /// - [roomID] To modify the room number of the room attribute
  /// - [config] Behavior configuration of the operation.
  Future<ZIMRoomAttributesOperatedCallResult> deleteRoomAttributes(
    List<String> keys,
    String roomID,
    ZIMRoomAttributesDeleteConfig config,
  );

  /// Open combination room attribute operation.
  ///
  /// Available since:  1.3.0.
  /// Description: Used to turn on the combination of room attributes.
  ///
  /// - [roomID] The number of the room where the combined operation needs to be turned on.
  /// - [config] The configuration of the combined operation.
  void beginRoomAttributesBatchOperation(
    String roomID,
    ZIMRoomAttributesBatchOperationConfig config,
  );

  /// Complete the property operation of the combined room.
  ///
  /// Available since: 1.3.0.
  /// Description: After completing the operation of combining room attributes, all the setting/deleting operations from the last call to beginRoomAttributesBatchOperation to this operation will be completed for the room.
  ///
  /// - [roomID] To modify the room number of the room attribute.
  Future<ZIMRoomAttributesBatchOperatedResult> endRoomAttributesBatchOperation(
    String roomID,
  );

  /// Query all properties of the room.
  ///
  /// Available since: 1.3.0.
  /// Description: Used to query room attributes.
  ///
  /// - [roomID] Need to query the room number of the custom attributes.
  Future<ZIMRoomAttributesQueriedResult> queryRoomAllAttributes(String roomID);

  /// Set room member attributes (use this for all additions and changes).
  ///
  /// Supported Versions: 2.4.0 and above.
  /// Detail description: Call this API to set room user properties of members in the room.
  /// Business scenario: If you need to set a level for members in the room, you can use this interface to set a state.
  /// Default: [ZIMRoomMemberAttributesSetConfig] Default constructor isDeleteAfterOwnerLeft is true.
  /// Call timing: After logging in and calling in the relevant room.
  /// Usage limit: A maximum of 500 user attributes can be set in each room and stored in the key-value mode. If you need to increase the attribute limit, please contact ZEGO technical support. The total length of user attribute key-values owned by each user in a room cannot exceed 144 bytes, and the number of key-values cannot exceed 30 pairs. The length of a single key-value cannot exceed 8 bytes for a Key and 64 bytes for a Value. If you need to raise the cap, please contact ZEGO technical support. After the room is destroyed, the user-defined user properties are also destroyed.
  /// Relevant callbacks: [ZIMRoomMembersAttributesOperatedCallback],[onRoomMemberAttributesUpdated].
  /// Related interfaces: [queryRoomMembersAttributes], [queryRoomMemberAttributesList].
  ///
  /// - [attributes] Room member attributes to be set.
  /// - [userIDs] A list of userIDs to set.
  /// - [roomID] Room ID.
  /// - [config] Behavior configuration of the operation.
  Future<ZIMRoomMembersAttributesOperatedResult> setRoomMembersAttributes(
    Map<String, String> attributes,
    List<String> userIDs,
    String roomID,
    ZIMRoomMemberAttributesSetConfig config,
  );

  /// Batch query the room user attributes of the members in the room.
  ///
  /// Available since:2.4.0 or later.
  /// Description:Call this API to batch query the room user attributes of the members in the room.
  /// Use cases:Use this interface when you need to specify that you want to query some room users.
  /// Restrictions:The maximum call frequency is 5 times within 30 seconds by default, and the maximum query time is 100 people.
  /// Related callbacks:[ZIMRoomMembersAttributesQueriedCallback].
  /// Related APIs: [setRoomMembersAttributes]、[queryRoomMemberAttributesList].
  /// Runtime lifecycle: It is available after logging in and joining the corresponding room, but unavailable after leaving the corresponding room.
  ///
  /// - [userIDs] A list of userIDs to query.
  /// - [roomID] Room ID.
  Future<ZIMRoomMembersAttributesQueriedResult> queryRoomMembersAttributes(
    List<String> userIDs,
    String roomID,
  );

  /// paginate the room user properties that have room property members in the room.
  ///
  /// Available since:2.4.0 or later.
  /// Description:paginate the room user properties that have room property members in the room.
  /// Use cases:This interface is used when you need to query all room users.
  /// Restrictions:The maximum call frequency is 5 times within 30 seconds by default, and the maximum query time is 100 people.
  /// Related callbacks:[ZIMRoomMemberAttributesListQueriedCallback].
  /// Related APIs: [setRoomMembersAttributes]、[queryRoomMembersAttributes].
  /// Runtime lifecycle: It is available after logging in and joining the corresponding room, but unavailable after leaving the corresponding room.
  ///
  /// - [roomID] Room ID.
  /// - [config] Behavior configuration of the operation.
  Future<ZIMRoomMemberAttributesListQueriedResult>
      queryRoomMemberAttributesList(
    String roomID,
    ZIMRoomMemberAttributesQueryConfig config,
  );

  /// Create a group with the andvanced info such as group attributes and group notice.
  ///
  /// Available since: 2.0.0 and above.
  /// Description: You can call this interface to create a group, and the person who calls this interface is the group leader.
  /// Use cases: You can use this interface to create a chat scenario and join a group.
  /// When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  /// Caution: Available after login, unavailable after logout. UserIDs can have a maximum of 100 users and a group can have a maximum of 500 users.
  /// Related callbacks: The result of creating the group is obtained through the [ZIMGroupCreatedCallback] callback.
  /// Related APIs: You can use [joinGroup] to join a group, [leaveGroup] to leave a group, or [dismissGroup] to dismiss a group.
  ///
  /// - [groupInfo] Configuration information for the group to be created.
  /// - [userIDs] List of users invited to the group.
  /// - [config] Create the relevant configuration of the group.
  Future<ZIMGroupCreatedResult> createGroup(
    ZIMGroupInfo groupInfo,
    List<String> userIDs, [
    ZIMGroupAdvancedConfig? config,
  ]);

  ///  Available since: 2.0.0 and above.
  ///
  ///  Description: When a group is created, you can use [dismissGroup] to dismiss it.
  ///
  ///  Use cases: After you create a chat group, you do not need to use this interface to dissolve the group.
  ///
  ///  When to call /Trigger: This parameter can be called after a group is created by using [createGroup].
  ///
  ///  Caution: A non-group owner cannot dissolve a group.
  ///
  ///  Impacts on other APIs: Through callback can get [ZIMGroupDismissedCallback] dissolution results of the room, through [onGroupStateChanged] listen callback can get the room status.
  ///
  ///  Related callbacks: You can use [createGroup] to create a group, [joinGroup] to join a group, and [leaveGroup] to leave a group.
  ///
  ///  - groupID The ID of the group to be disbanded.
  ///  - callback  Callback for the result of disbanding the group.
  ///
  /// - [groupID] groupID
  Future<ZIMGroupDismissedResult> dismissGroup(String groupID);

  ///  Available since: 2.0.0 and above.
  ///
  ///  Description: After a group is created, other users can use [joinGroup] to join the group.
  ///
  ///  Use cases: This interface is used to join a group in a chat scenario.
  ///
  ///  When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  ///  Caution: Available after login, unavailable after logout. If you have joined a group, the join succeeds. A group is limited to 500 people and fails to join when it is full.
  ///
  ///  Related callbacks: To get the result of joining the room, call [ZIMGroupJoinedCallback].
  ///
  ///  Related APIs: You can use [createGroup] to create a group, [leaveGroup] to leave a group, or [dismissGroup] to dismiss a group.
  ///
  ///  - groupID The group ID to join.
  ///  - callback  Callback for the result of joining the group.
  ///
  /// - [groupID] groupID
  Future<ZIMGroupJoinedResult> joinGroup(String groupID);

  ///  Available since: 2.0.0 and above.
  ///
  ///  Description: After a user joins a group, the user can leave the group through this interface.
  ///
  ///  Use cases: This interface is used to exit a chat group.
  ///
  ///  When to call /Trigger: It can be invoked after a ZIM instance is created through [create] and logged in.
  ///
  ///  Restrictions: Available after login, unavailable after logout.
  ///
  ///  Caution: When the group owner quits the group, the identity of the group owner will be automatically transferred to the earliest member who joined the group. When all members exit the group, the group is automatically dissolved.
  ///
  ///  Impacts on other APIs: You can use [createGroup] to create a group, [joinGroup] to join a group, or [dismissGroup] to dismiss a group.
  ///
  ///  Related callbacks: The result of leaving the room can be obtained by the [ZIMGroupLeftCallback] callback.
  ///
  ///  - groupID The group ID to leave.
  ///  - callback  Callback for the result of leaving the group.
  ///
  /// - [groupID] groupID
  Future<ZIMGroupLeftResult> leaveGroup(String groupID);

  ///  Available since: 2.0.0 and above.
  ///
  ///  Description: After a group is created, users can add multiple users to the group through this interface. The interface can be invoked by both the master and members of the group.
  ///  Use cases: This interface allows you to invite others to join a group chat.
  ///  When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///  Restrictions: The maximum number of userIDs users can join the group is 100. If the number of users reaches 100, the interface callback will notify the user. The maximum number of people in a group is 500.
  ///  Caution: This interface does not require the peer's consent or the peer's online status. The service layer determines the number of invited users.
  ///  Related callbacks: Through the callback [ZIMGroupUserInvitedCallback] can add multiple users into the group's results.
  ///  Related APIs: KickGroupMember can be used to kick a target user out of the group.
  ///
  /// - [userIDs] userIDs
  /// - [groupID] groupID
  Future<ZIMGroupUsersInvitedResult> inviteUsersIntoGroup(
    List<String> userIDs,
    String groupID,
  );

  ///  Available since: 2.0.0 and above.
  ///  Description: After a user joins a group, you can use this method to remove the user from the group.
  ///  Use cases: You can use this method to remove one or more users from the group.
  ///  When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///  Restrictions: You can't kick someone unless you're the leader of the group.
  ///  Caution: This interface does not require the peer's consent or the peer's online status. It cannot accept group-related callbacks after being kicked out. History messages and sessions remain after being kicked out and can still enter the group.
  ///  Related callbacks: Through the callback [ZIMGroupMemberKickedCallback] can get the user kicked out the results of the group.
  ///  Related APIs: You can invite a target user into a group through [inviteUsersIntoGroup].
  ///
  /// - [userIDs] userIDs
  /// - [groupID] groupID
  Future<ZIMGroupMemberKickedResult> kickGroupMembers(
    List<String> userIDs,
    String groupID,
  );

  ///  Available since: 2.0.0 and above.
  ///  Description: After a group is created, the group owner can use this method to assign the group owner to a specified user.
  ///  Use cases: In a group chat scenario, you can transfer the group master through this interface.
  ///  When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///  Restrictions: You cannot transfer a group owner if you are not a group owner.
  ///  Related APIs: Through the callback [ZIMGroupOwnerTransferredCallback] can get the result of the transfer of the group manager.
  ///
  /// - [toUserID] toUserID
  /// - [groupID] groupID
  Future<ZIMGroupOwnerTransferredResult> transferGroupOwner(
    String toUserID,
    String groupID,
  );

  /// todo
  ///
  ///  Available since: 2.0.0 and above.
  ///
  ///  Description: Query information about a created group.
  ///
  ///  Use cases: You need to obtain group information for display.
  ///
  ///  When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  ///  Related callbacks: Through the callback [ZIMGroupInfoQueriedCallback] can query the result of the group information.
  ///
  ///  - groupID The group ID of the group information to be queried.
  ///  - callback Callback for the result of querying group information.
  ///
  /// - [groupID] groupID
  Future<ZIMGroupInfoQueriedResult> queryGroupInfo(String groupID);

  ///  Available since: 2.0.0 and above.
  ///
  ///  Description: After a group is created, you can use this method to query information about a specified group member.
  ///
  ///  Use cases: You need to obtain the specified group member information for display or interaction.
  ///
  ///  When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  ///  Restrictions: Available after login, unavailable after logout.
  ///
  ///  Related callbacks: Through the callback [ZIMGroupMemberInfoQueriedCallback] can get the query specifies the result of group membership information.
  ///
  ///  - userID User ID of the queried member information.
  ///  - groupID The ID of the group whose member information will be queried.
  ///  - callback Callback for the result of querying group member information.
  ///
  /// - [userID] userID
  /// - [groupID] groupID
  Future<ZIMGroupMemberInfoQueriedResult> queryGroupMemberInfo(
    String userID,
    String groupID,
  );

  ///  Available since: 2.27.0 and above.
  ///  Description: Query the list of all groups.
  ///  Use cases: You need to get a list of groups to display.
  ///  When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///  Restrictions: Available after login, unavailable after logout.
  ///  Related callbacks: Through the callback [ZIMGroupListQueiedCallback] can get a check list of all current group results.
  ///
  /// - [count] count
  /// - [config] config
  Future<ZIMGroupListQueriedResult> queryGroupList({
    int? count,
    ZIMGroupListQueryConfig? config,
  });

  ///  Available since: 2.0.0 and above.
  ///
  ///  Description: After a group is created, you can use this method to query the group member list.
  ///
  ///  Use cases: You need to obtain the specified group member list for display or interaction.
  ///
  ///  When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  ///  Restrictions: Available after login, unavailable after logout.
  ///
  ///  Related callbacks: Through the callback [ZIMGroupMemberListQueriedCallback] can query the result of the group member list.
  ///
  ///  - groupID The group ID of the group member list to be queried.
  ///  - config Group member query configuration.
  ///  - callback Callback for querying the list of group members.
  ///
  /// - [groupID] groupID
  /// - [config] config
  Future<ZIMGroupMemberListQueriedResult> queryGroupMemberList(
    String groupID,
    ZIMGroupMemberQueryConfig config,
  );

  ///  Available since: 2.2.0 or above.
  ///
  ///  Description: Query the number of group members in a group.
  ///
  ///  When to call: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  ///  Restrictions: This function can only query the group that the user has entered.
  ///
  ///  Related callbacks: [ZIMGroupMemberCountQueriedCallback].
  ///
  ///  - groupID The group ID of the group to be queried.
  ///  - callback Callback for querying the number of groups.
  ///
  /// - [groupID] groupID
  Future<ZIMGroupMemberCountQueriedResult> queryGroupMemberCount(
    String groupID,
  );

  ///  Available since: 2.0.0 and above.
  ///  Description: After a group is created, users can call this method to change the group name.
  ///  Use cases: After creating a group, you need to change the group name.
  ///  When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///  Restrictions: Group members and group owners can change the group name. The maximum length of the name is 100 bytes.
  ///  Related APIs: Through the callback [ZIMGroupNameUpdatedCallback] can get the result of the change of name, through [onGroupNoticeUpdated] can get update group name information.
  ///
  /// - [groupName] groupName
  /// - [groupID] groupID
  Future<ZIMGroupNameUpdatedResult> updateGroupName(
    String groupName,
    String groupID,
  );

  /// todo
  ///
  ///  Supported versions: 2.3.0 and above.
  ///  Detail description: After a group is created, the user can modify the group avatar URL by calling this method.
  ///  Business scenario: After creating a group, the user needs to change the group avatar URL.
  ///  Invocation timing/notification timing: It can be invoked after creating a ZIM instance through [create] and logging in.
  ///  Usage restrictions: Group members and group owners can modify the group avatar, with a maximum length of 500 bytes.
  ///  Related callbacks: The result of changing the group name can be obtained through the [ZIMGroupAvatarUrlUpdatedCallback] callback, and the updated group avatar information can be obtained through the [groupAvatarUrlUpdated] callback.
  ///
  /// - [groupAvatarUrl] groupAvatarUrl
  /// - [groupID] groupID
  Future<ZIMGroupAvatarUrlUpdatedResult> updateGroupAvatarUrl(
    String groupAvatarUrl,
    String groupID,
  );

  /// todo
  ///
  ///  Available since: 2.0.0 and above.
  ///  Description: When a group is created, users can use this method to update the group bulletin.
  ///  Use cases: You need to update the group bulletin in the group.
  ///  When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///  Restrictions: Only group members can update the group bulletin. The maximum number of bytes is 300. There is no special character limit.
  ///  Related callbacks: Through callback [ZIMGroupNoticeUpdateCallback] can get update group of the results announcement, announcement by [onGroupNoticeUpdated] can get update group information.
  ///
  /// - [groupNotice] groupNotice
  /// - [groupID] groupID
  Future<ZIMGroupNoticeUpdatedResult> updateGroupNotice(
    String groupNotice,
    String groupID,
  );

  /// todo
  ///
  /// - [groupAlias] groupAlias
  /// - [groupID] groupID
  Future<ZIMGroupAliasUpdatedResult> updateGroupAlias(
    String groupAlias,
    String groupID,
  );

  ///  Available since: 2.15.0 and above.
  ///  Description: When a group is created, the group owner and administrators can use this method to update the group verification mode.
  ///  Use cases: You need to update the group bulletin in the group.
  ///  When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// - [mode] mode
  /// - [groupID] groupID
  Future<ZIMGroupJoinModeUpdatedResult> updateGroupJoinMode(
    ZIMGroupJoinMode mode,
    String groupID,
  );

  /// Available since: 2.15.0 and above.
  /// Description: When a group is created, the group owner and administrators can use this method to update the group verification mode.
  /// When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// - [mode] mode
  /// - [groupID] groupID
  Future<ZIMGroupInviteModeUpdatedResult> updateGroupInviteMode(
    ZIMGroupInviteMode mode,
    String groupID,
  );

  ///  Available since: 2.15.0 and above.
  ///  Description: When a group is created, the group owner and administrators can use this method to update the group verification mode.
  ///  Use cases: You need to update the group bulletin in the group.
  ///  When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///
  /// - [mode] mode
  /// - [groupID] groupID
  Future<ZIMGroupBeInviteModeUpdatedResult> updateGroupBeInviteMode(
    ZIMGroupBeInviteMode mode,
    String groupID,
  );

  /// todo
  ///
  ///  Available since: 2.0.0 and above.
  ///  Description: If a group already exists, all users of the group can use this method to set group properties.
  ///  Use cases: Added extended field information about group description, such as group family, label, and industry category.
  ///  When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///  Restrictions: Only group members can set group properties.
  ///  Related callbacks: Through the callback [ZIMGroupAttributesOperatedCallback] can get the result of the set of properties.
  ///  Related APIs: [deleteGroupAttributes] can be used to deleteGroupAttributes, [queryGroupAttributes] can be used to queryGroupAttributes, [queryAllGroupAttributes] can be used to queryAllGroupAttributes.
  ///
  /// - [groupAttributes] groupAttributes
  /// - [groupID] groupID
  Future<ZIMGroupAttributesOperatedResult> setGroupAttributes(
    Map<String, String> groupAttributes,
    String groupID,
  );

  /// todo
  ///
  ///  Available since: 2.0.0 and above.
  ///  Description: When a group already exists, you can use this method to delete group attributes. Both the master and members of the interface group can be invoked.
  ///  Use cases: Deleted the extended field of the group description.
  ///  When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///  Restrictions: Only group members can delete group attributes.
  ///  Related callbacks: Through the callback [ZIMGroupAttributesOperatedCallback] can delete the result of the group of attributes.
  ///  Related APIs: You can use [setGroupAttributes] to setGroupAttributes, [queryGroupAttributes] to queryGroupAttributes, and [queryAllGroupAttributes] to queryAllGroupAttributes.
  ///
  /// - [keys] keys
  /// - [groupID] groupID
  Future<ZIMGroupAttributesOperatedResult> deleteGroupAttributes(
    List<String> keys,
    String groupID,
  );

  /// todo
  ///
  ///  Available since: 2.0.0 and above.
  ///  Description: After a group is created, you can use this method to query the specified group properties.
  ///  Use cases: You need to query the scenarios to display the specified group attributes.
  ///  When to call /Trigger: After creating a ZIM instance with [create] and logging in with [login].
  ///  Restrictions: Available after login, unavailable after logout.
  ///  Related callbacks: Through the callback [ZIMGroupAttributesQuriedCallback] can get query attributes of the specified group of results.
  ///  Related APIs: [queryAllGroupAttributes] Queries all group attributes.
  ///
  /// - [keys] keys
  /// - [groupID] groupID
  Future<ZIMGroupAttributesQueriedResult> queryGroupAttributes(
    List<String> keys,
    String groupID,
  );

  /// todo
  ///
  ///  Available since: 2.0.0 and above.
  ///  Description: After a group is created, you can use this method to query the specified group properties.
  ///  Use cases: You need to query the scenarios to display the specified group attributes.
  ///  When to call /Trigger: After creating a ZIM instance with [create] and logging in with [login].
  ///  Restrictions: Available after login, unavailable after logout.
  ///  Related callbacks: Through the callback [ZIMGroupAttributesQuriedCallback] can get query attributes of the specified group of results.
  ///  Related APIs: [queryAllGroupAttributes] Queries all group attributes.
  ///
  /// - [groupID] groupID
  Future<ZIMGroupAttributesQueriedResult> queryGroupAllAttributes(
    String groupID,
  );

  /// todo
  ///
  ///  Available since: 2.0.0 and above.
  ///  Description: After a group is created, you can use this method to set the roles of group members.
  ///  Use cases: The ZIM instance can be invoked after being created by [create] and logged in.
  ///  When to call /Trigger: If the primary role of a group is 1 and the default role of other members is 3, you can invoke this interface to change the role.
  ///  Caution: Non-group master unavailable.
  ///  Related callbacks: Through the callback [ZIMGroupMemberRoleUpdatedCallback] can be set up to get the results of the group of members of the role.
  ///
  /// - [role] role
  /// - [forUserID] forUserID
  /// - [groupID] groupID
  Future<ZIMGroupMemberRoleUpdatedResult> setGroupMemberRole(
    int role,
    String forUserID,
    String groupID,
  );

  /// todo
  ///
  ///  Available since: 2.0.0 and above.
  ///  Description: After a group is created, you can use this method to set nicknames for group members.
  ///  Use cases: Nicknames need to be set for group members.
  ///  When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///  Restrictions: Available after login, unavailable after logout. The owner of a group can change his or her own nickname, while the members can change only their own nickname.
  ///  Caution: A group name can contain a maximum of 100 characters.
  ///  Related callbacks: Through the callback [ZIMGroupMemberNicknameUpdatedCallback] can be set up to get the results of the group members nickname.
  ///
  /// - [nickname] nickname
  /// - [forUserID] forUserID
  /// - [groupID] groupID
  Future<ZIMGroupMemberNicknameUpdatedResult> setGroupMemberNickname(
    String nickname,
    String forUserID,
    String groupID,
  );

  /// Mute a group.
  ///
  ///  Available since: 2.14.0 and above.
  ///  Description: Once a group is created, the group administrator can call this interface to implement group muting and unmuting.
  ///  Use cases: After creating a group, users need to change the mute status of the group.
  ///  When to call /Trigger: This can be called after a ZIM instance is created using [create] and logged into the group.
  ///  Restrictions: This can be called by the group owner and group administrators.
  ///  Related callbacks: The result of changing the group mute status can be obtained through the [ZIMGroupMutedCallback] callback. The updated group mute status information can be obtained through [onGroupMuteInfoUpdated].
  ///
  /// - [isMute] isMute
  /// - [groupID] groupID
  /// - [config] config
  Future<ZIMGroupMutedResult> muteGroup(
    bool isMute,
    String groupID,
    ZIMGroupMuteConfig config,
  );

  /// Mute group members.
  ///
  ///  Available since: 2.14.0 and above.
  ///  Description: Once a group is created, the group administrator can call this interface to implement group members muting and unmuting.
  ///  Use cases: After creating a group, users need to change the mute status of the group members.
  ///  When to call /Trigger: This can be called after a ZIM instance is created using [create] and logged into the group.
  ///  Restrictions: This can be called by the group owner and group administrators.
  ///  Related callbacks: The result of changing the group members mute status can be obtained through the [ZIMGroupMembersMutedCallback] callback. The updated group members mute status information can be obtained through [onGroupMemberInfoUpdated].
  ///
  /// - [isMute] isMute
  /// - [userIDs] userIDs
  /// - [groupID] groupID
  /// - [config] config
  Future<ZIMGroupMembersMutedResult> muteGroupMembers(
    bool isMute,
    List<String> userIDs,
    String groupID,
    ZIMGroupMemberMuteConfig config,
  );

  /// Query the list of group muted members.
  ///
  ///  Available since: 2.14.0 and above.
  ///  Description: After a group is created, you can use this method to query the group muted member list.
  ///  Use cases: You need to obtain the specified group muted member list for display or interaction.
  ///  When to call /Trigger: The ZIM instance can be invoked after being created by [create] and logged in.
  ///  Restrictions: Available after login, unavailable after logout.
  ///  Related callbacks: Through the callback [ZIMGroupMembersMutedCallback] can query the result of the group muted member list.
  ///
  /// - [groupID] groupID
  /// - [config] config
  Future<ZIMGroupMemberMutedListQueriedResult> queryGroupMemberMutedList(
    String groupID,
    ZIMGroupMemberMutedListQueryConfig config,
  );

  ///  Available since: 2.5.0 and above.
  ///
  ///  Description: This method can query the specific read member list of a message sent by a group.
  ///
  ///  Use cases: Developers can use this method to query the specific read member list of a message they send.
  ///
  ///  When to call: Callable after login.
  ///
  ///  Restrictions: only supports querying the messages sent by the local end, and the receipt status of the messages is not NONE and UNKNOWN. If the user is not in the group, or has been kicked out of the group, the corresponding member list cannot be found.
  ///
  /// Related callbacks: [ZIMGroupMessageReceiptMemberListQueriedCallback].
  ///
  ///  Related APIs: If you need to query the receipt status of a certain message or only need to query the read/unread count, you can query through the interface [queryMessageReceiptsInfo].
  ///
  /// - [message] message
  /// - [groupID] groupID
  /// - [config] config
  Future<ZIMGroupMessageReceiptMemberListQueriedResult>
      queryGroupMessageReceiptReadMemberList(
    ZIMMessage message,
    String groupID,
    ZIMGroupMessageReceiptMemberQueryConfig config,
  );

  ///  Available since: 2.5.0 and above.
  ///
  ///  Description: This method can query the specific unread member list of a message sent by a group.
  ///
  ///  Use cases: Developers can use this method to query the specific unread member list of a message they send.
  ///
  ///  When to call: Callable after login.
  ///
  ///  Restrictions: only supports querying the messages sent by the local end, and the receipt status of the messages is not NONE and UNKNOWN. If the user is not in the group, or has been kicked out of the group, the corresponding member list cannot be found.
  ///
  ///  Related callbacks: [ZIMGroupMessageReceiptMemberListQueriedCallback].
  ///
  ///  Related APIs: If you need to query the receipt status of a certain message or only need to query the read/unread count, you can query through the interface [queryMessageReceiptsInfo].
  ///
  /// - [message] message
  /// - [groupID] groupID
  /// - [config] config
  Future<ZIMGroupMessageReceiptMemberListQueriedResult>
      queryGroupMessageReceiptUnreadMemberList(
    ZIMMessage message,
    String groupID,
    ZIMGroupMessageReceiptMemberQueryConfig config,
  );

  ///  Search local group members.
  ///
  ///  Supported versions: 2.9.0 and above.
  ///
  ///  Detailed description: This method is used to search for local groups.
  ///
  ///  Business scenario: When you need to search for local groups by keywords or other criteria, you can call this interface to search.
  ///
  ///  Call timing/Notification timing: After calling [login]
  ///
  ///  Restrictions: Takes effect after login, becomes invalid after logout.
  ///
  ///  - config Configuration for searching groups.
  ///  - callback Callback of the search groups result.
  ///
  /// - [config] config
  Future<ZIMGroupsSearchedResult> searchLocalGroups(
    ZIMGroupSearchConfig config,
  );

  ///  Search local group members.
  ///
  ///  Supported versions: 2.9.0 and above.
  ///
  ///  Detailed description: This method is used to search for group members.
  ///
  ///  Business scenario: When you need to search for local group members by keywords or other criteria, you can call this interface to search.
  ///
  ///  Restrictions: Takes effect after login, becomes invalid after logout.
  ///
  ///  Related callbacks: [ZIMGroupMembersSearchedCallback].
  ///
  ///  - groupID Group ID of the joined group.
  ///  - config The configuration for searching group members.
  ///  - callback The configuration for searching group members.
  ///
  /// - [groupID] groupID
  /// - [config] config
  Future<ZIMGroupMembersSearchedResult> searchLocalGroupMembers(
    String groupID,
    ZIMGroupMemberSearchConfig config,
  );

  /// todo
  ///
  /// - [groupID] groupID
  /// - [config] config
  Future<ZIMGroupJoinApplicationSentResult> sendGroupJoinApplication(
    String groupID,
    ZIMGroupJoinApplicationSendConfig config,
  );

  /// todo
  ///
  /// - [userID] userID
  /// - [groupID] groupID
  /// - [config] config
  Future<ZIMGroupJoinApplicationAcceptedResult> acceptGroupJoinApplication(
    String userID,
    String groupID,
    ZIMGroupJoinApplicationAcceptConfig config,
  );

  /// todo
  ///
  /// - [userID] userID
  /// - [groupID] groupID
  /// - [config] config
  Future<ZIMGroupJoinApplicationRejectedResult> rejectGroupJoinApplication(
    String userID,
    String groupID,
    ZIMGroupJoinApplicationRejectConfig config,
  );

  /// todo
  ///
  /// - [userIDs] userIDs
  /// - [groupID] groupID
  /// - [config] config
  Future<ZIMGroupInviteApplicationsSentResult> sendGroupInviteApplications(
    List<String> userIDs,
    String groupID,
    ZIMGroupInviteApplicationSendConfig config,
  );

  /// todo
  ///
  /// - [inviterUserID] inviterUserID
  /// - [groupID] groupID
  /// - [config] config
  Future<ZIMGroupInviteApplicationAcceptedResult> acceptGroupInviteApplication(
    String inviterUserID,
    String groupID,
    ZIMGroupInviteApplicationAcceptConfig config,
  );

  /// todo
  ///
  /// - [inviterUserID] inviterUserID
  /// - [groupID] groupID
  /// - [config] config
  Future<ZIMGroupInviteApplicationRejectedResult> rejectGroupInviteApplication(
    String inviterUserID,
    String groupID,
    ZIMGroupInviteApplicationRejectConfig config,
  );

  /// todo
  ///
  /// - [config] config
  Future<ZIMGroupApplicationListQueriedResult> queryGroupApplicationList(
    ZIMGroupApplicationListQueryConfig config,
  );

  ///  Supported versions: 2.0.0 and above.
  ///  Detail description: When the caller initiates a call invitation, the called party can use [callAccept] to accept the call invitation or [callReject] to reject the invitation.
  ///  Business scenario: When you need to initiate a call invitation, you can create a unique callid through this interface to maintain this call invitation.
  ///  When to call: It can be called after creating a ZIM instance through [create].
  ///  Note: The call invitation has a timeout period, and the call invitation will end when the timeout period expires.
  ///
  /// - [invitees] invitees
  /// - [config] config
  Future<ZIMCallInvitationSentResult> callInvite(
    List<String> invitees,
    ZIMCallInviteConfig config,
  );

  ///  Supported versions: 2.0.0 and above.
  ///  Detail description: After the caller initiates a call invitation, the call invitation can be canceled through this interface before the timeout period.
  ///  Business scenario: When you need to cancel the call invitation initiated before, you can cancel the call invitation through this interface.
  ///  When to call: It can be called after creating a ZIM instance through [create].
  ///  Note: Canceling the call invitation after the timeout period of the call invitation expires will fail.
  ///
  /// - [invitees] invitees
  /// - [callID] callID
  /// - [config] config
  Future<ZIMCallCancelSentResult> callCancel(
    List<String> invitees,
    String callID,
    ZIMCallCancelConfig config,
  );

  ///  Supported versions: 2.0.0 and above.
  ///
  ///  Detail description: When the calling party initiates a call invitation, the called party can accept the call invitation through this interface.
  ///
  ///  Service scenario: When you need to accept the call invitation initiated earlier, you can accept the call invitation through this interface.
  ///
  ///  When to call: It can be called after creating a ZIM instance through [create].
  ///
  ///  Note: The callee will fail to accept an uninvited callid.
  ///
  ///  - callID The call invitation ID to accept.
  ///  - config  config.
  ///  - callback Callback to accept call invitation.
  ///
  /// - [callID] callID
  /// - [config] config
  Future<ZIMCallAcceptanceSentResult> callAccept(
    String callID,
    ZIMCallAcceptConfig config,
  );

  ///  Supported versions: 2.0.0 and above.
  ///
  ///  Detail description: When the calling party initiates a call invitation, the called party can reject the call invitation through this interface.
  ///
  ///  Service scenario: When you need to reject the call invitation initiated earlier, you can use this interface to reject the call invitation.
  ///
  ///  When to call: It can be called after creating a ZIM instance through [create].
  ///
  ///  Note: The callee will fail to reject the uninvited callid.
  ///
  ///  - callID The ID of the call invitation to be rejected.
  ///  - config Related configuration for rejecting call invitations.
  ///  - callback Callback for rejecting call invitations.
  ///
  /// - [callID] callID
  /// - [config] config
  Future<ZIMCallRejectionSentResult> callReject(
    String callID,
    ZIMCallRejectConfig config,
  );

  /// todo
  ///
  /// - [invitees] invitees
  /// - [callID] callID
  /// - [config] config
  Future<ZIMCallingInvitationSentResult> callingInvite(
    List<String> invitees,
    String callID,
    ZIMCallingInviteConfig config,
  );

  /// todo
  ///
  /// - [callID] callID
  /// - [config] config
  Future<ZIMCallJoinSentResult> callJoin(
    String callID,
    ZIMCallJoinConfig config,
  );

  ///  Supported versions: 2.9.0 and above.
  ///  Detail description: When the Lord's call initiates the invitation and is called and accepts it, the current call can be exited through the interface.
  ///  When to call: It can be called after creating a ZIM instance through [create].
  ///  Note: The callee will fail to quit the uninvited callid.
  ///  Related callbacks: [ZIMCallQuitSentCallback].
  ///
  /// - [callID] callID
  /// - [config] config
  Future<ZIMCallQuitSentResult> callQuit(
    String callID,
    ZIMCallQuitConfig config,
  );

  ///  Supported versions: 2.9.0 and above.
  ///  Detail description: End The call in advanced mode.
  ///  When to call: The call was in advanced mode and the user status was Accepted.
  ///  Note: User calls that are not in the call will fail. ZupdatIM SDK Does not have service logic after the call ends, and developers can customize the development logic after the end.
  ///  Related callbacks: [ZIMCallEndSentCallback].
  ///
  /// - [callID] callID
  /// - [config] config
  Future<ZIMCallEndSentResult> callEnd(String callID, ZIMCallEndConfig config);

  ///  Supported versions: 2.9.0 and above.
  ///  Detail description: Users can call the call invitation list through the query.
  ///  Service scenario: Users can use the query call invitation list for interface display or other functions.
  ///  When to call: Run [create] to create a ZIM instance, which can be invoked after login.
  /// Related callbacks: [ZIMCallInvitationListQueriedCallback].
  ///
  /// - [config] config
  Future<ZIMCallInvitationListQueriedResult> queryCallInvitationList(
    ZIMCallInvitationQueryConfig config,
  );

  /// todo
  ///
  /// - [userID] userID
  /// - [config] config
  Future<ZIMFriendAddedResult> addFriend(
    String userID,
    ZIMFriendAddConfig config,
  );

  /// todo
  ///
  /// - [userIDs] userIDs
  /// - [config] config
  Future<ZIMFriendsDeletedResult> deleteFriends(
    List<String> userIDs,
    ZIMFriendDeleteConfig config,
  );

  /// todo
  ///
  /// - [userIDs] userIDs
  /// - [config] config
  Future<ZIMFriendsRelationCheckedResult> checkFriendsRelation(
    List<String> userIDs,
    ZIMFriendRelationCheckConfig config,
  );

  /// todo
  ///
  /// - [friendAlias] friendAlias
  /// - [userID] userID
  Future<ZIMFriendAliasUpdatedResult> updateFriendAlias(
    String friendAlias,
    String userID,
  );

  /// todo
  ///
  /// - [friendAttributes] friendAttributes
  /// - [userID] userID
  Future<ZIMFriendAttributesUpdatedResult> updateFriendAttributes(
    Map<String, String> friendAttributes,
    String userID,
  );

  /// todo
  ///
  /// - [userIDs] userIDs
  Future<ZIMFriendsInfoQueriedResult> queryFriendsInfo(List<String> userIDs);

  /// todo
  ///
  /// - [config] config
  Future<ZIMFriendListQueriedResult> queryFriendList(
    ZIMFriendListQueryConfig config,
  );

  /// todo
  ///
  /// - [config] config
  Future<ZIMFriendsSearchedResult> searchLocalFriends(
    ZIMFriendSearchConfig config,
  );

  /// todo
  ///
  /// - [userID] userID
  /// - [config] config
  Future<ZIMFriendApplicationSentResult> sendFriendApplication(
    String userID,
    ZIMFriendApplicationSendConfig config,
  );

  /// todo
  ///
  /// - [userID] userID
  /// - [config] config
  Future<ZIMFriendApplicationAcceptedResult> acceptFriendApplication(
    String userID,
    ZIMFriendApplicationAcceptConfig config,
  );

  /// todo
  ///
  /// - [userID] userID
  /// - [config] config
  Future<ZIMFriendApplicationRejectedResult> rejectFriendApplication(
    String userID,
    ZIMFriendApplicationRejectConfig config,
  );

  /// todo
  ///
  /// - [config] config
  Future<ZIMFriendApplicationListQueriedResult> queryFriendApplicationList(
    ZIMFriendApplicationListQueryConfig config,
  );

  /// todo
  ///
  /// - [userIDs] userIDs
  Future<ZIMBlacklistUsersAddedResult> addUsersToBlacklist(
    List<String> userIDs,
  );

  /// todo
  ///
  /// - [userIDs] userIDs
  Future<ZIMBlacklistUsersRemovedResult> removeUsersFromBlacklist(
    List<String> userIDs,
  );

  /// todo
  ///
  /// - [config] config
  Future<ZIMBlacklistQueriedResult> queryBlacklist(
    ZIMBlacklistQueryConfig config,
  );

  /// todo
  ///
  /// - [userID] userID
  Future<ZIMBlacklistCheckedResult> checkUserIsInBlacklist(String userID);
}
