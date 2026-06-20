import 'dart:typed_data';

part 'internal/zim_defines_extension.dart';
part 'internal/zim_defines_utils.dart';

/// Connection state.
enum ZIMConnectionState {
  /// todo
  disconnected,

  /// todo
  connecting,

  /// todo
  connected,

  /// todo
  reconnecting,
}

enum ZIMConnectionEvent {
  success,

  activeLogin,

  loginTimeout,

  interrupted,

  kickedOut,

  tokenExpired,

  unregistered,
}

enum ZIMConversationEvent { added, updated, disabled, deleted }

enum ZIMConversationNotificationStatus { notify, doNotDisturb }

enum ZIMConversationType { unknown, peer, room, group }

/// Synchronization status of the conversation list and the server
enum ZIMConversationSyncState {
  /// Conversation list synchronization start status
  started,

  /// Conversation list synchronization completion status
  finished,

  /// The synchronization of the conversation list failed. The synchronization failure may be caused by network reasons.
  failed,
}

/// Conversation pin query filter type.
enum ZIMConversationPinnedFilter {
  /// Both pinned and unpinned conversations can be queried.
  all,

  /// Only pinned conversations can be queried.
  onlyPinned,

  /// Only unpinned conversations can be queried.
  onlyUnpinned,
}

/// Conversation search mode.
enum ZIMConversationSearchMode {
  /// Query the corresponding conversation by searching for messages that meet the criteria.
  matchMessage,

  /// Query the corresponding conversation by searching for the conversation name.
  matchConversationName,
}

enum ZIMMediaFileType { originalFile, largeImage, thumbnail, videoFirstFrame }

enum ZIMMessageDirection { send, receive }

enum ZIMMessageOrder { descending, ascending }

enum ZIMMessagePriority { low, medium, high }

/// .
enum ZIMMessageQueryMode {
  /// General mode. In this mode, the SDK automatically determines whether it needs to request merged message data from the server. This mode is recommended for most common scenarios.
  general,

  /// Server-priority query mode.
  preferServer,

  /// Local-messages-only query mode.
  onlyLocal,
}

enum ZIMMessageReceiptStatus {
  unknown,

  none,

  processing,

  done,

  expired,

  failed,
}

enum ZIMMessageRevokeStatus {
  unknown,

  selfRevoke,

  systemRevoke,

  serviceAPIRevoke,

  groupAdminRevoke,

  groupOwnerRevoke,

  auditRejectRevoke,
}

enum ZIMMessageSentStatus { sending, success, failed }

enum ZIMMessageType {
  unknown,

  text,

  command,

  multiple,

  image,

  file,

  audio,

  video,

  barrage,

  system,

  revoke,

  tips,

  combine,

  custom,
}

enum ZIMRevokeType { unknown, twoWay, oneWay }

/// Tips message event
enum ZIMTipsMessageEvent {
  unknown,

  groupCreated,

  groupDismissed,

  groupJoined,

  groupInvited,

  groupLeft,

  groupKickedOut,

  groupInfoChanged,

  groupMemberInfoChanged,

  groupMessagePinned,
}

/// Tips message event
enum ZIMTipsMessageChangeInfoType {
  unknown,

  groupDataChanged,

  groupNoticeChanged,

  groupNameChanged,

  groupAvatarUrlChanged,

  groupMuteChanged,

  groupOwnerTransferred,

  groupMemberRoleChanged,

  groupMemberMuteChanged,

  groupMessagePinInfoChanged,
}

/// Message mentioned type
enum ZIMMessageMentionedType { unknown, mentionMe, mentionAll, mentionAllAndMe }

/// Message deleted type
enum ZIMMessageDeleteType {
  messageListDeleted,

  conversationAllMessagesDeleted,

  allConversationMessagesDeleted,
}

enum ZIMMessageRepliedInfoState { normal, deleted, notFound }

enum ZIMMessagePinStatus { notPinned, pinned, updated }

/// User operation action for message reactions.
enum ZIMMessageReactionUserChangeAction {
  /// Add message reaction.
  added,

  /// Delete message reaction.
  deleted,
}

enum ZIMRoomEvent {
  success,

  interrupted,

  disconnected,

  roomNotExist,

  activeCreate,

  createFailed,

  activeEnter,

  enterFailed,

  kickedOut,

  connectTimeout,

  kickedOutByOtherDevice,

  activeSwitch,

  switchFailed,
}

enum ZIMRoomState { disconnected, connecting, connected }

enum ZIMRoomAttributesUpdateAction { set, delete }

enum ZIMRoomMemberAttributesUpdateAction { set }

enum ZIMGroupState { quit, enter }

enum ZIMGroupEvent { created, dismissed, joined, invited, left, kickedout }

enum ZIMGroupMemberEvent { joined, left, kickedout, invited }

enum ZIMGroupMemberState { quit, enter }

enum ZIMGroupMessageNotificationStatus { notify, doNotDisturb }

enum ZIMGroupAttributesUpdateAction { set, delete }

enum ZIMGroupMuteMode { none, normal, all, custom }

enum ZIMGroupJoinMode { any, auth, forbid }

enum ZIMGroupInviteMode { any, admin }

enum ZIMGroupBeInviteMode { none, auth }

enum ZIMGroupEnterType {
  unknown,

  created,

  joinApply,

  joined,

  invited,

  inviteApply,
}

enum ZIMGroupApplicationType { unknown, none, join, invite, beInvite }

enum ZIMGroupApplicationState {
  unknown,

  waiting,

  accepted,

  rejected,

  expired,

  disabled,
}

enum ZIMGroupApplicationListChangeAction { added }

/// Group member role
class ZIMGroupMemberRole {
  /// Group Owner.
  static const int owner = 1;

  /// Group Admin.
  static const int admin = 2;

  /// Group Member.
  static const int member = 3;
}

class ZIMGroupDataFlag {
  static const int name = 1;

  static const int notice = 2;

  static const int avatarUrl = 4;
}

enum ZIMCallInvitationMode { unknown, general, advanced }

enum ZIMCallState { unknown, started, ended }

enum ZIMCallUserState {
  unknown,

  inviting,

  accepted,

  rejected,

  cancelled,

  @Deprecated('Offline is deprecated since ZIM 2.9.0')
  offline,

  received,

  timeout,

  quited,

  ended,

  notYetReceived,

  beCancelled,
}

enum ZIMFriendListChangeAction { added, deleted }

enum ZIMFriendApplicationListChangeAction { added, deleted }

enum ZIMFriendApplicationType { unknown, none, received, sent, both }

enum ZIMFriendApplicationState {
  unknown,

  waiting,

  accepted,

  rejected,

  expired,

  disabled,
}

enum ZIMFriendRelationCheckType { both, single }

enum ZIMFriendDeleteType { both, single }

enum ZIMUserRelationType {
  unknown,

  singleNo,

  singleHave,

  bothAllNo,

  bothSelfHave,

  bothOtherHave,

  bothAllHave,
}

enum ZIMBlacklistChangeAction { added, removed }

enum ZIMCXHandleType { generic, phoneNumber, emailAddress }

enum ZIMGeofencingType { none, include, exclude }

/// Geofencing Area
class ZIMGeofencingArea {
  /// China
  static const int CN = 2;

  /// North America
  static const int NA = 3;

  /// Europe
  static const int EU = 4;

  /// Asia
  static const int AS = 5;

  /// India
  static const int IN = 6;
}

enum ZIMPlatformType {
  win,

  iPhoneOS,

  android,

  macOS,

  linux,

  web,

  miniProgram,

  iPadOS,

  ohos,

  unknown,
}

enum ZIMUserOnlineStatus { online, offline, logout, unknown }

/// Error infomation
///
/// Description: Error infomation.
class ZIMError {
  /// Description: The storage path of the log files. Refer to the official website document for the default path.
  int code;

  /// Description: Error infomation description.
  String message;

  ZIMError({required this.code, required this.message});

  ZIMError.fromMap(Map<dynamic, dynamic> map)
      : code = map['code']!,
        message = map['message']!;

  Map<String, dynamic> toMap() {
    return {'code': code, 'message': message};
  }
}

/// ZIM application configuration, including AppID and AppSign.
class ZIMAppConfig {
  /// Description:AppID, please go to the ZEGO official website console to apply for it. Required: Required.
  int appID;

  /// Description:AppSign, please go to the ZEGO official website console to apply for it. Required: Required.
  String appSign;

  ZIMAppConfig({this.appID = 0, this.appSign = ''});

  ZIMAppConfig.fromMap(Map<dynamic, dynamic> map)
      : appID = map['appID']!,
        appSign = map['appSign']!;

  Map<String, dynamic> toMap() {
    return {'appID': appID, 'appSign': appSign};
  }
}

/// Log configuration
///
/// Log configuration
class ZIMLogConfig {
  /// The storage path of the log files. Refer to the official website document for the default path.
  String logPath;

  /// The maximum log file size (Bytes). The default maximum size is 5MB (5 * 1024 * 1024 Bytes)
  int logSize;

  /// Description: Log level, only used on the web platform. Required: Not required. Default value: 0.
  int? logLevel;

  ZIMLogConfig({this.logPath = '', this.logSize = 5242880, this.logLevel});

  ZIMLogConfig.fromMap(Map<dynamic, dynamic> map)
      : logPath = map['logPath']!,
        logSize = map['logSize']!,
        logLevel = map['logLevel'];

  Map<String, dynamic> toMap() {
    return {'logPath': logPath, 'logSize': logSize, 'logLevel': logLevel};
  }
}

/// Cache configuration
///
/// Description: Configure the storage path of cache files (such as chat records).
class ZIMCacheConfig {
  /// The storage path of the cache files. Refer to the official website document for the default path.
  String cachePath;

  ZIMCacheConfig({this.cachePath = ''});

  ZIMCacheConfig.fromMap(Map<dynamic, dynamic> map)
      : cachePath = map['cachePath']!;

  Map<String, dynamic> toMap() {
    return {'cachePath': cachePath};
  }
}

/// User information object.
///
/// Description: Identifies a unique user.
/// Caution: Note that the userID must be unique under the same appID, otherwise mutual kicks out will occur.It is strongly recommended that userID corresponds to the user ID of the business APP,that is, a userID and a real user are fixed and unique, and should not be passed to the SDK in a random userID.Because the unique and fixed userID allows ZEGO technicians to quickly locate online problems.
class ZIMUserInfo {
  /// User ID, a string with a maximum length of 32 bytes or less. It is customized by the developer. Only support numbers, English characters and  '!', '#', '$', '%', '&', '(', ')', '+', '-', ':', ';', '<', '=', '.', '>', '?', '@', '[', ']', '^', '_', '{', '}', '|', '~'.
  String userID;

  /// Description: User name, defined by you. For version 2.0.0 and onwards, the string has a maximum length of 256 bytes.Required: Not required.Privacy reminder: Please do not provide sensitive personal information, including but not limited to mobile phone numbers, ID card numbers, passport numbers, and real names.
  String userName;

  /// User avatar URL
  String userAvatarUrl;

  /// User extended data. This field is currently only available in room related interfaces.
  String userExtendedData;

  ZIMUserInfo({
    this.userID = '',
    this.userName = '',
    this.userAvatarUrl = '',
    this.userExtendedData = '',
  });

  ZIMUserInfo.fromMap(Map<dynamic, dynamic> map)
      : userID = map['userID']!,
        userName = map['userName']!,
        userAvatarUrl = map['userAvatarUrl']!,
        userExtendedData = map['userExtendedData']!;

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'userExtendedData': userExtendedData,
    };
  }
}

/// User full information object.
///
/// Description: Identifies a unique user.
/// Caution: Note that the userID must be unique under the same appID, otherwise mutual kicks out will occur.It is strongly recommended that userID corresponds to the user ID of the business APP,that is, a userID and a real user are fixed and unique, and should not be passed to the SDK in a random userID.Because the unique and fixed userID allows ZEGO technicians to quickly locate online problems.
class ZIMUserFullInfo {
  /// Description: User basic information.
  ZIMUserInfo baseInfo;

  /// Detail description: User avatar URL.Required: not required.Use restrictions: The value is a maximum of 500 bytes and contains no special characters.
  @Deprecated(
    'Deprecated in version 2.13.0. To obtain the URL of a user\'s avatar, please refer to userAvatarUrl from the baseInfo.',
  )
  String userAvatarUrl;

  /// Detailed description: User extended information.Required: not required.Privacy Protection Statement: Do not pass in sensitive information involving personal privacy, including but not limited to mobile phone numbers, ID numbers, passport numbers, real names, etc.
  String extendedData;

  ZIMUserFullInfo({
    required this.baseInfo,
    required this.userAvatarUrl,
    required this.extendedData,
  });

  ZIMUserFullInfo.fromMap(Map<dynamic, dynamic> map)
      : baseInfo = ZIMDataUtils.parseZIMUserInfoFromMap(map['baseInfo']),
        userAvatarUrl = map['userAvatarUrl']!,
        extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {
      'baseInfo': baseInfo.toMap(),
      'userAvatarUrl': userAvatarUrl,
      'extendedData': extendedData,
    };
  }
}

class ZIMUserOfflinePushRule {
  List<ZIMPlatformType> onlinePlatforms;

  List<ZIMPlatformType> notToReceiveOfflinePushPlatforms;

  ZIMUserOfflinePushRule({
    List<ZIMPlatformType>? onlinePlatforms,
    List<ZIMPlatformType>? notToReceiveOfflinePushPlatforms,
  })  : onlinePlatforms = onlinePlatforms ?? [],
        notToReceiveOfflinePushPlatforms =
            notToReceiveOfflinePushPlatforms ?? [];

  ZIMUserOfflinePushRule.fromMap(Map<dynamic, dynamic> map)
      : onlinePlatforms = ((map['onlinePlatforms']!) as List)
            .map<ZIMPlatformType>(
              (item) =>
                  ZIMPlatformTypeExtension.mapValue[item] ??
                  ZIMPlatformType.unknown,
            )
            .toList(),
        notToReceiveOfflinePushPlatforms =
            ((map['notToReceiveOfflinePushPlatforms']!) as List)
                .map<ZIMPlatformType>(
                  (item) =>
                      ZIMPlatformTypeExtension.mapValue[item] ??
                      ZIMPlatformType.unknown,
                )
                .toList();

  Map<String, dynamic> toMap() {
    return {
      'onlinePlatforms': onlinePlatforms.map((item) => item.value).toList(),
      'notToReceiveOfflinePushPlatforms':
          notToReceiveOfflinePushPlatforms.map((item) => item.value).toList(),
    };
  }
}

class ZIMUserRule {
  ZIMUserOfflinePushRule offlinePushRule;

  ZIMUserRule({required this.offlinePushRule});

  ZIMUserRule.fromMap(Map<dynamic, dynamic> map)
      : offlinePushRule =
            ZIMUserOfflinePushRule.fromMap(map['offlinePushRule']);

  Map<String, dynamic> toMap() {
    return {'offlinePushRule': offlinePushRule.toMap()};
  }
}

/// User status.
class ZIMUserStatus {
  String userID;

  ZIMUserOnlineStatus onlineStatus;

  List<ZIMPlatformType> onlinePlatforms;

  String customStatus;

  /// Expired timestamp of the custom status.
  int customStatusExpiredTime;

  int lastUpdateTime;

  int lastOnlineStatusUpdateTime;

  int lastCustomStatusUpdateTime;

  ZIMUserStatus({
    required this.userID,
    required this.onlineStatus,
    required this.onlinePlatforms,
    required this.customStatus,
    required this.customStatusExpiredTime,
    required this.lastUpdateTime,
    required this.lastOnlineStatusUpdateTime,
    required this.lastCustomStatusUpdateTime,
  });

  ZIMUserStatus.fromMap(Map<dynamic, dynamic> map)
      : userID = map['userID']!,
        onlineStatus =
            ZIMUserOnlineStatusExtension.mapValue[map['onlineStatus']] ??
                ZIMUserOnlineStatus.unknown,
        onlinePlatforms = ((map['onlinePlatforms']!) as List)
            .map<ZIMPlatformType>(
              (item) =>
                  ZIMPlatformTypeExtension.mapValue[item] ??
                  ZIMPlatformType.unknown,
            )
            .toList(),
        customStatus = map['customStatus']!,
        customStatusExpiredTime = map['customStatusExpiredTime']!,
        lastUpdateTime = map['lastUpdateTime']!,
        lastOnlineStatusUpdateTime = map['lastOnlineStatusUpdateTime']!,
        lastCustomStatusUpdateTime = map['lastCustomStatusUpdateTime']!;

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'onlineStatus': onlineStatus.value,
      'onlinePlatforms': onlinePlatforms.map((item) => item.value).toList(),
      'customStatus': customStatus,
      'customStatusExpiredTime': customStatusExpiredTime,
      'lastUpdateTime': lastUpdateTime,
      'lastOnlineStatusUpdateTime': lastOnlineStatusUpdateTime,
      'lastCustomStatusUpdateTime': lastCustomStatusUpdateTime,
    };
  }
}

/// User status subscription configuration.
class ZIMUserStatusSubscription {
  ZIMUserStatus userStatus;

  int subscribeExpiredTime;

  ZIMUserStatusSubscription({
    required this.userStatus,
    required this.subscribeExpiredTime,
  });

  ZIMUserStatusSubscription.fromMap(Map<dynamic, dynamic> map)
      : userStatus = ZIMUserStatus.fromMap(map['userStatus']),
        subscribeExpiredTime = map['subscribeExpiredTime']!;

  Map<String, dynamic> toMap() {
    return {
      'userStatus': userStatus.toMap(),
      'subscribeExpiredTime': subscribeExpiredTime,
    };
  }
}

/// Self user information object.
class ZIMSelfUserInfo {
  ZIMUserFullInfo userFullInfo;

  ZIMUserRule userRule;

  ZIMUserStatus userStatus;

  ZIMSelfUserInfo({
    required this.userFullInfo,
    required this.userRule,
    required this.userStatus,
  });

  ZIMSelfUserInfo.fromMap(Map<dynamic, dynamic> map)
      : userFullInfo = ZIMUserFullInfo.fromMap(map['userFullInfo']),
        userRule = ZIMUserRule.fromMap(map['userRule']),
        userStatus = ZIMUserStatus.fromMap(map['userStatus']);

  Map<String, dynamic> toMap() {
    return {
      'userFullInfo': userFullInfo.toMap(),
      'userRule': userRule.toMap(),
      'userStatus': userStatus.toMap(),
    };
  }
}

/// User status subscription configuration.
class ZIMUserStatusSubscribeConfig {
  /// Subscription duration, in minutes.
  int subscriptionDuration;

  ZIMUserStatusSubscribeConfig({this.subscriptionDuration = 0});

  ZIMUserStatusSubscribeConfig.fromMap(Map<dynamic, dynamic> map)
      : subscriptionDuration = map['subscriptionDuration']!;

  Map<String, dynamic> toMap() {
    return {'subscriptionDuration': subscriptionDuration};
  }
}

/// User status subscription table query configuration.
class ZIMSubscribedUserStatusQueryConfig {
  /// List of user IDs to query.
  List<String> userIDs;

  ZIMSubscribedUserStatusQueryConfig({List<String>? userIDs})
      : userIDs = userIDs ?? [];

  ZIMSubscribedUserStatusQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : userIDs = ((map['userIDs']!) as List)
            .map<String>((item) => item as String)
            .toList();

  Map<String, dynamic> toMap() {
    return {'userIDs': userIDs};
  }
}

/// User custom status update configuration.
class ZIMUserCustomStatusUpdateConfig {
  /// Duration of user custom status.
  int duration;

  ZIMUserCustomStatusUpdateConfig({this.duration = 0});

  ZIMUserCustomStatusUpdateConfig.fromMap(Map<dynamic, dynamic> map)
      : duration = map['duration']!;

  Map<String, dynamic> toMap() {
    return {'duration': duration};
  }
}

/// todo
///
/// todo
class ZIMErrorUserInfo {
  String userID;

  int reason;

  ZIMErrorUserInfo({required this.userID, required this.reason});

  ZIMErrorUserInfo.fromMap(Map<dynamic, dynamic> map)
      : userID = map['userID']!,
        reason = map['reason']!;

  Map<String, dynamic> toMap() {
    return {'userID': userID, 'reason': reason};
  }
}

/// Configuration of login-related parameters.
///
/// Supported version: 2.13.0 and above.
/// Description: Login-related parameters.
/// Use cases: Used to set different parameters during login.
class ZIMLoginConfig {
  /// Description: User name.Use cases: Used in the scenario where user nickname is modified during login, leave it blank if no change is needed.Required: No.
  String userName;

  /// Description: Token carried during login.Use cases: Only pass this parameter in the scenario where token is used for authentication.Required: No.
  String token;

  /// Description: Whether it is offline login.Use cases: Set this parameter to true when performing offline login.Required: No.Default value: false.
  bool isOfflineLogin;

  /// Description: Custom status.Use cases: Only pass this parameter when you need to customize the user status during login.Required: No.
  String customStatus;

  /// Description: Expired duration of the custom status.
  int customStatusDuration;

  ZIMLoginConfig({
    this.userName = '',
    this.token = '',
    this.isOfflineLogin = false,
    this.customStatus = '',
    this.customStatusDuration = 0,
  });

  ZIMLoginConfig.fromMap(Map<dynamic, dynamic> map)
      : userName = map['userName']!,
        token = map['token']!,
        isOfflineLogin = map['isOfflineLogin']!,
        customStatus = map['customStatus']!,
        customStatusDuration = map['customStatusDuration']!;

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'token': token,
      'isOfflineLogin': isOfflineLogin,
      'customStatus': customStatus,
      'customStatusDuration': customStatusDuration,
    };
  }
}

/// User information query configuration.
///
/// Detailed description: User information query configuration, you can choose to query from the local or from the server. Query the unlimited frequency constraints from the local, and query the limited frequency constraints from the server. You can only query the detailed configuration of 10 users within 10 s.
class ZIMUserInfoQueryConfig {
  /// Detail description: Whether to query user details from the server. Query the unlimited frequency constraints from the local, and query the limited frequency constraints from the server. You can only query the detailed configuration of 10 users within 10 s.Required: not required.Default: false.
  bool isQueryFromServer;

  ZIMUserInfoQueryConfig({this.isQueryFromServer = false});

  ZIMUserInfoQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : isQueryFromServer = map['isQueryFromServer']!;

  Map<String, dynamic> toMap() {
    return {'isQueryFromServer': isQueryFromServer};
  }
}

/// The private message template is currently only applicable to the OPPO manufacturer.
///
/// The private message template is currently only applicable to the OPPO manufacturer.
class ZIMOfflinePushPrivateMessageTemplate {
  /// Description: The private message template ID is currently only applicable to OPPO manufacturers. Please fill in the template ID preset in the OPPO Open Platform console.
  String templateID;

  /// Description: To replace the content of the preset title field in the template, a json string needs to be filled in, such as "{"user_name":" Li Hua "}".
  String titleParameters;

  /// Description: To replace the content of the preset fields in the template, a json string needs to be filled in, such as "{"city":" Shenzhen "}".
  String contentParameters;

  ZIMOfflinePushPrivateMessageTemplate({
    this.templateID = '',
    this.titleParameters = '',
    this.contentParameters = '',
  });

  ZIMOfflinePushPrivateMessageTemplate.fromMap(Map<dynamic, dynamic> map)
      : templateID = map['templateID']!,
        titleParameters = map['titleParameters']!,
        contentParameters = map['contentParameters']!;

  Map<String, dynamic> toMap() {
    return {
      'templateID': templateID,
      'titleParameters': titleParameters,
      'contentParameters': contentParameters,
    };
  }
}

/// Provides information about the iOS VoIP offline push.
///
/// Provides information about the iOS VoIP offline push.
class ZIMVoIPConfig {
  /// Description: The type of contact information for the VoIP caller, by default, is generic.
  ZIMCXHandleType iOSVoIPHandleType;

  /// Description: The contact information of the VoIP caller. It is related to iOSVoIPHandleType. When iOSVoIPHandleType is PhoneNumber, the Value is a sequence of digits; when iOSVoIPHandleType is EmailAddress, the Value is an email address; when the contact information is of other types, the Value typically follows some domain-specific format, such as a username, numeric ID, or URL.
  String iOSVoIPHandleValue;

  /// Description: Video call or not. The default value is audio
  bool iOSVoIPHasVideo;

  ZIMVoIPConfig({
    this.iOSVoIPHandleType = ZIMCXHandleType.generic,
    this.iOSVoIPHandleValue = '',
    this.iOSVoIPHasVideo = false,
  });

  ZIMVoIPConfig.fromMap(Map<dynamic, dynamic> map)
      : iOSVoIPHandleType =
            ZIMCXHandleTypeExtension.mapValue[map['iOSVoIPHandleType']] ??
                ZIMCXHandleType.generic,
        iOSVoIPHandleValue = map['iOSVoIPHandleValue']!,
        iOSVoIPHasVideo = map['iOSVoIPHasVideo']!;

  Map<String, dynamic> toMap() {
    return {
      'iOSVoIPHandleType': iOSVoIPHandleType.value,
      'iOSVoIPHandleValue': iOSVoIPHandleValue,
      'iOSVoIPHasVideo': iOSVoIPHasVideo,
    };
  }
}

/// Description: Offline push configuration.
///
/// Details: Configuration before sending offline push.
class ZIMPushConfig {
  /// Description: Used to set the push title.Required: Not required.
  String title;

  /// Description: Used to set offline push content.Required: Not required.
  String content;

  /// Description: This parameter is used to set the pass-through field of offline push.Required: Not required.
  String payload;

  /// Description: Offline push advanced configuration for mapping console Settings, with the maximum of 32 characters and defined by yourself.Required: Not required.
  String resourcesID;

  /// Description: Used to set the thread ID of offline push.Required: Not required.
  String threadID;

  /// Description: Push whether to carry corner information switch.
  bool enableBadge;

  /// Description: The incremental index number carried by the push.
  int badgeIncrement;

  /// Description: If you use Flutter, RN ZPNs, offline push receiving device has iOS and uses VoIP push type, you can customize some VoIP options with this parameter.
  ZIMVoIPConfig? voIPConfig;

  /// Description: If you use OPPO Push, you can carry the push template through this field.
  ZIMOfflinePushPrivateMessageTemplate? privateMessageTemplate;

  ZIMPushConfig({
    this.title = '',
    this.content = '',
    this.payload = '',
    this.resourcesID = '',
    this.threadID = '',
    this.enableBadge = false,
    this.badgeIncrement = 0,
    this.voIPConfig,
    this.privateMessageTemplate,
  });

  ZIMPushConfig.fromMap(Map<dynamic, dynamic> map)
      : title = map['title']!,
        content = map['content']!,
        payload = map['payload']!,
        resourcesID = map['resourcesID']!,
        threadID = map['threadID']!,
        enableBadge = map['enableBadge']!,
        badgeIncrement = map['badgeIncrement']!,
        voIPConfig = (map['voIPConfig'] != null)
            ? ZIMVoIPConfig.fromMap(map['voIPConfig'])
            : null,
        privateMessageTemplate = (map['privateMessageTemplate'] != null)
            ? ZIMOfflinePushPrivateMessageTemplate.fromMap(
                map['privateMessageTemplate'],
              )
            : null;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'payload': payload,
      'resourcesID': resourcesID,
      'threadID': threadID,
      'enableBadge': enableBadge,
      'badgeIncrement': badgeIncrement,
      'voIPConfig': voIPConfig?.toMap(),
      'privateMessageTemplate': privateMessageTemplate?.toMap(),
    };
  }
}

/// Configuration for adding reactions.
class ZIMMessageReactionAddConfig {
  /// Description: When this value is greater than 0, the same user is allowed to react multiple times with the same reaction type, and the counts from those reactions will be accumulated.
  int increaseCount;

  ZIMMessageReactionAddConfig({this.increaseCount = 0});

  ZIMMessageReactionAddConfig.fromMap(Map<dynamic, dynamic> map)
      : increaseCount = map['increaseCount']!;

  Map<String, dynamic> toMap() {
    return {'increaseCount': increaseCount};
  }
}

/// reaction user information.
///
/// Detail description: A class describing reaction user.
class ZIMMessageReactionUserInfo {
  /// Description: user ID
  String userID;

  ZIMMessageReactionUserInfo({required this.userID});

  ZIMMessageReactionUserInfo.fromMap(Map<dynamic, dynamic> map)
      : userID = map['userID']!;

  Map<String, dynamic> toMap() {
    return {'userID': userID};
  }
}

/// message reaction infos
///
/// Description: message reaction infos.
class ZIMMessageReaction {
  /// Description: Type of reaction, defined by you, with a maximum length of 32 bytes.
  String reactionType;

  /// Description: conversationID.
  String conversationID;

  /// Description: conversation type.
  ZIMConversationType conversationType;

  /// Detail description:  reaction message ID.
  dynamic messageID;

  /// Description: The reaction users number.
  int totalCount;

  /// Description:  The reaciton users if included myself.
  bool isSelfIncluded;

  /// Description:  Reaction user info list.
  List<ZIMMessageReactionUserInfo> userList;

  /// Detailed description: The sum count of reaction.
  int sumCount;

  ZIMMessageReaction({
    required this.reactionType,
    required this.conversationID,
    required this.conversationType,
    required this.messageID,
    required this.totalCount,
    required this.isSelfIncluded,
    required this.userList,
    required this.sumCount,
  });

  ZIMMessageReaction.fromMap(Map<dynamic, dynamic> map)
      : reactionType = map['reactionType']!,
        conversationID = map['conversationID']!,
        conversationType =
            ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
                ZIMConversationType.unknown,
        messageID = map['messageID']!,
        totalCount = map['totalCount']!,
        isSelfIncluded = map['isSelfIncluded']!,
        userList = ((map['userList']!) as List)
            .map<ZIMMessageReactionUserInfo>(
              (item) => ZIMMessageReactionUserInfo.fromMap(item),
            )
            .toList(),
        sumCount = map['sumCount']!;

  Map<String, dynamic> toMap() {
    return {
      'reactionType': reactionType,
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'messageID': messageID,
      'totalCount': totalCount,
      'isSelfIncluded': isSelfIncluded,
      'userList': userList.map((item) => item.toMap()).toList(),
      'sumCount': sumCount,
    };
  }
}

/// message reaction infos
///
/// Description: message reaction infos.
class ZIMMessageReactionSimpleInfo {
  /// Description: Type of reaction, defined by you, with a maximum length of 32 bytes.
  String reactionType;

  /// Detailed description: The sum count of reaction.
  int sumCount;

  ZIMMessageReactionSimpleInfo({this.reactionType = '', this.sumCount = 0});

  ZIMMessageReactionSimpleInfo.fromMap(Map<dynamic, dynamic> map)
      : reactionType = map['reactionType']!,
        sumCount = map['sumCount']!;

  Map<String, dynamic> toMap() {
    return {'reactionType': reactionType, 'sumCount': sumCount};
  }
}

/// message reaction user full information.
///
/// Detail description: A class describing reaction user.
class ZIMMessageReactionUserFullInfo {
  /// Description: user ID
  String userID;

  /// Description: A list of summary information for the current user’s reactions under this message.
  List<ZIMMessageReactionSimpleInfo> reactions;

  ZIMMessageReactionUserFullInfo({this.userID = '', required this.reactions});

  ZIMMessageReactionUserFullInfo.fromMap(Map<dynamic, dynamic> map)
      : userID = map['userID']!,
        reactions = ((map['reactions']!) as List)
            .map<ZIMMessageReactionSimpleInfo>(
              (item) => ZIMMessageReactionSimpleInfo.fromMap(item),
            )
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'reactions': reactions.map((item) => item.toMap()).toList(),
    };
  }
}

/// User operation change information for message reactions.
///
/// Description: A class that describes reaction change information.
class ZIMMessageReactionUserChangeInfo {
  String userID;

  String reactionType;

  ZIMMessageReactionUserChangeAction action;

  /// Description: The sum count for the current reaction type.
  int sumCount;

  ZIMMessageReactionUserChangeInfo({
    this.userID = '',
    this.reactionType = '',
    this.action = ZIMMessageReactionUserChangeAction.added,
    this.sumCount = 0,
  });

  ZIMMessageReactionUserChangeInfo.fromMap(Map<dynamic, dynamic> map)
      : userID = map['userID']!,
        reactionType = map['reactionType']!,
        action = ZIMMessageReactionUserChangeActionExtension
                .mapValue[map['action']] ??
            ZIMMessageReactionUserChangeAction.added,
        sumCount = map['sumCount']!;

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'reactionType': reactionType,
      'action': action.value,
      'sumCount': sumCount,
    };
  }
}

/// message reaction change information.
///
/// Description: A class that describes reaction change information.
class ZIMMessageReactionChangeInfo {
  /// Description: The message object containing updated reaction information, which can be used to directly replace the old data held by the developer.
  ZIMMessage message;

  /// Description: A list of user reaction operation changes under the current message.
  List<ZIMMessageReactionUserChangeInfo> userChangeInfoList;

  ZIMMessageReactionChangeInfo({
    ZIMMessage? message,
    List<ZIMMessageReactionUserChangeInfo>? userChangeInfoList,
  })  : message = message ?? ZIMMessage(),
        userChangeInfoList = userChangeInfoList ?? [];

  ZIMMessageReactionChangeInfo.fromMap(Map<dynamic, dynamic> map)
      : message = ZIMDataUtils.parseZIMMessageFromMap(map['message']),
        userChangeInfoList = ((map['userChangeInfoList']!) as List)
            .map<ZIMMessageReactionUserChangeInfo>(
              (item) => ZIMMessageReactionUserChangeInfo.fromMap(item),
            )
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'message': message.toMap(),
      'userChangeInfoList':
          userChangeInfoList.map((item) => item.toMap()).toList(),
    };
  }
}

/// Message lite information.
///
/// Detailed description: Message lite information.
class ZIMMessageLiteInfo {
  /// Description: Message type.
  ZIMMessageType type;

  ZIMMessageLiteInfo({this.type = ZIMMessageType.unknown});

  ZIMMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
      : type = ZIMMessageTypeExtension.mapValue[map['type']] ??
            ZIMMessageType.unknown;

  Map<String, dynamic> toMap() {
    return {'type': type.value};
  }
}

/// Text message lite information.
class ZIMTextMessageLiteInfo extends ZIMMessageLiteInfo {
  /// Description: Text message content.
  String message;

  ZIMTextMessageLiteInfo({this.message = ''})
      : super(type: ZIMMessageType.text);

  ZIMTextMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
      : message = map['message']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'message': message});
    return baseMap;
  }
}

/// Custom message lite information.
class ZIMCustomMessageLiteInfo extends ZIMMessageLiteInfo {
  /// Description: Custom message content.
  String message;

  /// Description: Custom message search content.
  String searchedContent;

  /// Description: Custom message sub-type.
  int subType;

  ZIMCustomMessageLiteInfo({
    this.message = '',
    this.searchedContent = '',
    this.subType = 0,
  }) : super(type: ZIMMessageType.custom);

  ZIMCustomMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
      : message = map['message']!,
        searchedContent = map['searchedContent']!,
        subType = map['subType']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'message': message,
      'searchedContent': searchedContent,
      'subType': subType,
    });
    return baseMap;
  }
}

/// Combine message lite information.
class ZIMCombineMessageLiteInfo extends ZIMMessageLiteInfo {
  /// Description: Combine message title.
  String title;

  /// Description: Combine message summary.
  String summary;

  ZIMCombineMessageLiteInfo({this.title = '', this.summary = ''})
      : super(type: ZIMMessageType.combine);

  ZIMCombineMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
      : title = map['title']!,
        summary = map['summary']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'title': title, 'summary': summary});
    return baseMap;
  }
}

/// Revoke message lite information.
class ZIMRevokeMessageLiteInfo extends ZIMMessageLiteInfo {
  ZIMRevokeMessageLiteInfo() : super(type: ZIMMessageType.revoke);

  ZIMRevokeMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
      : super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({});
    return baseMap;
  }
}

/// Media message lite information.
class ZIMMediaMessageLiteInfo extends ZIMMessageLiteInfo {
  /// Description: Media file size.
  int fileSize;

  /// Description: Media file name.
  String fileName;

  /// Description: Media file local path.
  dynamic fileLocalPath;

  /// Description: Media file download address.
  String fileDownloadUrl;

  ZIMMediaMessageLiteInfo({
    ZIMMessageType? type,
    this.fileSize = 0,
    this.fileName = '',
    this.fileLocalPath = '',
    this.fileDownloadUrl = '',
  }) : super(type: type ?? ZIMMessageType.unknown);

  ZIMMediaMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
      : fileSize = map['fileSize']!,
        fileName = map['fileName']!,
        fileLocalPath = map['fileLocalPath']!,
        fileDownloadUrl = map['fileDownloadUrl']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'fileSize': fileSize,
      'fileName': fileName,
      'fileLocalPath': fileLocalPath,
      'fileDownloadUrl': fileDownloadUrl,
    });
    return baseMap;
  }
}

/// Image message lite information.
class ZIMImageMessageLiteInfo extends ZIMMediaMessageLiteInfo {
  /// Description: Original image width.
  int originalImageWidth;

  /// Description: Original image height.
  int originalImageHeight;

  /// Description: Large image width.
  int largeImageWidth;

  /// Description: Large image height.
  int largeImageHeight;

  /// Description: Large image local path.
  String largeImageLocalPath;

  /// Description: Large image download address.
  String largeImageDownloadUrl;

  /// Description: Thumbnail image width.
  int thumbnailWidth;

  /// Description: Thumbnail image height.
  int thumbnailHeight;

  /// Description: Thumbnail image local path.
  String thumbnailLocalPath;

  /// Description: Thumbnail image download address.
  String thumbnailDownloadUrl;

  ZIMImageMessageLiteInfo({
    this.originalImageWidth = 0,
    this.originalImageHeight = 0,
    this.largeImageWidth = 0,
    this.largeImageHeight = 0,
    this.largeImageLocalPath = '',
    this.largeImageDownloadUrl = '',
    this.thumbnailWidth = 0,
    this.thumbnailHeight = 0,
    this.thumbnailLocalPath = '',
    this.thumbnailDownloadUrl = '',
  }) : super(type: ZIMMessageType.image);

  ZIMImageMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
      : originalImageWidth = map['originalImageWidth']!,
        originalImageHeight = map['originalImageHeight']!,
        largeImageWidth = map['largeImageWidth']!,
        largeImageHeight = map['largeImageHeight']!,
        largeImageLocalPath = map['largeImageLocalPath']!,
        largeImageDownloadUrl = map['largeImageDownloadUrl']!,
        thumbnailWidth = map['thumbnailWidth']!,
        thumbnailHeight = map['thumbnailHeight']!,
        thumbnailLocalPath = map['thumbnailLocalPath']!,
        thumbnailDownloadUrl = map['thumbnailDownloadUrl']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'originalImageWidth': originalImageWidth,
      'originalImageHeight': originalImageHeight,
      'largeImageWidth': largeImageWidth,
      'largeImageHeight': largeImageHeight,
      'largeImageLocalPath': largeImageLocalPath,
      'largeImageDownloadUrl': largeImageDownloadUrl,
      'thumbnailWidth': thumbnailWidth,
      'thumbnailHeight': thumbnailHeight,
      'thumbnailLocalPath': thumbnailLocalPath,
      'thumbnailDownloadUrl': thumbnailDownloadUrl,
    });
    return baseMap;
  }
}

/// File message lite information.
class ZIMFileMessageLiteInfo extends ZIMMediaMessageLiteInfo {
  ZIMFileMessageLiteInfo() : super(type: ZIMMessageType.file);

  ZIMFileMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
      : super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({});
    return baseMap;
  }
}

/// Audio message lite information.
class ZIMAudioMessageLiteInfo extends ZIMMediaMessageLiteInfo {
  /// Description: Audio duration.
  int audioDuration;

  ZIMAudioMessageLiteInfo({this.audioDuration = 0})
      : super(type: ZIMMessageType.audio);

  ZIMAudioMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
      : audioDuration = map['audioDuration']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'audioDuration': audioDuration});
    return baseMap;
  }
}

/// Video message lite information.
class ZIMVideoMessageLiteInfo extends ZIMMediaMessageLiteInfo {
  /// Description: Video duration.
  int videoDuration;

  /// Description: Video first frame width.
  int videoFirstFrameWidth;

  /// Description: Video first frame height.
  int videoFirstFrameHeight;

  /// Description: Video first frame local path.
  String videoFirstFrameLocalPath;

  /// Description: Video first frame download address.
  String videoFirstFrameDownloadUrl;

  ZIMVideoMessageLiteInfo({
    this.videoDuration = 0,
    this.videoFirstFrameWidth = 0,
    this.videoFirstFrameHeight = 0,
    this.videoFirstFrameLocalPath = '',
    this.videoFirstFrameDownloadUrl = '',
  }) : super(type: ZIMMessageType.video);

  ZIMVideoMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
      : videoDuration = map['videoDuration']!,
        videoFirstFrameWidth = map['videoFirstFrameWidth']!,
        videoFirstFrameHeight = map['videoFirstFrameHeight']!,
        videoFirstFrameLocalPath = map['videoFirstFrameLocalPath']!,
        videoFirstFrameDownloadUrl = map['videoFirstFrameDownloadUrl']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'videoDuration': videoDuration,
      'videoFirstFrameWidth': videoFirstFrameWidth,
      'videoFirstFrameHeight': videoFirstFrameHeight,
      'videoFirstFrameLocalPath': videoFirstFrameLocalPath,
      'videoFirstFrameDownloadUrl': videoFirstFrameDownloadUrl,
    });
    return baseMap;
  }
}

/// Multiple messages lite information.
class ZIMMultipleMessageLiteInfo extends ZIMMessageLiteInfo {
  /// Description: Message list.
  List<ZIMMessageLiteInfo> messageInfoList;

  ZIMMultipleMessageLiteInfo({List<ZIMMessageLiteInfo>? messageInfoList})
      : messageInfoList = messageInfoList ?? [],
        super(type: ZIMMessageType.multiple);

  ZIMMultipleMessageLiteInfo.fromMap(Map<dynamic, dynamic> map)
      : messageInfoList = ((map['messageInfoList']!) as List)
            .map<ZIMMessageLiteInfo>(
              (item) => ZIMDataUtils.parseZIMMessageLiteInfoFromMap(item),
            )
            .toList(),
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'messageInfoList': messageInfoList.map((item) => item.toMap()).toList(),
    });
    return baseMap;
  }
}

/// Message replied information.
class ZIMMessageRepliedInfo {
  /// Description: Message replied state.
  ZIMMessageRepliedInfoState state;

  /// Description: Replied message lite information.
  ZIMMessageLiteInfo messageInfo;

  /// Description: Sender user ID of the replied message.
  String senderUserID;

  /// Description: Sent time of the replied message.
  int sentTime;

  /// Description: ID of the replied message.
  dynamic messageID;

  /// Description: Sequence number of the replied message.
  int messageSeq;

  ZIMMessageRepliedInfo({
    required this.state,
    required this.messageInfo,
    required this.senderUserID,
    required this.sentTime,
    required this.messageID,
    required this.messageSeq,
  });

  ZIMMessageRepliedInfo.fromMap(Map<dynamic, dynamic> map)
      : state = ZIMMessageRepliedInfoStateExtension.mapValue[map['state']] ??
            ZIMMessageRepliedInfoState.normal,
        messageInfo = ZIMDataUtils.parseZIMMessageLiteInfoFromMap(
          map['messageInfo'],
        ),
        senderUserID = map['senderUserID']!,
        sentTime = map['sentTime']!,
        messageID = map['messageID']!,
        messageSeq = map['messageSeq']!;

  Map<String, dynamic> toMap() {
    return {
      'state': state.value,
      'messageInfo': messageInfo.toMap(),
      'senderUserID': senderUserID,
      'sentTime': sentTime,
      'messageID': messageID,
      'messageSeq': messageSeq,
    };
  }
}

/// Base class of message object
///
/// Description: Identifies the basic parameters of a message.Caution: Some of the parameters, such as Message ID, only have values ​​during the callback.Developers do not need to assign values ​​to these parameters when they actively create this object for sending messages.
class ZIMMessage {
  /// Identifies the type of this message.
  ZIMMessageType type;

  /// Description: The unique ID that identifies this message.Use cases: Can be used to index other messages.Caution: When the developer actively creates a message, there is no need to modify this parameter.This parameter only has a value during callback.
  dynamic messageID;

  /// Description: SDK locally generated MessageID, developers do not need to pay attention to.
  dynamic localMessageID;

  /// Description: The sequence number of the message.
  int messageSeq;

  /// Description：Displays the userID of the sender of this message.
  String senderUserID;

  /// Description: Conversation ID. Ids of the same conversation type are unique.
  String conversationID;

  /// Description: The type of conversation to which the message belongs.
  ZIMConversationType conversationType;

  /// Description: Used to describe whether a message is sent or received.
  ZIMMessageDirection direction;

  /// Description: Describes the sending status of a message.
  ZIMMessageSentStatus sentStatus;

  /// Description: Identifies the sending time of a messageUse cases: Used to present the sending time of a message, and can be used for message sorting.Caution: This is a standard UNIX timestamp, in milliseconds.
  int timestamp;

  /// Description: Indicates the sequence number of the message in the conversation.
  @Deprecated(
    'This field was deprecated in version 2.18.0, please use [messageSeq] instead.',
  )
  int conversationSeq;

  /// Description:The larger the orderKey, the newer the message, and can be used for ordering messages.
  int orderKey;

  /// Detail description: Describes whether the message is a message inserted by the developer through [insertMessageToLocalDB].Default: false.
  bool isUserInserted;

  /// Detailed Description: Describe the receipt status of the messageBusiness scenario: used to determine the status of the current message in the receipt message
  ZIMMessageReceiptStatus receiptStatus;

  /// Description: message extension field Use cases: You can add extended fields to the message and send it to the peer Required: no Caution:the length is 1k, you can contact technical support for configuration Available since: 2.6.0 or higher
  String extendedData;

  /// Description:  The expandable message field visible only on this end can store additional information locally, Through [updateMessageLocalExtendedData] change and currently has a length limit of 128K. If you have special requirements, please contact ZEGO technical support for configuration.
  String localExtendedData;

  /// Description: Message statement list, which can carry data strongly related to users such as emoji expressions and voting information.
  List<ZIMMessageReaction> reactions;

  /// Description: Whether the message is pushed by all employees. Required: Internal assignment.
  bool isBroadcastMessage;

  /// Description: Whether to mention everyone. It can be presented as "@User". Use cases: For example, it can be used in sending messages. Required: No. Caution: This value does not add the "@User" to the message text. Developers need to implement it themselves. Available since: 2.14.0 or above
  List<String> mentionedUserIDs;

  /// Description: Whether to mention everyone. It can be presented as "@Everyone". Use cases: For example, it can be used in groups or rooms. Required: No. Default value: false. Recommended value: Set to true if you need to mention everyone. Caution: This value does not add the "@Everyone" to the message text. Developers need to implement it themselves. Available since: 2.14.0 or above
  bool isMentionAll;

  /// Description: Message reply information.
  ZIMMessageRepliedInfo? repliedInfo;

  /// Description: Root replied count.
  int rootRepliedCount;

  bool isServerMessage;

  String cbInnerID;

  /// Description: The userID of the message editor.
  String editorUserID;

  /// Description: The time of message editing.
  int editedTime;

  /// Indicates whether the message is a group-targeted message.
  bool isGroupTargetedMessage;

  /// Description: The userID of the message pinner.
  String pinnedUserID;

  /// Description: The time of message pinning.
  int pinnedTime;

  ZIMMessage({
    this.type = ZIMMessageType.unknown,
    this.messageID = 0,
    this.localMessageID = 0,
    this.messageSeq = 0,
    this.senderUserID = '',
    this.conversationID = '',
    this.conversationType = ZIMConversationType.unknown,
    this.direction = ZIMMessageDirection.send,
    this.sentStatus = ZIMMessageSentStatus.sending,
    this.timestamp = 0,
    this.conversationSeq = 0,
    this.orderKey = 0,
    this.isUserInserted = false,
    this.receiptStatus = ZIMMessageReceiptStatus.none,
    this.extendedData = '',
    this.localExtendedData = '',
    List<ZIMMessageReaction>? reactions,
    this.isBroadcastMessage = false,
    List<String>? mentionedUserIDs,
    this.isMentionAll = false,
    this.repliedInfo,
    this.rootRepliedCount = 0,
    this.isServerMessage = false,
    this.cbInnerID = '',
    this.editorUserID = '',
    this.editedTime = 0,
    this.isGroupTargetedMessage = false,
    this.pinnedUserID = '',
    this.pinnedTime = 0,
  })  : reactions = reactions ?? [],
        mentionedUserIDs = mentionedUserIDs ?? [];

  ZIMMessage.fromMap(Map<dynamic, dynamic> map)
      : type = ZIMMessageTypeExtension.mapValue[map['type']] ??
            ZIMMessageType.unknown,
        messageID = map['messageID']!,
        localMessageID = map['localMessageID']!,
        messageSeq = map['messageSeq']!,
        senderUserID = map['senderUserID']!,
        conversationID = map['conversationID']!,
        conversationType =
            ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
                ZIMConversationType.unknown,
        direction = ZIMMessageDirectionExtension.mapValue[map['direction']] ??
            ZIMMessageDirection.send,
        sentStatus =
            ZIMMessageSentStatusExtension.mapValue[map['sentStatus']] ??
                ZIMMessageSentStatus.sending,
        timestamp = map['timestamp']!,
        conversationSeq = map['messageSeq']!,
        orderKey = map['orderKey']!,
        isUserInserted = map['isUserInserted']!,
        receiptStatus =
            ZIMMessageReceiptStatusExtension.mapValue[map['receiptStatus']] ??
                ZIMMessageReceiptStatus.none,
        extendedData = map['extendedData']!,
        localExtendedData = map['localExtendedData']!,
        reactions = ((map['reactions']!) as List)
            .map<ZIMMessageReaction>((item) => ZIMMessageReaction.fromMap(item))
            .toList(),
        isBroadcastMessage = map['isBroadcastMessage']!,
        mentionedUserIDs = ((map['mentionedUserIDs']!) as List)
            .map<String>((item) => item as String)
            .toList(),
        isMentionAll = map['isMentionAll']!,
        repliedInfo = (map['repliedInfo'] != null)
            ? ZIMMessageRepliedInfo.fromMap(map['repliedInfo'])
            : null,
        rootRepliedCount = map['rootRepliedCount']!,
        isServerMessage = map['isServerMessage']!,
        cbInnerID = map['cbInnerID']!,
        editorUserID = map['editorUserID']!,
        editedTime = map['editedTime']!,
        isGroupTargetedMessage = map['isGroupTargetedMessage']!,
        pinnedUserID = map['pinnedUserID']!,
        pinnedTime = map['pinnedTime']!;

  Map<String, dynamic> toMap() {
    return {
      'type': type.value,
      'messageID': messageID,
      'localMessageID': localMessageID,
      'messageSeq': messageSeq,
      'senderUserID': senderUserID,
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'direction': direction.value,
      'sentStatus': sentStatus.value,
      'timestamp': timestamp,
      'conversationSeq': messageSeq,
      'orderKey': orderKey,
      'isUserInserted': isUserInserted,
      'receiptStatus': receiptStatus.value,
      'extendedData': extendedData,
      'localExtendedData': localExtendedData,
      'reactions': reactions.map((item) => item.toMap()).toList(),
      'isBroadcastMessage': isBroadcastMessage,
      'mentionedUserIDs': mentionedUserIDs,
      'isMentionAll': isMentionAll,
      'repliedInfo': repliedInfo?.toMap(),
      'rootRepliedCount': rootRepliedCount,
      'isServerMessage': isServerMessage,
      'cbInnerID': cbInnerID,
      'editorUserID': editorUserID,
      'editedTime': editedTime,
      'isGroupTargetedMessage': isGroupTargetedMessage,
      'pinnedUserID': pinnedUserID,
      'pinnedTime': pinnedTime,
    };
  }
}

/// Base class for media message objects.
///
/// Detail description: Identifies a media message.
/// Note: This base class is the basis of all media messages and contains the properties required by media messages.
class ZIMMediaMessage extends ZIMMessage {
  /// Detail description: The local path of the media message. Required: If a local file is sent, this parameter must be set by the sender. Otherwise, the message fails to be sent.
  dynamic fileLocalPath;

  /// Detail description: The external download url of the media message is used for the developer to transparently transmit the media file to other users by filling in this URL when the developer uploads the media file to his own server.Required or not: If an external URL is sent, this parameter is mandatory on the sender end.
  String fileDownloadUrl;

  /// Detail description: The unique ID of the media file. Required or not: The sender does not need to fill in, this value is generated by the SDK.
  String fileUID;

  /// Detail description: The filename of the media file. Required or not: If you are sending an external URL, you need to fill in this value and include the file extension. If a local file is sent, the value is optional.
  String fileName;

  /// Detail description: The size of the media file. Required or not: The sender does not need to fill in, this value is generated by the SDK.
  int fileSize;

  ZIMMediaMessage({
    required ZIMMessageType type,
    required this.fileLocalPath,
    this.fileDownloadUrl = '',
    this.fileUID = '',
    this.fileName = '',
    this.fileSize = 0,
  }) : super(type: type);

  ZIMMediaMessage.fromMap(Map<dynamic, dynamic> map)
      : fileLocalPath = map['fileLocalPath']!,
        fileDownloadUrl = map['fileDownloadUrl']!,
        fileUID = map['fileUID']!,
        fileName = map['fileName']!,
        fileSize = map['fileSize']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'fileLocalPath': fileLocalPath,
      'fileDownloadUrl': fileDownloadUrl,
      'fileUID': fileUID,
      'fileName': fileName,
      'fileSize': fileSize,
    });
    return baseMap;
  }
}

/// Normal text message object.
///
/// Description: Identifies the basic parameters of a message.
/// Caution: If the Type parameter of the base class is Text during callback, you can force the base class message object to be of this type.
class ZIMTextMessage extends ZIMMessage {
  /// The content of the text message.
  String message;

  ZIMTextMessage({required this.message}) : super(type: ZIMMessageType.text);

  ZIMTextMessage.fromMap(Map<dynamic, dynamic> map)
      : message = map['message']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'message': message});
    return baseMap;
  }
}

/// System text message object.
///
/// Detail description: Identifies a system text message.
/// Note: If the Type parameter of the base class is System during the callback, the base class message object can be cast to this class.
///
/// @deprecated Deprecated since ZIM 2.8.0, please use [ZIMCustomMessage] instead.
@Deprecated(
  'Deprecated since ZIM 2.8.0, please use [ZIMCustomMessage] instead.',
)
class ZIMSystemMessage extends ZIMMessage {
  /// Detailed description: The content of the message, which supports UTF-8 strings.
  String message;

  ZIMSystemMessage({required this.message})
      : super(type: ZIMMessageType.system);

  ZIMSystemMessage.fromMap(Map<dynamic, dynamic> map)
      : message = map['message']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'message': message});
    return baseMap;
  }
}

/// Custom message object.
///
/// todo
class ZIMCustomMessage extends ZIMMessage {
  /// The content of the text message.
  String message;

  /// Description: The search content of the message.
  String searchedContent;

  /// Description: The subtype of the message, which is used by customers to customize the usage of different custom messages. Required: The sender is required, otherwise the message will fail to be sent.
  int subType;

  ZIMCustomMessage({
    required this.message,
    required this.searchedContent,
    this.subType = 0,
  }) : super(type: ZIMMessageType.custom);

  ZIMCustomMessage.fromMap(Map<dynamic, dynamic> map)
      : message = map['message']!,
        searchedContent = map['searchedContent']!,
        subType = map['subType']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'message': message,
      'searchedContent': searchedContent,
      'subType': subType,
    });
    return baseMap;
  }
}

/// Custom binary message object.
///
/// Description: Identifies a binary message.
/// Caution: If the Type parameter of the base class is Custom during callback, you can force the base class message object to be of this type.
class ZIMCommandMessage extends ZIMMessage {
  /// The content of the custom message.
  Uint8List message;

  ZIMCommandMessage({required this.message})
      : super(type: ZIMMessageType.command);

  ZIMCommandMessage.fromMap(Map<dynamic, dynamic> map)
      : message = map['message'] is Uint8List
            ? map['message']
            : ZIMDataUtils.convertToUInt8List(map['message']),
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'message': message});
    return baseMap;
  }
}

/// Barrage message class.
///
/// Description: The barrage message class does not appear in the session and does not store historical messages.
class ZIMBarrageMessage extends ZIMMessage {
  /// Description: The content of the barrage message.
  String message;

  ZIMBarrageMessage({required this.message})
      : super(type: ZIMMessageType.barrage);

  ZIMBarrageMessage.fromMap(Map<dynamic, dynamic> map)
      : message = map['message']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'message': message});
    return baseMap;
  }
}

/// Image message object.
///
/// Description: Identifies the basic parameters of a message.
/// Caution: If the Type parameter of the base class is Image during callback, you can force the base class message object to be of this type.
class ZIMImageMessage extends ZIMMediaMessage {
  /// Detail description: Thumbnail external download URL of the image file. When developers upload thumbnails to their own servers, the SDK can pass through this field to other users. Required or not: optional on the sender side, this field will only take effect when fileDownloadUrl is filled in.
  String thumbnailDownloadUrl;

  /// Detailed description: The thumbnail local path of the image file. Required or not: The sender does not need to fill in it. After calling [downloadMediaFile] to download, the SDK will generate this value.
  String thumbnailLocalPath;

  /// Detail description: large Image external download URL of the image file. When developers upload large Images to their own servers, the SDK can pass through this field to other users.Required or not: optional on the sender side, this field will only take effect when fileDownloadUrl is filled in.
  String largeImageDownloadUrl;

  /// Detailed description: The large image local path of the image file. Required or not: The sender does not need to fill in it. After calling [downloadMediaFile] to download, the SDK will generate this value.
  String largeImageLocalPath;

  /// Detailed description: The width of the original image.
  int originalImageWidth;

  /// Detailed description: The height of the original image.
  int originalImageHeight;

  /// Detailed description: The width of the large image.
  int largeImageWidth;

  /// Detailed description: The height of the large image.
  int largeImageHeight;

  /// Detailed description: The width of the thumbnail.
  int thumbnailWidth;

  /// Detailed description: The height of the thumbnail.
  int thumbnailHeight;

  ZIMImageMessage(
    dynamic fileLocalPath, {
    this.thumbnailDownloadUrl = '',
    this.thumbnailLocalPath = '',
    this.largeImageDownloadUrl = '',
    this.largeImageLocalPath = '',
    this.originalImageWidth = 0,
    this.originalImageHeight = 0,
    this.largeImageWidth = 0,
    this.largeImageHeight = 0,
    this.thumbnailWidth = 0,
    this.thumbnailHeight = 0,
  }) : super(type: ZIMMessageType.image, fileLocalPath: fileLocalPath);

  ZIMImageMessage.fromMap(Map<dynamic, dynamic> map)
      : thumbnailDownloadUrl = map['thumbnailDownloadUrl']!,
        thumbnailLocalPath = map['thumbnailLocalPath']!,
        largeImageDownloadUrl = map['largeImageDownloadUrl']!,
        largeImageLocalPath = map['largeImageLocalPath']!,
        originalImageWidth = map['originalImageWidth']!,
        originalImageHeight = map['originalImageHeight']!,
        largeImageWidth = map['largeImageWidth']!,
        largeImageHeight = map['largeImageHeight']!,
        thumbnailWidth = map['thumbnailWidth']!,
        thumbnailHeight = map['thumbnailHeight']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'thumbnailDownloadUrl': thumbnailDownloadUrl,
      'thumbnailLocalPath': thumbnailLocalPath,
      'largeImageDownloadUrl': largeImageDownloadUrl,
      'largeImageLocalPath': largeImageLocalPath,
      'originalImageWidth': originalImageWidth,
      'originalImageHeight': originalImageHeight,
      'largeImageWidth': largeImageWidth,
      'largeImageHeight': largeImageHeight,
      'thumbnailWidth': thumbnailWidth,
      'thumbnailHeight': thumbnailHeight,
    });
    return baseMap;
  }
}

/// File message object.
///
/// Description: Identifies the basic parameters of a message.
/// Caution: If the Type parameter of the base class is File during callback,you can force the base class message object to be of this type.
class ZIMFileMessage extends ZIMMediaMessage {
  ZIMFileMessage(dynamic fileLocalPath)
      : super(type: ZIMMessageType.file, fileLocalPath: fileLocalPath);

  ZIMFileMessage.fromMap(Map<dynamic, dynamic> map) : super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({});
    return baseMap;
  }
}

/// Audio message object.
///
/// Description: Identifies the basic parameters of a message.
/// Caution: If the Type parameter of the base class is Audio during callback, you can force the base class message object to be of this type.
class ZIMAudioMessage extends ZIMMediaMessage {
  /// Detail description: The duration of the audio file. Required: Required by the sender, if not filled, the audio message will fail to be sent When sending local audio messages.
  int audioDuration;

  ZIMAudioMessage(dynamic fileLocalPath, {this.audioDuration = 0})
      : super(type: ZIMMessageType.audio, fileLocalPath: fileLocalPath);

  ZIMAudioMessage.fromMap(Map<dynamic, dynamic> map)
      : audioDuration = map['audioDuration']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'audioDuration': audioDuration});
    return baseMap;
  }
}

/// Video message object.
///
/// todo
class ZIMVideoMessage extends ZIMMediaMessage {
  /// Detail description: The duration of the video file. Required: Required by the sender, if not filled, the video message will fail to be sent when sending local video messages.
  int videoDuration;

  /// Detail description: Video first frame external download URL of the video file. When developers upload thumbnails to their own servers, the SDK can pass through this field to other users. Required or not: optional on the sender side, this field will only take effect when fileDownloadUrl is filled in.
  String videoFirstFrameDownloadUrl;

  /// Detailed description: The video first frame local path of the video file. Required or not: The sender does not need to fill in it. After calling [downloadMediaFile] to download, the SDK will generate this value.
  String videoFirstFrameLocalPath;

  /// Detailed description: The width of the first frame of the video.
  int videoFirstFrameWidth;

  /// Detailed description: The height of the first frame of the video.
  int videoFirstFrameHeight;

  ZIMVideoMessage(
    dynamic fileLocalPath, {
    this.videoDuration = 0,
    this.videoFirstFrameDownloadUrl = '',
    this.videoFirstFrameLocalPath = '',
    this.videoFirstFrameWidth = 0,
    this.videoFirstFrameHeight = 0,
  }) : super(type: ZIMMessageType.video, fileLocalPath: fileLocalPath);

  ZIMVideoMessage.fromMap(Map<dynamic, dynamic> map)
      : videoDuration = map['videoDuration']!,
        videoFirstFrameDownloadUrl = map['videoFirstFrameDownloadUrl']!,
        videoFirstFrameLocalPath = map['videoFirstFrameLocalPath']!,
        videoFirstFrameWidth = map['videoFirstFrameWidth']!,
        videoFirstFrameHeight = map['videoFirstFrameHeight']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'videoDuration': videoDuration,
      'videoFirstFrameDownloadUrl': videoFirstFrameDownloadUrl,
      'videoFirstFrameLocalPath': videoFirstFrameLocalPath,
      'videoFirstFrameWidth': videoFirstFrameWidth,
      'videoFirstFrameHeight': videoFirstFrameHeight,
    });
    return baseMap;
  }
}

/// Base class for revoke message objects.
///
/// Detail description: Identifies a revoke message.
/// Note: This base class is the basis of all revoke messages and contains the properties required by revoke messages.
class ZIMRevokeMessage extends ZIMMessage {
  /// Detail description: revoke type.
  ZIMRevokeType revokeType;

  /// Detail description: revoke timestamp.
  int revokeTimestamp;

  /// Detail description: operated user ID.
  String operatedUserID;

  /// Description: original message type
  ZIMMessageType originalMessageType;

  /// Detail description: original text message content, if the message to be revoked is not a text message, this field is empty.
  String originalTextMessageContent;

  /// Detail description: revoke extended data.
  String revokeExtendedData;

  /// Detail description: revoke status.
  ZIMMessageRevokeStatus revokeStatus;

  ZIMRevokeMessage({
    this.revokeType = ZIMRevokeType.unknown,
    this.revokeTimestamp = 0,
    this.operatedUserID = '',
    this.originalMessageType = ZIMMessageType.unknown,
    this.originalTextMessageContent = '',
    this.revokeExtendedData = '',
    this.revokeStatus = ZIMMessageRevokeStatus.unknown,
  }) : super(type: ZIMMessageType.revoke);

  ZIMRevokeMessage.fromMap(Map<dynamic, dynamic> map)
      : revokeType = ZIMRevokeTypeExtension.mapValue[map['revokeType']] ??
            ZIMRevokeType.unknown,
        revokeTimestamp = map['revokeTimestamp']!,
        operatedUserID = map['operatedUserID']!,
        originalMessageType =
            ZIMMessageTypeExtension.mapValue[map['originalMessageType']] ??
                ZIMMessageType.unknown,
        originalTextMessageContent = map['originalTextMessageContent']!,
        revokeExtendedData = map['revokeExtendedData']!,
        revokeStatus =
            ZIMMessageRevokeStatusExtension.mapValue[map['revokeStatus']] ??
                ZIMMessageRevokeStatus.unknown,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'revokeType': revokeType.value,
      'revokeTimestamp': revokeTimestamp,
      'operatedUserID': operatedUserID,
      'originalMessageType': originalMessageType.value,
      'originalTextMessageContent': originalTextMessageContent,
      'revokeExtendedData': revokeExtendedData,
      'revokeStatus': revokeStatus.value,
    });
    return baseMap;
  }
}

/// Base class for combine message objects.
///
/// Detail description: Identifies a combine message.
/// Note: This base class is the basis of all combine messages and contains the properties required by combine messages.
/// Available since: 2.14.0 and above.
class ZIMCombineMessage extends ZIMMessage {
  /// Detail description: Combine message title.
  String title;

  /// Detail description: The summary of combine message.
  String summary;

  /// Detail description: Combine ID, internal used
  String combineID;

  /// List of child messages
  List<ZIMMessage> messageList;

  ZIMCombineMessage({
    required this.title,
    required this.summary,
    this.combineID = '',
    required this.messageList,
  }) : super(type: ZIMMessageType.combine);

  ZIMCombineMessage.fromMap(Map<dynamic, dynamic> map)
      : title = map['title']!,
        summary = map['summary']!,
        combineID = map['combineID']!,
        messageList = ((map['messageList']!) as List)
            .map<ZIMMessage>(
                (item) => ZIMDataUtils.parseZIMMessageFromMap(item))
            .toList(),
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'title': title,
      'summary': summary,
      'combineID': combineID,
      'messageList': messageList.map((item) => item.toMap()).toList(),
    });
    return baseMap;
  }
}

/// Tips message.
class ZIMTipsMessage extends ZIMMessage {
  /// Detail description: Tips event type.
  ZIMTipsMessageEvent event;

  /// Detail description: Operated user information.
  ZIMUserInfo? operatedUser;

  /// Detail description: Target user list.
  List<ZIMUserInfo> targetUserList;

  /// Detail description: Change information.
  ZIMTipsMessageChangeInfo? changeInfo;

  ZIMTipsMessage({
    required this.event,
    this.operatedUser,
    required this.targetUserList,
    this.changeInfo,
  }) : super(type: ZIMMessageType.tips);

  ZIMTipsMessage.fromMap(Map<dynamic, dynamic> map)
      : event = ZIMTipsMessageEventExtension.mapValue[map['event']] ??
            ZIMTipsMessageEvent.unknown,
        operatedUser = (map['operatedUser'] != null)
            ? ZIMDataUtils.parseZIMUserInfoFromMap(map['operatedUser'])
            : null,
        targetUserList = ((map['targetUserList']!) as List)
            .map<ZIMUserInfo>(
              (item) => ZIMDataUtils.parseZIMUserInfoFromMap(item),
            )
            .toList(),
        changeInfo = (map['changeInfo'] != null)
            ? ZIMDataUtils.parseZIMTipsMessageChangeInfoFromMap(
                map['changeInfo'])
            : null,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'event': event.value,
      'operatedUser': operatedUser?.toMap(),
      'targetUserList': targetUserList.map((item) => item.toMap()).toList(),
      'changeInfo': changeInfo?.toMap(),
    });
    return baseMap;
  }
}

/// Multiple message.
class ZIMMultipleMessage extends ZIMMessage {
  /// Detail description: List of content in the multiple message.
  List<ZIMMessageLiteInfo> messageInfoList;

  /// Detail description: List of failed index in the multiple message.
  List<int> failedIndexList;

  ZIMMultipleMessage({
    required this.messageInfoList,
    List<int>? failedIndexList,
  })  : failedIndexList = failedIndexList ?? [],
        super(type: ZIMMessageType.multiple);

  ZIMMultipleMessage.fromMap(Map<dynamic, dynamic> map)
      : messageInfoList = ((map['messageInfoList']!) as List)
            .map<ZIMMessageLiteInfo>(
              (item) => ZIMDataUtils.parseZIMMessageLiteInfoFromMap(item),
            )
            .toList(),
        failedIndexList = ((map['failedIndexList']!) as List)
            .map<int>((item) => item as int)
            .toList(),
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'messageInfoList': messageInfoList.map((item) => item.toMap()).toList(),
      'failedIndexList': failedIndexList,
    });
    return baseMap;
  }
}

/// Message root replied information.
class ZIMMessageRootRepliedInfo {
  /// Description: Message replied state.
  ZIMMessageRepliedInfoState state;

  /// Description: Root message.
  ZIMMessage? message;

  /// Description: Sender user ID of the root message.
  String senderUserID;

  /// Description: Sent time of the root message.
  int sentTime;

  /// Description: Root replied count.
  int repliedCount;

  ZIMMessageRootRepliedInfo({
    required this.state,
    this.message,
    required this.senderUserID,
    required this.sentTime,
    required this.repliedCount,
  });

  ZIMMessageRootRepliedInfo.fromMap(Map<dynamic, dynamic> map)
      : state = ZIMMessageRepliedInfoStateExtension.mapValue[map['state']] ??
            ZIMMessageRepliedInfoState.normal,
        message = (map['message'] != null)
            ? ZIMDataUtils.parseZIMMessageFromMap(map['message'])
            : null,
        senderUserID = map['senderUserID']!,
        sentTime = map['sentTime']!,
        repliedCount = map['repliedCount']!;

  Map<String, dynamic> toMap() {
    return {
      'state': state.value,
      'message': message?.toMap(),
      'senderUserID': senderUserID,
      'sentTime': sentTime,
      'repliedCount': repliedCount,
    };
  }
}

/// Message root replied count information.
class ZIMMessageRootRepliedCountInfo {
  /// Description: Message ID.
  dynamic messageID;

  /// Description: Conversation ID.
  String conversationID;

  /// Description: Conversation type.
  ZIMConversationType conversationType;

  /// Description: Root replied count.
  int count;

  ZIMMessageRootRepliedCountInfo({
    required this.messageID,
    required this.conversationID,
    required this.conversationType,
    required this.count,
  });

  ZIMMessageRootRepliedCountInfo.fromMap(Map<dynamic, dynamic> map)
      : messageID = map['messageID']!,
        conversationID = map['conversationID']!,
        conversationType =
            ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
                ZIMConversationType.unknown,
        count = map['count']!;

  Map<String, dynamic> toMap() {
    return {
      'messageID': messageID,
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'count': count,
    };
  }
}

/// message mention information.
///
/// message mention information.
class ZIMMessageMentionedInfo {
  /// Description: Message ID, used to match the notification information to which message it belongs toRequired or not: Developers do not need to fill in.
  dynamic messageID;

  /// Description: Message sequence number, used to match the notification information to which message it belongs toRequired or not: Developers do not need to fill in.
  int messageSeq;

  /// Description: From which user. Required:  Developers do not need to fill in.
  String fromUserID;

  /// Details Description: Type of notification, used to distinguish between reminding oneself and reminding everyone. Required: Developers do not need to fill in.
  ZIMMessageMentionedType type;

  ZIMMessageMentionedInfo({
    required this.messageID,
    required this.messageSeq,
    required this.fromUserID,
    required this.type,
  });

  ZIMMessageMentionedInfo.fromMap(Map<dynamic, dynamic> map)
      : messageID = map['messageID']!,
        messageSeq = map['messageSeq']!,
        fromUserID = map['fromUserID']!,
        type = ZIMMessageMentionedTypeExtension.mapValue[map['type']] ??
            ZIMMessageMentionedType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'messageID': messageID,
      'messageSeq': messageSeq,
      'fromUserID': fromUserID,
      'type': type.value,
    };
  }
}

/// Additional information when receiving messages.
class ZIMMessageReceivedInfo {
  /// Description: Whether it is an offline message.
  bool isOfflineMessage;

  ZIMMessageReceivedInfo({required this.isOfflineMessage});

  ZIMMessageReceivedInfo.fromMap(Map<dynamic, dynamic> map)
      : isOfflineMessage = map['isOfflineMessage']!;

  Map<String, dynamic> toMap() {
    return {'isOfflineMessage': isOfflineMessage};
  }
}

/// Configurations related to sending messages.
///
/// Description: Configurations related to sending messages.
class ZIMMessageSendConfig {
  /// Description: Configures the offline push function, If Android or iOS platform is integrated, it is strongly recommended to configure this. Required: Not mandatory.
  ZIMPushConfig? pushConfig;

  /// Enumeration value used to set message priority. Required: Must mandatory.
  ZIMMessagePriority priority;

  /// Detailed description: When sending a message, whether the message has a receipt.Business scenario: use when you need to bring a receipt for a message.Required: not required.Default value: false.
  bool hasReceipt;

  /// todo
  bool isNotifyMentionedUsers;

  /// todo
  bool isRetrySend;

  /// When sending messages that would otherwise affect the other party's unread count, should they no longer be counted as unread by the other party? Whether required: Not required. Default value: false.
  bool disableUnreadMessageCount;

  /// Whether to allow some sub-messages to fail to send when sending a multiple message. Whether required: Not required. Default value: false.
  bool isAllowMultipleMessagePartialFailed;

  ZIMMessageSendConfig({
    this.pushConfig,
    this.priority = ZIMMessagePriority.low,
    this.hasReceipt = false,
    this.isNotifyMentionedUsers = true,
    this.isRetrySend = false,
    this.disableUnreadMessageCount = false,
    this.isAllowMultipleMessagePartialFailed = false,
  });

  ZIMMessageSendConfig.fromMap(Map<dynamic, dynamic> map)
      : pushConfig = (map['pushConfig'] != null)
            ? ZIMPushConfig.fromMap(map['pushConfig'])
            : null,
        priority = ZIMMessagePriorityExtension.mapValue[map['priority']] ??
            ZIMMessagePriority.low,
        hasReceipt = map['hasReceipt']!,
        isNotifyMentionedUsers = map['isNotifyMentionedUsers']!,
        isRetrySend = map['isRetrySend']!,
        disableUnreadMessageCount = map['disableUnreadMessageCount']!,
        isAllowMultipleMessagePartialFailed =
            map['isAllowMultipleMessagePartialFailed']!;

  Map<String, dynamic> toMap() {
    return {
      'pushConfig': pushConfig?.toMap(),
      'priority': priority.value,
      'hasReceipt': hasReceipt,
      'isNotifyMentionedUsers': isNotifyMentionedUsers,
      'isRetrySend': isRetrySend,
      'disableUnreadMessageCount': disableUnreadMessageCount,
      'isAllowMultipleMessagePartialFailed':
          isAllowMultipleMessagePartialFailed,
    };
  }
}

/// Example Query message configuration.
///
/// Description: Example Query the configurations of messages.
class ZIMMessageQueryConfig {
  /// Description: Query the anchor point of the message. Required: This parameter is not required for the first query but is required for subsequent paging queries.
  ZIMMessage? nextMessage;

  /// Description: Number of query messages. Required: not required.
  int count;

  /// Description: Indicates whether the query is in reverse order. Required: not required. Default value: false.
  bool reverse;

  /// Description: Sets the mode for querying historical messages. Since the SDK can determine whether local data is complete and therefore return historical messages more quickly, it is recommended to use the default value in most cases. Required: No.
  ZIMMessageQueryMode mode;

  ZIMMessageQueryConfig({
    this.nextMessage,
    this.count = 0,
    this.reverse = false,
    this.mode = ZIMMessageQueryMode.general,
  });

  ZIMMessageQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : nextMessage = (map['nextMessage'] != null)
            ? ZIMDataUtils.parseZIMMessageFromMap(map['nextMessage'])
            : null,
        count = map['count']!,
        reverse = map['reverse']!,
        mode = ZIMMessageQueryModeExtension.mapValue[map['mode']] ??
            ZIMMessageQueryMode.general;

  Map<String, dynamic> toMap() {
    return {
      'nextMessage': nextMessage?.toMap(),
      'count': count,
      'reverse': reverse,
      'mode': mode.value,
    };
  }
}

/// Revoke configurations related to messages.
///
/// Description: Revoke configurations related to messages.
class ZIMMessageRevokeConfig {
  /// Description: Configures the offline push function, If Android or iOS platform is integrated, it is strongly recommended to configure this. Required: Not required.
  ZIMPushConfig? pushConfig;

  /// Description: revoking additional messages. Required: Not required.
  String revokeExtendedData;

  ZIMMessageRevokeConfig({this.pushConfig, this.revokeExtendedData = ''});

  ZIMMessageRevokeConfig.fromMap(Map<dynamic, dynamic> map)
      : pushConfig = (map['pushConfig'] != null)
            ? ZIMPushConfig.fromMap(map['pushConfig'])
            : null,
        revokeExtendedData = map['revokeExtendedData']!;

  Map<String, dynamic> toMap() {
    return {
      'pushConfig': pushConfig?.toMap(),
      'revokeExtendedData': revokeExtendedData,
    };
  }
}

/// Delete message configuration.
///
/// Description: Delete configurations related to messages.
class ZIMMessageDeleteConfig {
  /// Description: Whether to remove flags for server messages. Required: not required. Default value: false.
  bool isAlsoDeleteServerMessage;

  ZIMMessageDeleteConfig({this.isAlsoDeleteServerMessage = false});

  ZIMMessageDeleteConfig.fromMap(Map<dynamic, dynamic> map)
      : isAlsoDeleteServerMessage = map['isAlsoDeleteServerMessage']!;

  Map<String, dynamic> toMap() {
    return {'isAlsoDeleteServerMessage': isAlsoDeleteServerMessage};
  }
}

/// Deleted message information.
///
/// todo
class ZIMMessageDeletedInfo {
  /// Description: Conversation ID.
  String conversationID;

  /// Description: Conversation type.
  ZIMConversationType conversationType;

  /// Description: Whether to delete all current messages in the conversation.
  @Deprecated(
    'This field was deprecated in version 2.14.0, please use [messageDeleteType] instead.',
  )
  bool isDeleteConversationAllMessage;

  ZIMMessageDeleteType messageDeleteType;

  /// List of deleted messages. Valid when [ZIMMessageDeleteType] is [ZIMMessageDeleteTypeMessageListDeleted].
  List<ZIMMessage> messageList;

  ZIMMessageDeletedInfo({
    required this.conversationID,
    required this.conversationType,
    required this.isDeleteConversationAllMessage,
    required this.messageDeleteType,
    required this.messageList,
  });

  ZIMMessageDeletedInfo.fromMap(Map<dynamic, dynamic> map)
      : conversationID = map['conversationID']!,
        conversationType =
            ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
                ZIMConversationType.unknown,
        isDeleteConversationAllMessage = map['isDeleteConversationAllMessage']!,
        messageDeleteType =
            ZIMMessageDeleteTypeExtension.mapValue[map['messageDeleteType']] ??
                ZIMMessageDeleteType.messageListDeleted,
        messageList = ((map['messageList']!) as List)
            .map<ZIMMessage>(
                (item) => ZIMDataUtils.parseZIMMessageFromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'isDeleteConversationAllMessage': isDeleteConversationAllMessage,
      'messageDeleteType': messageDeleteType.value,
      'messageList': messageList.map((item) => item.toMap()).toList(),
    };
  }
}

/// The notification callback when the message is sent, you can get the relevant information before the message object is sent through this notification
///
/// Detailed description: Through this notification, developers can obtain relevant information before the message object is sent, such as localMessageID, etc.
/// Business scenario: When developers need to record and cache relevant information before sending a message, they can obtain it by listening to the notification.
/// Note: If no monitoring is required, it can be passed null.
class ZIMMessageSendNotification {
  /// Detail description: After the message falls into the local DB, the notification will be called back before the message is sent to the server. Business scenario: This interface can be used when the developer needs to obtain the relevant information in the message in advance before sending the message. Required: not required. If no monitoring is required, it can be passed empty. Default: empty.
  ZIMMessageAttachedCallback? onMessageAttached;

  /// Description: Media file upload progress.
  ZIMMediaUploadingProgress? onMediaUploadingProgress;

  /// Description: Multiple media file upload progress.
  ZIMMultipleMediaUploadingProgress? onMultipleMediaUploadingProgress;

  ZIMMessageSendNotification({
    this.onMessageAttached,
    this.onMediaUploadingProgress,
    this.onMultipleMediaUploadingProgress,
  });
}

/// todo
///
/// todo
class ZIMMediaMessageSendNotification {
  /// Detail description: After the message falls into the local DB, the notification will be called back before the message is sent to the server. Business scenario: This interface can be used when the developer needs to obtain the relevant information in the message in advance before sending the message. Required: not required. If no monitoring is required, it can be passed empty. Default: empty.
  ZIMMessageAttachedCallback? onMessageAttached;

  ZIMMediaUploadingProgress? onMediaUploadingProgress;

  ZIMMediaMessageSendNotification({
    this.onMessageAttached,
    this.onMediaUploadingProgress,
  });
}

/// receipt information.
///
/// Detailed description: receipt information.
class ZIMMessageReceiptInfo {
  /// Detail description: receipt status.
  ZIMMessageReceiptStatus status;

  /// Detailed Description: Message ID. Business scenario: Developers can match the loaded message list according to this ID. Is it required: No, SDK fills in.
  dynamic messageID;

  String conversationID;

  ZIMConversationType conversationType;

  /// Description: Number of read members.
  int readMemberCount;

  /// Description: Number of unread members.
  int unreadMemberCount;

  /// Description: Whether it is self-operated by multi-terminal.
  bool isSelfOperated;

  /// Description: All the recipients have read the timestamp of that moment.
  int readTime;

  ZIMMessageReceiptInfo({
    required this.status,
    required this.messageID,
    required this.conversationID,
    required this.conversationType,
    required this.readMemberCount,
    required this.unreadMemberCount,
    required this.isSelfOperated,
    this.readTime = 0,
  });

  ZIMMessageReceiptInfo.fromMap(Map<dynamic, dynamic> map)
      : status = ZIMMessageReceiptStatusExtension.mapValue[map['status']] ??
            ZIMMessageReceiptStatus.unknown,
        messageID = map['messageID']!,
        conversationID = map['conversationID']!,
        conversationType =
            ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
                ZIMConversationType.unknown,
        readMemberCount = map['readMemberCount']!,
        unreadMemberCount = map['unreadMemberCount']!,
        isSelfOperated = map['isSelfOperated']!,
        readTime = map['readTime']!;

  Map<String, dynamic> toMap() {
    return {
      'status': status.value,
      'messageID': messageID,
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'readMemberCount': readMemberCount,
      'unreadMemberCount': unreadMemberCount,
      'isSelfOperated': isSelfOperated,
      'readTime': readTime,
    };
  }
}

/// Configuration for querying reaction user list
///
/// Description: When querying reaction member, you need to configure this object.
class ZIMMessageReactionUserQueryConfig {
  /// Description: The flag of the paging query. For the first query, set this field to an empty string. If the "nextFlag" field of the [ZIMMessageReactionUserListQueriedCallback] callback is not an empty string, it needs to be set here to continue the query on the next page.Required: Not required.
  int nextFlag;

  /// Description: How many members are retrieved in one query, 100 at most.Caution: To obtain members in pages to reduce overhead, it is recommended to obtain within 20 members at a time. If the value is 0, the SDK will query 100 members by default.Required: Required.
  int count;

  /// Description: reaction type, defined by you.
  String reactionType;

  ZIMMessageReactionUserQueryConfig({
    this.nextFlag = 0,
    this.count = 0,
    this.reactionType = '',
  });

  ZIMMessageReactionUserQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : nextFlag = map['nextFlag']!,
        count = map['count']!,
        reactionType = map['reactionType']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count, 'reactionType': reactionType};
  }
}

/// todo
///
/// todo
class ZIMMessageSentStatusChangeInfo {
  ZIMMessageSentStatus status;

  ZIMMessage? message;

  String reason;

  ZIMMessageSentStatusChangeInfo({
    required this.status,
    this.message,
    required this.reason,
  });

  ZIMMessageSentStatusChangeInfo.fromMap(Map<dynamic, dynamic> map)
      : status = ZIMMessageSentStatusExtension.mapValue[map['status']] ??
            ZIMMessageSentStatus.sending,
        message = (map['message'] != null)
            ? ZIMDataUtils.parseZIMMessageFromMap(map['message'])
            : null,
        reason = map['reason']!;

  Map<String, dynamic> toMap() {
    return {
      'status': status.value,
      'message': message?.toMap(),
      'reason': reason,
    };
  }
}

/// todo
///
/// todo
class ZIMMessageSearchConfig {
  ZIMMessage? nextMessage;

  int count;

  ZIMMessageOrder order;

  List<String> keywords;

  List<ZIMMessageType> messageTypes;

  List<int> subMessageTypes;

  List<String> senderUserIDs;

  int startTime;

  int endTime;

  ZIMMessageSearchConfig({
    this.nextMessage,
    this.count = 0,
    this.order = ZIMMessageOrder.descending,
    List<String>? keywords,
    List<ZIMMessageType>? messageTypes,
    List<int>? subMessageTypes,
    List<String>? senderUserIDs,
    this.startTime = 0,
    this.endTime = 0,
  })  : keywords = keywords ?? [],
        messageTypes = messageTypes ?? [],
        subMessageTypes = subMessageTypes ?? [],
        senderUserIDs = senderUserIDs ?? [];

  ZIMMessageSearchConfig.fromMap(Map<dynamic, dynamic> map)
      : nextMessage = (map['nextMessage'] != null)
            ? ZIMDataUtils.parseZIMMessageFromMap(map['nextMessage'])
            : null,
        count = map['count']!,
        order = ZIMMessageOrderExtension.mapValue[map['order']] ??
            ZIMMessageOrder.descending,
        keywords = ((map['keywords']!) as List)
            .map<String>((item) => item as String)
            .toList(),
        messageTypes = ((map['messageTypes']!) as List)
            .map<ZIMMessageType>(
              (item) =>
                  ZIMMessageTypeExtension.mapValue[item] ??
                  ZIMMessageType.unknown,
            )
            .toList(),
        subMessageTypes = ((map['subMessageTypes']!) as List)
            .map<int>((item) => item as int)
            .toList(),
        senderUserIDs = ((map['senderUserIDs']!) as List)
            .map<String>((item) => item as String)
            .toList(),
        startTime = map['startTime']!,
        endTime = map['endTime']!;

  Map<String, dynamic> toMap() {
    return {
      'nextMessage': nextMessage?.toMap(),
      'count': count,
      'order': order.value,
      'keywords': keywords,
      'messageTypes': messageTypes.map((item) => item.value).toList(),
      'subMessageTypes': subMessageTypes,
      'senderUserIDs': senderUserIDs,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

/// todo
///
/// todo
class ZIMMessageRepliedListQueryConfig {
  int nextFlag;

  int count;

  ZIMMessageRepliedListQueryConfig({this.nextFlag = 0, this.count = 0});

  ZIMMessageRepliedListQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : nextFlag = map['nextFlag']!,
        count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// todo
///
/// todo
class ZIMMediaDownloadConfig {
  int messageInfoIndex;

  ZIMMediaDownloadConfig({this.messageInfoIndex = 0});

  ZIMMediaDownloadConfig.fromMap(Map<dynamic, dynamic> map)
      : messageInfoIndex = map['messageInfoIndex']!;

  Map<String, dynamic> toMap() {
    return {'messageInfoIndex': messageInfoIndex};
  }
}

/// todo
///
/// todo
class ZIMMessageEditConfig {
  ZIMMessageEditConfig();

  ZIMMessageEditConfig.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// todo
///
/// todo
class ZIMSendingMessageCancelConfig {
  ZIMSendingMessageCancelConfig();

  ZIMSendingMessageCancelConfig.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// Pinning message configuration
class ZIMMessagePinConfig {
  /// When the number of pinned messages exceeds the limit, replacing older pinned messages in the pinned list during the next pin operation is not allowed. The default value is [false].
  bool disableAutoReplace;

  ZIMMessagePinConfig({this.disableAutoReplace = false});

  ZIMMessagePinConfig.fromMap(Map<dynamic, dynamic> map)
      : disableAutoReplace = map['disableAutoReplace']!;

  Map<String, dynamic> toMap() {
    return {'disableAutoReplace': disableAutoReplace};
  }
}

/// todo
///
/// todo
class ZIMTipsMessageChangeInfo {
  ZIMTipsMessageChangeInfoType type;

  ZIMTipsMessageChangeInfo({required this.type});

  ZIMTipsMessageChangeInfo.fromMap(Map<dynamic, dynamic> map)
      : type = ZIMTipsMessageChangeInfoTypeExtension.mapValue[map['type']] ??
            ZIMTipsMessageChangeInfoType.unknown;

  Map<String, dynamic> toMap() {
    return {'type': type.value};
  }
}

/// todo
///
/// todo
class ZIMTipsMessageGroupChangeInfo extends ZIMTipsMessageChangeInfo {
  int groupDataFlag;

  String groupName;

  String groupNotice;

  String groupAvatarUrl;

  ZIMGroupMuteInfo? groupMutedInfo;

  ZIMTipsMessageGroupChangeInfo({
    required ZIMTipsMessageChangeInfoType type,
    this.groupDataFlag = 0,
    this.groupName = '',
    this.groupNotice = '',
    this.groupAvatarUrl = '',
    this.groupMutedInfo,
  }) : super(type: type);

  ZIMTipsMessageGroupChangeInfo.fromMap(Map<dynamic, dynamic> map)
      : groupDataFlag = map['groupDataFlag']!,
        groupName = map['groupName']!,
        groupNotice = map['groupNotice']!,
        groupAvatarUrl = map['groupAvatarUrl']!,
        groupMutedInfo = (map['groupMutedInfo'] != null)
            ? ZIMGroupMuteInfo.fromMap(map['groupMutedInfo'])
            : null,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'groupDataFlag': groupDataFlag,
      'groupName': groupName,
      'groupNotice': groupNotice,
      'groupAvatarUrl': groupAvatarUrl,
      'groupMutedInfo': groupMutedInfo?.toMap(),
    });
    return baseMap;
  }
}

/// todo
///
/// todo
class ZIMTipsMessageGroupMemberChangeInfo extends ZIMTipsMessageChangeInfo {
  int memberRole;

  int muteExpiredTime;

  /// Detailed description: tips message generated when the original group owner leaves the group and causes a change in the group owner. This field is true and indicates a newly created group owner.
  ZIMGroupMemberSimpleInfo? groupNewOwner;

  ZIMTipsMessageGroupMemberChangeInfo({
    required ZIMTipsMessageChangeInfoType type,
    this.memberRole = 0,
    this.muteExpiredTime = 0,
    this.groupNewOwner,
  }) : super(type: type);

  ZIMTipsMessageGroupMemberChangeInfo.fromMap(Map<dynamic, dynamic> map)
      : memberRole = map['memberRole']!,
        muteExpiredTime = map['muteExpiredTime']!,
        groupNewOwner = (map['groupNewOwner'] != null)
            ? ZIMGroupMemberSimpleInfo.fromMap(map['groupNewOwner'])
            : null,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'memberRole': memberRole,
      'muteExpiredTime': muteExpiredTime,
      'groupNewOwner': groupNewOwner?.toMap(),
    });
    return baseMap;
  }
}

/// todo
///
/// todo
class ZIMTipsMessagePinStatusChangeInfo extends ZIMTipsMessageChangeInfo {
  bool isPinned;

  ZIMTipsMessagePinStatusChangeInfo({
    required ZIMTipsMessageChangeInfoType type,
    this.isPinned = false,
  }) : super(type: type);

  ZIMTipsMessagePinStatusChangeInfo.fromMap(Map<dynamic, dynamic> map)
      : isPinned = map['isPinned']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'isPinned': isPinned});
    return baseMap;
  }
}

/// Message pin status change.
class ZIMMessagePinStatusChangeInfo {
  /// Message pin status
  ZIMMessagePinStatus pinStatus;

  /// The message object whose pin status changed.
  ZIMMessage message;

  ZIMMessagePinStatusChangeInfo({
    this.pinStatus = ZIMMessagePinStatus.notPinned,
    ZIMMessage? message,
  }) : message = message ?? ZIMMessage();

  ZIMMessagePinStatusChangeInfo.fromMap(Map<dynamic, dynamic> map)
      : pinStatus = ZIMMessagePinStatusExtension.mapValue[map['pinStatus']] ??
            ZIMMessagePinStatus.notPinned,
        message = ZIMDataUtils.parseZIMMessageFromMap(map['message']);

  Map<String, dynamic> toMap() {
    return {'pinStatus': pinStatus.value, 'message': message.toMap()};
  }
}

/// todo
///
/// todo
class ZIMMessageImportConfig {
  ZIMMessageImportConfig();

  ZIMMessageImportConfig.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// todo
///
/// todo
class ZIMMessageExportConfig {
  ZIMMessageExportConfig();

  ZIMMessageExportConfig.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// todo
///
/// todo
class ZIMFileCacheClearConfig {
  /// todo
  int endTime;

  ZIMFileCacheClearConfig({this.endTime = 0});

  ZIMFileCacheClearConfig.fromMap(Map<dynamic, dynamic> map)
      : endTime = map['endTime']!;

  Map<String, dynamic> toMap() {
    return {'endTime': endTime};
  }
}

/// todo
///
/// todo
class ZIMFileCacheQueryConfig {
  /// todo
  int endTime;

  ZIMFileCacheQueryConfig({this.endTime = 0});

  ZIMFileCacheQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : endTime = map['endTime']!;

  Map<String, dynamic> toMap() {
    return {'endTime': endTime};
  }
}

/// todo
///
/// todo
class ZIMFileCacheInfo {
  /// todo
  int totalFileSize;

  ZIMFileCacheInfo({required this.totalFileSize});

  ZIMFileCacheInfo.fromMap(Map<dynamic, dynamic> map)
      : totalFileSize = map['totalFileSize']!;

  Map<String, dynamic> toMap() {
    return {'totalFileSize': totalFileSize};
  }
}

/// todo
///
/// todo
class ZIMConversation {
  String conversationID;

  ZIMConversationType type;

  String conversationName;

  String conversationAvatarUrl;

  /// todo
  String conversationAlias;

  ZIMConversationNotificationStatus notificationStatus;

  int unreadMessageCount;

  ZIMMessage? lastMessage;

  int orderKey;

  bool isPinned;

  /// Description: The timestamp of conversation pinned.
  int pinnedTime;

  List<ZIMMessageMentionedInfo> mentionedInfoList;

  String draft;

  List<int> marks;

  int readMessageSeq;

  ZIMConversation({
    this.conversationID = '',
    this.type = ZIMConversationType.unknown,
    this.conversationName = '',
    this.conversationAvatarUrl = '',
    this.conversationAlias = '',
    this.notificationStatus = ZIMConversationNotificationStatus.notify,
    this.unreadMessageCount = 0,
    this.lastMessage,
    this.orderKey = 0,
    this.isPinned = false,
    this.pinnedTime = 0,
    List<ZIMMessageMentionedInfo>? mentionedInfoList,
    this.draft = '',
    List<int>? marks,
    this.readMessageSeq = 0,
  })  : mentionedInfoList = mentionedInfoList ?? [],
        marks = marks ?? [];

  ZIMConversation.fromMap(Map<dynamic, dynamic> map)
      : conversationID = map['conversationID']!,
        type = ZIMConversationTypeExtension.mapValue[map['type']] ??
            ZIMConversationType.unknown,
        conversationName = map['conversationName']!,
        conversationAvatarUrl = map['conversationAvatarUrl']!,
        conversationAlias = map['conversationAlias']!,
        notificationStatus = ZIMConversationNotificationStatusExtension
                .mapValue[map['notificationStatus']] ??
            ZIMConversationNotificationStatus.notify,
        unreadMessageCount = map['unreadMessageCount']!,
        lastMessage = (map['lastMessage'] != null)
            ? ZIMDataUtils.parseZIMMessageFromMap(map['lastMessage'])
            : null,
        orderKey = map['orderKey']!,
        isPinned = map['isPinned']!,
        pinnedTime = map['pinnedTime']!,
        mentionedInfoList = ((map['mentionedInfoList']!) as List)
            .map<ZIMMessageMentionedInfo>(
              (item) => ZIMMessageMentionedInfo.fromMap(item),
            )
            .toList(),
        draft = map['draft']!,
        marks =
            ((map['marks']!) as List).map<int>((item) => item as int).toList(),
        readMessageSeq = map['readMessageSeq']!;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'type': type.value,
      'conversationName': conversationName,
      'conversationAvatarUrl': conversationAvatarUrl,
      'conversationAlias': conversationAlias,
      'notificationStatus': notificationStatus.value,
      'unreadMessageCount': unreadMessageCount,
      'lastMessage': lastMessage?.toMap(),
      'orderKey': orderKey,
      'isPinned': isPinned,
      'pinnedTime': pinnedTime,
      'mentionedInfoList':
          mentionedInfoList.map((item) => item.toMap()).toList(),
      'draft': draft,
      'marks': marks,
      'readMessageSeq': readMessageSeq,
    };
  }
}

/// Conversation base information
///
/// todo
class ZIMConversationBaseInfo {
  /// Conversation ID. For single chat, the conversation ID is the other user ID. For group chat, the conversation ID is the group ID.
  String conversationID;

  /// Conversation type
  ZIMConversationType conversationType;

  ZIMConversationBaseInfo({
    this.conversationID = '',
    this.conversationType = ZIMConversationType.unknown,
  });

  ZIMConversationBaseInfo.fromMap(Map<dynamic, dynamic> map)
      : conversationID = map['conversationID']!,
        conversationType =
            ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
                ZIMConversationType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
    };
  }
}

/// todo
///
/// todo
class ZIMGroupConversation extends ZIMConversation {
  bool isDisabled;

  int mutedExpiredTime;

  ZIMGroupConversation({this.isDisabled = false, this.mutedExpiredTime = 0});

  ZIMGroupConversation.fromMap(Map<dynamic, dynamic> map)
      : isDisabled = map['isDisabled']!,
        mutedExpiredTime = map['mutedExpiredTime']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'isDisabled': isDisabled,
      'mutedExpiredTime': mutedExpiredTime,
    });
    return baseMap;
  }
}

/// todo
///
/// todo
class ZIMConversationQueryConfig {
  ZIMConversation? nextConversation;

  int count;

  ZIMConversationQueryConfig({this.nextConversation, this.count = 0});

  ZIMConversationQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : nextConversation = (map['nextConversation'] != null)
            ? ZIMDataUtils.parseZIMConversationFromMap(map['nextConversation'])
            : null,
        count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextConversation': nextConversation?.toMap(), 'count': count};
  }
}

/// Conversation list query filter options
///
/// todo
class ZIMConversationFilterOption {
  /// Conversation type list
  List<ZIMConversationType> conversationTypes;

  /// Conversation mark list
  List<int> marks;

  /// Whether to query only unread conversations
  bool isOnlyUnreadConversation;

  /// Conversation pinned filter
  ZIMConversationPinnedFilter pinnedFilter;

  ZIMConversationFilterOption({
    List<ZIMConversationType>? conversationTypes,
    List<int>? marks,
    this.isOnlyUnreadConversation = false,
    this.pinnedFilter = ZIMConversationPinnedFilter.all,
  })  : conversationTypes = conversationTypes ?? [],
        marks = marks ?? [];

  ZIMConversationFilterOption.fromMap(Map<dynamic, dynamic> map)
      : conversationTypes = ((map['conversationTypes']!) as List)
            .map<ZIMConversationType>(
              (item) =>
                  ZIMConversationTypeExtension.mapValue[item] ??
                  ZIMConversationType.unknown,
            )
            .toList(),
        marks =
            ((map['marks']!) as List).map<int>((item) => item as int).toList(),
        isOnlyUnreadConversation = map['isOnlyUnreadConversation']!,
        pinnedFilter = ZIMConversationPinnedFilterExtension
                .mapValue[map['pinnedFilter']] ??
            ZIMConversationPinnedFilter.all;

  Map<String, dynamic> toMap() {
    return {
      'conversationTypes': conversationTypes.map((item) => item.value).toList(),
      'marks': marks,
      'isOnlyUnreadConversation': isOnlyUnreadConversation,
      'pinnedFilter': pinnedFilter.value,
    };
  }
}

/// Conversation total unread message count query configuration
///
/// todo
class ZIMConversationTotalUnreadMessageCountQueryConfig {
  /// Conversation type list
  List<ZIMConversationType> conversationTypes;

  /// Conversation mark list
  List<int> marks;

  ZIMConversationTotalUnreadMessageCountQueryConfig({
    List<ZIMConversationType>? conversationTypes,
    List<int>? marks,
  })  : conversationTypes = conversationTypes ?? [],
        marks = marks ?? [];

  ZIMConversationTotalUnreadMessageCountQueryConfig.fromMap(
    Map<dynamic, dynamic> map,
  )   : conversationTypes = ((map['conversationTypes']!) as List)
            .map<ZIMConversationType>(
              (item) =>
                  ZIMConversationTypeExtension.mapValue[item] ??
                  ZIMConversationType.unknown,
            )
            .toList(),
        marks =
            ((map['marks']!) as List).map<int>((item) => item as int).toList();

  Map<String, dynamic> toMap() {
    return {
      'conversationTypes': conversationTypes.map((item) => item.value).toList(),
      'marks': marks,
    };
  }
}

/// Conversation delete configuration
///
/// todo
class ZIMConversationDeleteConfig {
  /// Whether to delete server conversations at the same time
  bool isAlsoDeleteServerConversation;

  ZIMConversationDeleteConfig({this.isAlsoDeleteServerConversation = false});

  ZIMConversationDeleteConfig.fromMap(Map<dynamic, dynamic> map)
      : isAlsoDeleteServerConversation = map['isAlsoDeleteServerConversation']!;

  Map<String, dynamic> toMap() {
    return {'isAlsoDeleteServerConversation': isAlsoDeleteServerConversation};
  }
}

/// todo
///
/// todo
class ZIMConversationsAllDeletedInfo {
  int count;

  ZIMConversationsAllDeletedInfo({required this.count});

  ZIMConversationsAllDeletedInfo.fromMap(Map<dynamic, dynamic> map)
      : count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'count': count};
  }
}

/// Conversation change information
///
/// todo
class ZIMConversationChangeInfo {
  /// Conversation change event
  ZIMConversationEvent event;

  /// Changed conversation
  ZIMConversation? conversation;

  ZIMConversationChangeInfo({required this.event, this.conversation});

  ZIMConversationChangeInfo.fromMap(Map<dynamic, dynamic> map)
      : event = ZIMConversationEventExtension.mapValue[map['event']] ??
            ZIMConversationEvent.added,
        conversation = (map['conversation'] != null)
            ? ZIMDataUtils.parseZIMConversationFromMap(map['conversation'])
            : null;

  Map<String, dynamic> toMap() {
    return {'event': event.value, 'conversation': conversation?.toMap()};
  }
}

/// Conversation search configuration
///
/// todo
class ZIMConversationSearchConfig {
  /// Conversation search mode.
  ZIMConversationSearchMode mode;

  int nextFlag;

  int totalConversationCount;

  List<String> keywords;

  int conversationMessageCount;

  List<ZIMMessageType> messageTypes;

  List<int> subMessageTypes;

  List<String> senderUserIDs;

  int startTime;

  int endTime;

  ZIMConversationSearchConfig({
    this.mode = ZIMConversationSearchMode.matchMessage,
    this.nextFlag = 0,
    this.totalConversationCount = 0,
    List<String>? keywords,
    this.conversationMessageCount = 0,
    List<ZIMMessageType>? messageTypes,
    List<int>? subMessageTypes,
    List<String>? senderUserIDs,
    this.startTime = 0,
    this.endTime = 0,
  })  : keywords = keywords ?? [],
        messageTypes = messageTypes ?? [],
        subMessageTypes = subMessageTypes ?? [],
        senderUserIDs = senderUserIDs ?? [];

  ZIMConversationSearchConfig.fromMap(Map<dynamic, dynamic> map)
      : mode = ZIMConversationSearchModeExtension.mapValue[map['mode']] ??
            ZIMConversationSearchMode.matchMessage,
        nextFlag = map['nextFlag']!,
        totalConversationCount = map['totalConversationCount']!,
        keywords = ((map['keywords']!) as List)
            .map<String>((item) => item as String)
            .toList(),
        conversationMessageCount = map['conversationMessageCount']!,
        messageTypes = ((map['messageTypes']!) as List)
            .map<ZIMMessageType>(
              (item) =>
                  ZIMMessageTypeExtension.mapValue[item] ??
                  ZIMMessageType.unknown,
            )
            .toList(),
        subMessageTypes = ((map['subMessageTypes']!) as List)
            .map<int>((item) => item as int)
            .toList(),
        senderUserIDs = ((map['senderUserIDs']!) as List)
            .map<String>((item) => item as String)
            .toList(),
        startTime = map['startTime']!,
        endTime = map['endTime']!;

  Map<String, dynamic> toMap() {
    return {
      'mode': mode.value,
      'nextFlag': nextFlag,
      'totalConversationCount': totalConversationCount,
      'keywords': keywords,
      'conversationMessageCount': conversationMessageCount,
      'messageTypes': messageTypes.map((item) => item.value).toList(),
      'subMessageTypes': subMessageTypes,
      'senderUserIDs': senderUserIDs,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

/// Conversation search result
///
/// todo
class ZIMConversationSearchInfo {
  String conversationID;

  ZIMConversationType conversationType;

  /// Conversation object.
  ZIMConversation conversation;

  int totalMessageCount;

  List<ZIMMessage> messageList;

  ZIMConversationSearchInfo({
    required this.conversationID,
    required this.conversationType,
    ZIMConversation? conversation,
    required this.totalMessageCount,
    required this.messageList,
  }) : conversation = conversation ?? ZIMConversation();

  ZIMConversationSearchInfo.fromMap(Map<dynamic, dynamic> map)
      : conversationID = map['conversationID']!,
        conversationType =
            ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
                ZIMConversationType.unknown,
        conversation = ZIMDataUtils.parseZIMConversationFromMap(
          map['conversation'],
        ),
        totalMessageCount = map['totalMessageCount']!,
        messageList = ((map['messageList']!) as List)
            .map<ZIMMessage>(
                (item) => ZIMDataUtils.parseZIMMessageFromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'conversation': conversation.toMap(),
      'totalMessageCount': totalMessageCount,
      'messageList': messageList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// todo
class ZIMRoomInfo {
  String roomID;

  String roomName;

  ZIMRoomInfo({this.roomID = '', this.roomName = ''});

  ZIMRoomInfo.fromMap(Map<dynamic, dynamic> map)
      : roomID = map['roomID']!,
        roomName = map['roomName']!;

  Map<String, dynamic> toMap() {
    return {'roomID': roomID, 'roomName': roomName};
  }
}

/// todo
///
/// todo
class ZIMRoomFullInfo {
  /// Room base information
  ZIMRoomInfo baseInfo;

  ZIMRoomFullInfo({required this.baseInfo});

  ZIMRoomFullInfo.fromMap(Map<dynamic, dynamic> map)
      : baseInfo = ZIMRoomInfo.fromMap(map['baseInfo']);

  Map<String, dynamic> toMap() {
    return {'baseInfo': baseInfo.toMap()};
  }
}

/// Room user information.
///
/// Detail description: A class describing room user.
class ZIMRoomMemberInfo extends ZIMUserInfo {
  ZIMRoomMemberInfo({
    String userID = "",
    String userName = "",
    String userAvatarUrl = "",
  }) : super(userID: userID, userName: userName, userAvatarUrl: userAvatarUrl);

  ZIMRoomMemberInfo.fromMap(Map<dynamic, dynamic> map) : super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({'classType': 'ZIMRoomMemberInfo'});
    return baseMap;
  }
}

/// Room member query configuration
///
/// todo
class ZIMRoomMemberQueryConfig {
  String nextFlag;

  int count;

  ZIMRoomMemberQueryConfig({this.nextFlag = '', this.count = 0});

  ZIMRoomMemberQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : nextFlag = map['nextFlag']!,
        count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// Room advanced configuration
///
/// todo
class ZIMRoomAdvancedConfig {
  Map<String, String> roomAttributes;

  int roomDestroyDelayTime;

  ZIMRoomAdvancedConfig({
    Map<String, String>? roomAttributes,
    this.roomDestroyDelayTime = 0,
  }) : roomAttributes = roomAttributes ?? {};

  ZIMRoomAdvancedConfig.fromMap(Map<dynamic, dynamic> map)
      : roomAttributes = ((map['roomAttributes']!) as Map).map<String, String>(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ),
        roomDestroyDelayTime = map['roomDestroyDelayTime']!;

  Map<String, dynamic> toMap() {
    return {
      'roomAttributes': roomAttributes,
      'roomDestroyDelayTime': roomDestroyDelayTime,
    };
  }
}

/// Room attribute setting configuration
///
/// todo
class ZIMRoomAttributesSetConfig {
  bool isForce;

  bool isDeleteAfterOwnerLeft;

  bool isUpdateOwner;

  ZIMRoomAttributesSetConfig({
    this.isForce = false,
    this.isDeleteAfterOwnerLeft = false,
    this.isUpdateOwner = false,
  });

  ZIMRoomAttributesSetConfig.fromMap(Map<dynamic, dynamic> map)
      : isForce = map['isForce']!,
        isDeleteAfterOwnerLeft = map['isDeleteAfterOwnerLeft']!,
        isUpdateOwner = map['isUpdateOwner']!;

  Map<String, dynamic> toMap() {
    return {
      'isForce': isForce,
      'isDeleteAfterOwnerLeft': isDeleteAfterOwnerLeft,
      'isUpdateOwner': isUpdateOwner,
    };
  }
}

/// Room attribute batch operation configuration
///
/// todo
class ZIMRoomAttributesBatchOperationConfig {
  bool isForce;

  bool isDeleteAfterOwnerLeft;

  bool isUpdateOwner;

  ZIMRoomAttributesBatchOperationConfig({
    this.isForce = false,
    this.isDeleteAfterOwnerLeft = false,
    this.isUpdateOwner = false,
  });

  ZIMRoomAttributesBatchOperationConfig.fromMap(Map<dynamic, dynamic> map)
      : isForce = map['isForce']!,
        isDeleteAfterOwnerLeft = map['isDeleteAfterOwnerLeft']!,
        isUpdateOwner = map['isUpdateOwner']!;

  Map<String, dynamic> toMap() {
    return {
      'isForce': isForce,
      'isDeleteAfterOwnerLeft': isDeleteAfterOwnerLeft,
      'isUpdateOwner': isUpdateOwner,
    };
  }
}

/// Room attribute delete configuration
///
/// todo
class ZIMRoomAttributesDeleteConfig {
  bool isForce;

  ZIMRoomAttributesDeleteConfig({this.isForce = false});

  ZIMRoomAttributesDeleteConfig.fromMap(Map<dynamic, dynamic> map)
      : isForce = map['isForce']!;

  Map<String, dynamic> toMap() {
    return {'isForce': isForce};
  }
}

/// Room attribute update information
///
/// todo
class ZIMRoomAttributesUpdateInfo {
  ZIMRoomAttributesUpdateAction action;

  Map<String, String> roomAttributes;

  ZIMRoomAttributesUpdateInfo({
    required this.action,
    required this.roomAttributes,
  });

  ZIMRoomAttributesUpdateInfo.fromMap(Map<dynamic, dynamic> map)
      : action =
            ZIMRoomAttributesUpdateActionExtension.mapValue[map['action']] ??
                ZIMRoomAttributesUpdateAction.set,
        roomAttributes = ((map['roomAttributes']!) as Map).map<String, String>(
          (k, v) => MapEntry(k.toString(), v.toString()),
        );

  Map<String, dynamic> toMap() {
    return {'action': action.value, 'roomAttributes': roomAttributes};
  }
}

/// todo
///
/// todo
class ZIMRoomMemberAttributesInfo {
  String userID;

  Map<String, String> attributes;

  ZIMRoomMemberAttributesInfo({
    this.userID = '',
    Map<String, String>? attributes,
  }) : attributes = attributes ?? {};

  ZIMRoomMemberAttributesInfo.fromMap(Map<dynamic, dynamic> map)
      : userID = map['userID']!,
        attributes = ((map['attributes']!) as Map).map<String, String>(
          (k, v) => MapEntry(k.toString(), v.toString()),
        );

  Map<String, dynamic> toMap() {
    return {'userID': userID, 'attributes': attributes};
  }
}

/// todo
///
/// todo
class ZIMRoomMemberAttributesOperatedInfo {
  ZIMRoomMemberAttributesInfo attributesInfo;

  List<String> errorKeys;

  ZIMRoomMemberAttributesOperatedInfo({
    ZIMRoomMemberAttributesInfo? attributesInfo,
    List<String>? errorKeys,
  })  : attributesInfo = attributesInfo ?? ZIMRoomMemberAttributesInfo(),
        errorKeys = errorKeys ?? [];

  ZIMRoomMemberAttributesOperatedInfo.fromMap(Map<dynamic, dynamic> map)
      : attributesInfo = ZIMRoomMemberAttributesInfo.fromMap(
          map['attributesInfo'],
        ),
        errorKeys = ((map['errorKeys']!) as List)
            .map<String>((item) => item as String)
            .toList();

  Map<String, dynamic> toMap() {
    return {'attributesInfo': attributesInfo.toMap(), 'errorKeys': errorKeys};
  }
}

/// todo
///
/// todo
class ZIMRoomMemberAttributesUpdateInfo {
  ZIMRoomMemberAttributesInfo attributesInfo;

  ZIMRoomMemberAttributesUpdateInfo({
    ZIMRoomMemberAttributesInfo? attributesInfo,
  }) : attributesInfo = attributesInfo ?? ZIMRoomMemberAttributesInfo();

  ZIMRoomMemberAttributesUpdateInfo.fromMap(Map<dynamic, dynamic> map)
      : attributesInfo = ZIMRoomMemberAttributesInfo.fromMap(
          map['attributesInfo'],
        );

  Map<String, dynamic> toMap() {
    return {'attributesInfo': attributesInfo.toMap()};
  }
}

/// todo
///
/// todo
class ZIMRoomMemberAttributesSetConfig {
  bool isDeleteAfterOwnerLeft;

  ZIMRoomMemberAttributesSetConfig({this.isDeleteAfterOwnerLeft = true});

  ZIMRoomMemberAttributesSetConfig.fromMap(Map<dynamic, dynamic> map)
      : isDeleteAfterOwnerLeft = map['isDeleteAfterOwnerLeft']!;

  Map<String, dynamic> toMap() {
    return {'isDeleteAfterOwnerLeft': isDeleteAfterOwnerLeft};
  }
}

/// Room member attribute query configuration
///
/// todo
class ZIMRoomMemberAttributesQueryConfig {
  String nextFlag;

  int count;

  ZIMRoomMemberAttributesQueryConfig({this.nextFlag = '', this.count = 0});

  ZIMRoomMemberAttributesQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : nextFlag = map['nextFlag']!,
        count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// Room operation information
///
/// todo
class ZIMRoomOperatedInfo {
  String userID;

  ZIMRoomOperatedInfo({required this.userID});

  ZIMRoomOperatedInfo.fromMap(Map<dynamic, dynamic> map)
      : userID = map['userID']!;

  Map<String, dynamic> toMap() {
    return {'userID': userID};
  }
}

/// todo
///
/// todo
class ZIMGroupInfo {
  String groupID;

  String groupName;

  String groupAvatarUrl;

  ZIMGroupInfo({
    this.groupID = '',
    this.groupName = '',
    this.groupAvatarUrl = '',
  });

  ZIMGroupInfo.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        groupName = map['groupName']!,
        groupAvatarUrl = map['groupAvatarUrl']!;

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'groupName': groupName,
      'groupAvatarUrl': groupAvatarUrl,
    };
  }
}

/// Group mute information
///
/// todo
class ZIMGroupMuteInfo {
  ZIMGroupMuteMode mode;

  int expiredTime;

  List<int> roles;

  ZIMGroupMuteInfo({
    this.mode = ZIMGroupMuteMode.none,
    this.expiredTime = 0,
    List<int>? roles,
  }) : roles = roles ?? [];

  ZIMGroupMuteInfo.fromMap(Map<dynamic, dynamic> map)
      : mode = ZIMGroupMuteModeExtension.mapValue[map['mode']] ??
            ZIMGroupMuteMode.none,
        expiredTime = map['expiredTime']!,
        roles =
            ((map['roles']!) as List).map<int>((item) => item as int).toList();

  Map<String, dynamic> toMap() {
    return {'mode': mode.value, 'expiredTime': expiredTime, 'roles': roles};
  }
}

/// Group verification information
///
/// todo
class ZIMGroupVerifyInfo {
  ZIMGroupJoinMode joinMode;

  ZIMGroupInviteMode inviteMode;

  ZIMGroupBeInviteMode beInviteMode;

  ZIMGroupVerifyInfo({
    this.joinMode = ZIMGroupJoinMode.any,
    this.inviteMode = ZIMGroupInviteMode.any,
    this.beInviteMode = ZIMGroupBeInviteMode.none,
  });

  ZIMGroupVerifyInfo.fromMap(Map<dynamic, dynamic> map)
      : joinMode = ZIMGroupJoinModeExtension.mapValue[map['joinMode']] ??
            ZIMGroupJoinMode.any,
        inviteMode = ZIMGroupInviteModeExtension.mapValue[map['inviteMode']] ??
            ZIMGroupInviteMode.any,
        beInviteMode =
            ZIMGroupBeInviteModeExtension.mapValue[map['beInviteMode']] ??
                ZIMGroupBeInviteMode.none;

  Map<String, dynamic> toMap() {
    return {
      'joinMode': joinMode.value,
      'inviteMode': inviteMode.value,
      'beInviteMode': beInviteMode.value,
    };
  }
}

/// Group full information
///
/// todo
class ZIMGroupFullInfo {
  ZIMGroupInfo baseInfo;

  String groupNotice;

  Map<String, String> groupAttributes;

  String groupAlias;

  ZIMGroupMessageNotificationStatus notificationStatus;

  ZIMGroupMuteInfo mutedInfo;

  int createTime;

  int maxMemberCount;

  ZIMGroupVerifyInfo verifyInfo;

  ZIMGroupFullInfo({
    required this.baseInfo,
    required this.groupNotice,
    required this.groupAttributes,
    required this.groupAlias,
    required this.notificationStatus,
    required this.mutedInfo,
    required this.createTime,
    required this.maxMemberCount,
    required this.verifyInfo,
  });

  ZIMGroupFullInfo.fromMap(Map<dynamic, dynamic> map)
      : baseInfo = ZIMGroupInfo.fromMap(map['baseInfo']),
        groupNotice = map['groupNotice']!,
        groupAttributes =
            ((map['groupAttributes']!) as Map).map<String, String>(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ),
        groupAlias = map['groupAlias']!,
        notificationStatus = ZIMGroupMessageNotificationStatusExtension
                .mapValue[map['notificationStatus']] ??
            ZIMGroupMessageNotificationStatus.notify,
        mutedInfo = ZIMGroupMuteInfo.fromMap(map['mutedInfo']),
        createTime = map['createTime']!,
        maxMemberCount = map['maxMemberCount']!,
        verifyInfo = ZIMGroupVerifyInfo.fromMap(map['verifyInfo']);

  Map<String, dynamic> toMap() {
    return {
      'baseInfo': baseInfo.toMap(),
      'groupNotice': groupNotice,
      'groupAttributes': groupAttributes,
      'groupAlias': groupAlias,
      'notificationStatus': notificationStatus.value,
      'mutedInfo': mutedInfo.toMap(),
      'createTime': createTime,
      'maxMemberCount': maxMemberCount,
      'verifyInfo': verifyInfo.toMap(),
    };
  }
}

/// todo
///
/// todo
class ZIMGroup {
  ZIMGroupInfo baseInfo;

  String groupAlias;

  ZIMGroupMessageNotificationStatus notificationStatus;

  ZIMGroup({
    required this.baseInfo,
    required this.groupAlias,
    required this.notificationStatus,
  });

  ZIMGroup.fromMap(Map<dynamic, dynamic> map)
      : baseInfo = ZIMGroupInfo.fromMap(map['baseInfo']),
        groupAlias = map['groupAlias']!,
        notificationStatus = ZIMGroupMessageNotificationStatusExtension
                .mapValue[map['notificationStatus']] ??
            ZIMGroupMessageNotificationStatus.notify;

  Map<String, dynamic> toMap() {
    return {
      'baseInfo': baseInfo.toMap(),
      'groupAlias': groupAlias,
      'notificationStatus': notificationStatus.value,
    };
  }
}

/// todo
///
/// todo
class ZIMGroupMemberSimpleInfo extends ZIMUserInfo {
  String memberNickname;

  int memberRole;

  ZIMGroupMemberSimpleInfo({
    String userID = "",
    String userName = "",
    String userAvatarUrl = "",
    this.memberNickname = '',
    this.memberRole = 0,
  }) : super(userID: userID, userName: userName, userAvatarUrl: userAvatarUrl);

  ZIMGroupMemberSimpleInfo.fromMap(Map<dynamic, dynamic> map)
      : memberNickname = map['memberNickname']!,
        memberRole = map['memberRole']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'memberNickname': memberNickname,
      'memberRole': memberRole,
      'classType': 'ZIMGroupMemberSimpleInfo',
    });
    return baseMap;
  }
}

/// Group entry information
///
/// todo
class ZIMGroupEnterInfo {
  int enterTime;

  ZIMGroupEnterType enterType;

  ZIMGroupMemberSimpleInfo? operatedUser;

  ZIMGroupEnterInfo({
    this.enterTime = 0,
    this.enterType = ZIMGroupEnterType.unknown,
    this.operatedUser,
  });

  ZIMGroupEnterInfo.fromMap(Map<dynamic, dynamic> map)
      : enterTime = map['enterTime']!,
        enterType = ZIMGroupEnterTypeExtension.mapValue[map['enterType']] ??
            ZIMGroupEnterType.unknown,
        operatedUser = (map['operatedUser'] != null)
            ? ZIMGroupMemberSimpleInfo.fromMap(map['operatedUser'])
            : null;

  Map<String, dynamic> toMap() {
    return {
      'enterTime': enterTime,
      'enterType': enterType.value,
      'operatedUser': operatedUser?.toMap(),
    };
  }
}

/// todo
///
/// todo
class ZIMGroupMemberInfo extends ZIMUserInfo {
  String memberNickname;

  int memberRole;

  String memberAvatarUrl;

  int muteExpiredTime;

  /// todo
  ZIMGroupEnterInfo? groupEnterInfo;

  ZIMGroupMemberInfo({
    String userID = "",
    String userName = "",
    String userAvatarUrl = "",
    this.memberNickname = '',
    this.memberRole = 0,
    this.memberAvatarUrl = '',
    this.muteExpiredTime = 0,
    this.groupEnterInfo,
  }) : super(userID: userID, userName: userName, userAvatarUrl: userAvatarUrl);

  ZIMGroupMemberInfo.fromMap(Map<dynamic, dynamic> map)
      : memberNickname = map['memberNickname']!,
        memberRole = map['memberRole']!,
        memberAvatarUrl = map['memberAvatarUrl']!,
        muteExpiredTime = map['muteExpiredTime']!,
        groupEnterInfo = (map['groupEnterInfo'] != null)
            ? ZIMGroupEnterInfo.fromMap(map['groupEnterInfo'])
            : null,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'memberNickname': memberNickname,
      'memberRole': memberRole,
      'memberAvatarUrl': memberAvatarUrl,
      'muteExpiredTime': muteExpiredTime,
      'groupEnterInfo': groupEnterInfo?.toMap(),
      'classType': 'ZIMGroupMemberInfo',
    });
    return baseMap;
  }
}

/// todo
///
/// todo
class ZIMGroupOperatedInfo {
  @Deprecated('todo')
  ZIMGroupMemberInfo operatedUserInfo;

  String userID;

  String userName;

  String memberNickname;

  int memberRole;

  ZIMGroupOperatedInfo({
    required this.operatedUserInfo,
    required this.userID,
    required this.userName,
    required this.memberNickname,
    required this.memberRole,
  });

  ZIMGroupOperatedInfo.fromMap(Map<dynamic, dynamic> map)
      : operatedUserInfo = ZIMGroupMemberInfo.fromMap(map['operatedUserInfo']),
        userID = map['userID']!,
        userName = map['userName']!,
        memberNickname = map['memberNickname']!,
        memberRole = map['memberRole']!;

  Map<String, dynamic> toMap() {
    return {
      'operatedUserInfo': operatedUserInfo.toMap(),
      'userID': userID,
      'userName': userName,
      'memberNickname': memberNickname,
      'memberRole': memberRole,
    };
  }
}

/// todo
///
/// todo
class ZIMGroupMemberQueryConfig {
  int nextFlag;

  int count;

  ZIMGroupMemberQueryConfig({this.nextFlag = 0, this.count = 0});

  ZIMGroupMemberQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : nextFlag = map['nextFlag']!,
        count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// todo
///
/// todo
class ZIMGroupAdvancedConfig {
  String groupNotice;

  Map<String, String>? groupAttributes;

  /// todo
  int maxMemberCount;

  /// todo
  ZIMGroupJoinMode joinMode;

  /// todo
  ZIMGroupInviteMode inviteMode;

  /// todo
  ZIMGroupBeInviteMode beInviteMode;

  ZIMGroupAdvancedConfig({
    this.groupNotice = '',
    this.groupAttributes,
    this.maxMemberCount = 0,
    this.joinMode = ZIMGroupJoinMode.any,
    this.inviteMode = ZIMGroupInviteMode.any,
    this.beInviteMode = ZIMGroupBeInviteMode.none,
  });

  ZIMGroupAdvancedConfig.fromMap(Map<dynamic, dynamic> map)
      : groupNotice = map['groupNotice']!,
        groupAttributes = (map['groupAttributes'] != null)
            ? ((map['groupAttributes']) as Map).map<String, String>(
                (k, v) => MapEntry(k.toString(), v.toString()),
              )
            : null,
        maxMemberCount = map['maxMemberCount']!,
        joinMode = ZIMGroupJoinModeExtension.mapValue[map['joinMode']] ??
            ZIMGroupJoinMode.any,
        inviteMode = ZIMGroupInviteModeExtension.mapValue[map['inviteMode']] ??
            ZIMGroupInviteMode.any,
        beInviteMode =
            ZIMGroupBeInviteModeExtension.mapValue[map['beInviteMode']] ??
                ZIMGroupBeInviteMode.none;

  Map<String, dynamic> toMap() {
    return {
      'groupNotice': groupNotice,
      'groupAttributes': groupAttributes,
      'maxMemberCount': maxMemberCount,
      'joinMode': joinMode.value,
      'inviteMode': inviteMode.value,
      'beInviteMode': beInviteMode.value,
    };
  }
}

/// todo
///
/// todo
class ZIMGroupAttributesUpdateInfo {
  ZIMGroupAttributesUpdateAction action;

  Map<String, String>? groupAttributes;

  ZIMGroupAttributesUpdateInfo({required this.action, this.groupAttributes});

  ZIMGroupAttributesUpdateInfo.fromMap(Map<dynamic, dynamic> map)
      : action =
            ZIMGroupAttributesUpdateActionExtension.mapValue[map['action']] ??
                ZIMGroupAttributesUpdateAction.set,
        groupAttributes = (map['groupAttributes'] != null)
            ? ((map['groupAttributes']) as Map).map<String, String>(
                (k, v) => MapEntry(k.toString(), v.toString()),
              )
            : null;

  Map<String, dynamic> toMap() {
    return {'action': action.value, 'groupAttributes': groupAttributes};
  }
}

/// todo
///
/// todo
class ZIMGroupMessageReceiptMemberQueryConfig {
  int nextFlag;

  int count;

  ZIMGroupMessageReceiptMemberQueryConfig({this.nextFlag = 0, this.count = 0});

  ZIMGroupMessageReceiptMemberQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : nextFlag = map['nextFlag']!,
        count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// todo
///
/// todo
class ZIMGroupSearchConfig {
  int nextFlag;

  int count;

  List<String> keywords;

  bool isAlsoMatchGroupMemberUserName;

  bool isAlsoMatchGroupMemberNickname;

  ZIMGroupSearchConfig({
    this.nextFlag = 0,
    this.count = 0,
    List<String>? keywords,
    this.isAlsoMatchGroupMemberUserName = false,
    this.isAlsoMatchGroupMemberNickname = false,
  }) : keywords = keywords ?? [];

  ZIMGroupSearchConfig.fromMap(Map<dynamic, dynamic> map)
      : nextFlag = map['nextFlag']!,
        count = map['count']!,
        keywords = ((map['keywords']!) as List)
            .map<String>((item) => item as String)
            .toList(),
        isAlsoMatchGroupMemberUserName = map['isAlsoMatchGroupMemberUserName']!,
        isAlsoMatchGroupMemberNickname = map['isAlsoMatchGroupMemberNickname']!;

  Map<String, dynamic> toMap() {
    return {
      'nextFlag': nextFlag,
      'count': count,
      'keywords': keywords,
      'isAlsoMatchGroupMemberUserName': isAlsoMatchGroupMemberUserName,
      'isAlsoMatchGroupMemberNickname': isAlsoMatchGroupMemberNickname,
    };
  }
}

/// todo
///
/// todo
class ZIMGroupSearchInfo {
  ZIMGroupInfo groupInfo;

  List<ZIMGroupMemberInfo> userList;

  ZIMGroupSearchInfo({required this.groupInfo, required this.userList});

  ZIMGroupSearchInfo.fromMap(Map<dynamic, dynamic> map)
      : groupInfo = ZIMGroupInfo.fromMap(map['groupInfo']),
        userList = ((map['userList']!) as List)
            .map<ZIMGroupMemberInfo>((item) => ZIMGroupMemberInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'groupInfo': groupInfo.toMap(),
      'userList': userList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// todo
class ZIMGroupMemberSearchConfig {
  int nextFlag;

  int count;

  List<String> keywords;

  bool isAlsoMatchGroupMemberNickname;

  ZIMGroupMemberSearchConfig({
    this.nextFlag = 0,
    this.count = 0,
    List<String>? keywords,
    this.isAlsoMatchGroupMemberNickname = false,
  }) : keywords = keywords ?? [];

  ZIMGroupMemberSearchConfig.fromMap(Map<dynamic, dynamic> map)
      : nextFlag = map['nextFlag']!,
        count = map['count']!,
        keywords = ((map['keywords']!) as List)
            .map<String>((item) => item as String)
            .toList(),
        isAlsoMatchGroupMemberNickname = map['isAlsoMatchGroupMemberNickname']!;

  Map<String, dynamic> toMap() {
    return {
      'nextFlag': nextFlag,
      'count': count,
      'keywords': keywords,
      'isAlsoMatchGroupMemberNickname': isAlsoMatchGroupMemberNickname,
    };
  }
}

/// todo
///
/// todo
class ZIMGroupMuteConfig {
  ZIMGroupMuteMode mode;

  int duration;

  List<int> roles;

  ZIMGroupMuteConfig({
    this.mode = ZIMGroupMuteMode.none,
    this.duration = 0,
    List<int>? roles,
  }) : roles = roles ?? [];

  ZIMGroupMuteConfig.fromMap(Map<dynamic, dynamic> map)
      : mode = ZIMGroupMuteModeExtension.mapValue[map['mode']] ??
            ZIMGroupMuteMode.none,
        duration = map['duration']!,
        roles =
            ((map['roles']!) as List).map<int>((item) => item as int).toList();

  Map<String, dynamic> toMap() {
    return {'mode': mode.value, 'duration': duration, 'roles': roles};
  }
}

/// todo
///
/// todo
class ZIMGroupMemberMuteConfig {
  int duration;

  ZIMGroupMemberMuteConfig({this.duration = 0});

  ZIMGroupMemberMuteConfig.fromMap(Map<dynamic, dynamic> map)
      : duration = map['duration']!;

  Map<String, dynamic> toMap() {
    return {'duration': duration};
  }
}

/// todo
///
/// todo
class ZIMGroupMemberMutedListQueryConfig {
  int nextFlag;

  int count;

  ZIMGroupMemberMutedListQueryConfig({this.nextFlag = 0, this.count = 0});

  ZIMGroupMemberMutedListQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : nextFlag = map['nextFlag']!,
        count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// todo
///
/// todo
class ZIMGroupApplicationInfo {
  ZIMGroupApplicationType type;

  ZIMGroupApplicationState state;

  ZIMGroupInfo groupInfo;

  ZIMUserInfo applyUser;

  int createTime;

  int updateTime;

  String wording;

  ZIMGroupMemberSimpleInfo? operatedUser;

  ZIMGroupApplicationInfo({
    required this.type,
    required this.state,
    required this.groupInfo,
    required this.applyUser,
    required this.createTime,
    required this.updateTime,
    required this.wording,
    this.operatedUser,
  });

  ZIMGroupApplicationInfo.fromMap(Map<dynamic, dynamic> map)
      : type = ZIMGroupApplicationTypeExtension.mapValue[map['type']] ??
            ZIMGroupApplicationType.unknown,
        state = ZIMGroupApplicationStateExtension.mapValue[map['state']] ??
            ZIMGroupApplicationState.unknown,
        groupInfo = ZIMGroupInfo.fromMap(map['groupInfo']),
        applyUser = ZIMDataUtils.parseZIMUserInfoFromMap(map['applyUser']),
        createTime = map['createTime']!,
        updateTime = map['updateTime']!,
        wording = map['wording']!,
        operatedUser = (map['operatedUser'] != null)
            ? ZIMGroupMemberSimpleInfo.fromMap(map['operatedUser'])
            : null;

  Map<String, dynamic> toMap() {
    return {
      'type': type.value,
      'state': state.value,
      'groupInfo': groupInfo.toMap(),
      'applyUser': applyUser.toMap(),
      'createTime': createTime,
      'updateTime': updateTime,
      'wording': wording,
      'operatedUser': operatedUser?.toMap(),
    };
  }
}

/// todo
///
/// todo
class ZIMGroupJoinApplicationSendConfig {
  String wording;

  ZIMPushConfig? pushConfig;

  ZIMGroupJoinApplicationSendConfig({this.wording = '', this.pushConfig});

  ZIMGroupJoinApplicationSendConfig.fromMap(Map<dynamic, dynamic> map)
      : wording = map['wording']!,
        pushConfig = (map['pushConfig'] != null)
            ? ZIMPushConfig.fromMap(map['pushConfig'])
            : null;

  Map<String, dynamic> toMap() {
    return {'wording': wording, 'pushConfig': pushConfig?.toMap()};
  }
}

/// todo
///
/// todo
class ZIMGroupJoinApplicationAcceptConfig {
  ZIMPushConfig? pushConfig;

  ZIMGroupJoinApplicationAcceptConfig({this.pushConfig});

  ZIMGroupJoinApplicationAcceptConfig.fromMap(Map<dynamic, dynamic> map)
      : pushConfig = (map['pushConfig'] != null)
            ? ZIMPushConfig.fromMap(map['pushConfig'])
            : null;

  Map<String, dynamic> toMap() {
    return {'pushConfig': pushConfig?.toMap()};
  }
}

/// todo
///
/// todo
class ZIMGroupJoinApplicationRejectConfig {
  ZIMPushConfig? pushConfig;

  ZIMGroupJoinApplicationRejectConfig({this.pushConfig});

  ZIMGroupJoinApplicationRejectConfig.fromMap(Map<dynamic, dynamic> map)
      : pushConfig = (map['pushConfig'] != null)
            ? ZIMPushConfig.fromMap(map['pushConfig'])
            : null;

  Map<String, dynamic> toMap() {
    return {'pushConfig': pushConfig?.toMap()};
  }
}

/// todo
///
/// todo
class ZIMGroupInviteApplicationSendConfig {
  String wording;

  ZIMPushConfig? pushConfig;

  ZIMGroupInviteApplicationSendConfig({this.wording = '', this.pushConfig});

  ZIMGroupInviteApplicationSendConfig.fromMap(Map<dynamic, dynamic> map)
      : wording = map['wording']!,
        pushConfig = (map['pushConfig'] != null)
            ? ZIMPushConfig.fromMap(map['pushConfig'])
            : null;

  Map<String, dynamic> toMap() {
    return {'wording': wording, 'pushConfig': pushConfig?.toMap()};
  }
}

/// todo
///
/// todo
class ZIMGroupInviteApplicationAcceptConfig {
  ZIMPushConfig? pushConfig;

  ZIMGroupInviteApplicationAcceptConfig({this.pushConfig});

  ZIMGroupInviteApplicationAcceptConfig.fromMap(Map<dynamic, dynamic> map)
      : pushConfig = (map['pushConfig'] != null)
            ? ZIMPushConfig.fromMap(map['pushConfig'])
            : null;

  Map<String, dynamic> toMap() {
    return {'pushConfig': pushConfig?.toMap()};
  }
}

/// todo
///
/// todo
class ZIMGroupInviteApplicationRejectConfig {
  ZIMPushConfig? pushConfig;

  ZIMGroupInviteApplicationRejectConfig({this.pushConfig});

  ZIMGroupInviteApplicationRejectConfig.fromMap(Map<dynamic, dynamic> map)
      : pushConfig = (map['pushConfig'] != null)
            ? ZIMPushConfig.fromMap(map['pushConfig'])
            : null;

  Map<String, dynamic> toMap() {
    return {'pushConfig': pushConfig?.toMap()};
  }
}

/// todo
///
/// todo
class ZIMGroupApplicationListQueryConfig {
  int nextFlag;

  int count;

  ZIMGroupApplicationListQueryConfig({this.nextFlag = 0, this.count = 0});

  ZIMGroupApplicationListQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : nextFlag = map['nextFlag']!,
        count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// todo
///
/// todo
class ZIMGroupListQueryConfig {
  int nextFlag;

  List<String> userIDs;

  ZIMGroupListQueryConfig({this.nextFlag = 0, List<String>? userIDs})
      : userIDs = userIDs ?? [];

  ZIMGroupListQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : nextFlag = map['nextFlag']!,
        userIDs = ((map['userIDs']!) as List)
            .map<String>((item) => item as String)
            .toList();

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'userIDs': userIDs};
  }
}

/// todo
///
/// todo
class ZIMCallUserInfo {
  String userID;

  ZIMCallUserState state;

  String extendedData;

  ZIMCallUserInfo({
    required this.userID,
    required this.state,
    required this.extendedData,
  });

  ZIMCallUserInfo.fromMap(Map<dynamic, dynamic> map)
      : userID = map['userID']!,
        state = ZIMCallUserStateExtension.mapValue[map['state']] ??
            ZIMCallUserState.unknown,
        extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'state': state.value,
      'extendedData': extendedData,
    };
  }
}

/// todo
///
/// todo
class ZIMCallInviteConfig {
  int timeout;

  ZIMCallInvitationMode mode;

  String extendedData;

  bool enableNotReceivedCheck;

  ZIMPushConfig? pushConfig;

  ZIMCallInviteConfig({
    this.timeout = 90,
    this.mode = ZIMCallInvitationMode.unknown,
    this.extendedData = '',
    this.enableNotReceivedCheck = false,
    this.pushConfig,
  });

  ZIMCallInviteConfig.fromMap(Map<dynamic, dynamic> map)
      : timeout = map['timeout']!,
        mode = ZIMCallInvitationModeExtension.mapValue[map['mode']] ??
            ZIMCallInvitationMode.unknown,
        extendedData = map['extendedData']!,
        enableNotReceivedCheck = map['enableNotReceivedCheck']!,
        pushConfig = (map['pushConfig'] != null)
            ? ZIMPushConfig.fromMap(map['pushConfig'])
            : null;

  Map<String, dynamic> toMap() {
    return {
      'timeout': timeout,
      'mode': mode.value,
      'extendedData': extendedData,
      'enableNotReceivedCheck': enableNotReceivedCheck,
      'pushConfig': pushConfig?.toMap(),
    };
  }
}

/// todo
///
/// todo
class ZIMCallingInviteConfig {
  ZIMPushConfig? pushConfig;

  ZIMCallingInviteConfig({this.pushConfig});

  ZIMCallingInviteConfig.fromMap(Map<dynamic, dynamic> map)
      : pushConfig = (map['pushConfig'] != null)
            ? ZIMPushConfig.fromMap(map['pushConfig'])
            : null;

  Map<String, dynamic> toMap() {
    return {'pushConfig': pushConfig?.toMap()};
  }
}

/// todo
///
/// todo
class ZIMCallJoinConfig {
  String extendedData;

  ZIMCallJoinConfig({this.extendedData = ''});

  ZIMCallJoinConfig.fromMap(Map<dynamic, dynamic> map)
      : extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {'extendedData': extendedData};
  }
}

/// todo
///
/// todo
class ZIMCallQuitConfig {
  String extendedData;

  ZIMPushConfig? pushConfig;

  ZIMCallQuitConfig({this.extendedData = '', this.pushConfig});

  ZIMCallQuitConfig.fromMap(Map<dynamic, dynamic> map)
      : extendedData = map['extendedData']!,
        pushConfig = (map['pushConfig'] != null)
            ? ZIMPushConfig.fromMap(map['pushConfig'])
            : null;

  Map<String, dynamic> toMap() {
    return {'extendedData': extendedData, 'pushConfig': pushConfig?.toMap()};
  }
}

/// todo
///
/// todo
class ZIMCallEndConfig {
  String extendedData;

  ZIMPushConfig? pushConfig;

  ZIMCallEndConfig({this.extendedData = '', this.pushConfig});

  ZIMCallEndConfig.fromMap(Map<dynamic, dynamic> map)
      : extendedData = map['extendedData']!,
        pushConfig = (map['pushConfig'] != null)
            ? ZIMPushConfig.fromMap(map['pushConfig'])
            : null;

  Map<String, dynamic> toMap() {
    return {'extendedData': extendedData, 'pushConfig': pushConfig?.toMap()};
  }
}

/// todo
///
/// todo
class ZIMCallCancelConfig {
  String extendedData;

  ZIMPushConfig? pushConfig;

  ZIMCallCancelConfig({this.extendedData = '', this.pushConfig});

  ZIMCallCancelConfig.fromMap(Map<dynamic, dynamic> map)
      : extendedData = map['extendedData']!,
        pushConfig = (map['pushConfig'] != null)
            ? ZIMPushConfig.fromMap(map['pushConfig'])
            : null;

  Map<String, dynamic> toMap() {
    return {'extendedData': extendedData, 'pushConfig': pushConfig?.toMap()};
  }
}

/// todo
///
/// todo
class ZIMCallAcceptConfig {
  String extendedData;

  ZIMCallAcceptConfig({this.extendedData = ''});

  ZIMCallAcceptConfig.fromMap(Map<dynamic, dynamic> map)
      : extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {'extendedData': extendedData};
  }
}

/// todo
///
/// todo
class ZIMCallRejectConfig {
  String extendedData;

  ZIMCallRejectConfig({this.extendedData = ''});

  ZIMCallRejectConfig.fromMap(Map<dynamic, dynamic> map)
      : extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {'extendedData': extendedData};
  }
}

/// todo
///
/// todo
class ZIMCallInvitationSentInfo {
  int timeout;

  List<ZIMErrorUserInfo> errorUserList;

  @Deprecated('Deprecated since ZIM 2.9.0, please use errorList instead.')
  List<ZIMCallUserInfo> errorInvitees;

  ZIMCallInvitationSentInfo({
    this.timeout = 0,
    List<ZIMErrorUserInfo>? errorUserList,
    List<ZIMCallUserInfo>? errorInvitees,
  })  : errorUserList = errorUserList ?? [],
        errorInvitees = errorInvitees ?? [];

  ZIMCallInvitationSentInfo.fromMap(Map<dynamic, dynamic> map)
      : timeout = map['timeout']!,
        errorUserList = ((map['errorUserList']!) as List)
            .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
            .toList(),
        errorInvitees = ((map['errorInvitees']!) as List)
            .map<ZIMCallUserInfo>((item) => ZIMCallUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'timeout': timeout,
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
      'errorInvitees': errorInvitees.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// todo
class ZIMCallingInvitationSentInfo {
  List<ZIMErrorUserInfo> errorUserList;

  ZIMCallingInvitationSentInfo({List<ZIMErrorUserInfo>? errorUserList})
      : errorUserList = errorUserList ?? [];

  ZIMCallingInvitationSentInfo.fromMap(Map<dynamic, dynamic> map)
      : errorUserList = ((map['errorUserList']!) as List)
            .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// todo
class ZIMCallJoinSentInfo {
  String extendedData;

  int createTime;

  int joinTime;

  List<ZIMCallUserInfo> callUserList;

  ZIMCallJoinSentInfo({
    this.extendedData = '',
    this.createTime = 0,
    this.joinTime = 0,
    List<ZIMCallUserInfo>? callUserList,
  }) : callUserList = callUserList ?? [];

  ZIMCallJoinSentInfo.fromMap(Map<dynamic, dynamic> map)
      : extendedData = map['extendedData']!,
        createTime = map['createTime']!,
        joinTime = map['joinTime']!,
        callUserList = ((map['callUserList']!) as List)
            .map<ZIMCallUserInfo>((item) => ZIMCallUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'extendedData': extendedData,
      'createTime': createTime,
      'joinTime': joinTime,
      'callUserList': callUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// todo
class ZIMCallQuitSentInfo {
  int createTime;

  int acceptTime;

  int quitTime;

  ZIMCallQuitSentInfo({
    this.createTime = 0,
    this.acceptTime = 0,
    this.quitTime = 0,
  });

  ZIMCallQuitSentInfo.fromMap(Map<dynamic, dynamic> map)
      : createTime = map['createTime']!,
        acceptTime = map['acceptTime']!,
        quitTime = map['quitTime']!;

  Map<String, dynamic> toMap() {
    return {
      'createTime': createTime,
      'acceptTime': acceptTime,
      'quitTime': quitTime,
    };
  }
}

/// todo
///
/// todo
class ZIMCallEndedSentInfo {
  int createTime;

  int acceptTime;

  int endTime;

  ZIMCallEndedSentInfo({
    this.createTime = 0,
    this.acceptTime = 0,
    this.endTime = 0,
  });

  ZIMCallEndedSentInfo.fromMap(Map<dynamic, dynamic> map)
      : createTime = map['createTime']!,
        acceptTime = map['acceptTime']!,
        endTime = map['endTime']!;

  Map<String, dynamic> toMap() {
    return {
      'createTime': createTime,
      'acceptTime': acceptTime,
      'endTime': endTime,
    };
  }
}

/// todo
///
/// todo
class ZIMCallInvitationReceivedInfo {
  ZIMCallInvitationMode mode;

  int timeout;

  String caller;

  String inviter;

  int createTime;

  List<ZIMCallUserInfo> callUserList;

  String extendedData;

  ZIMCallInvitationReceivedInfo({
    this.mode = ZIMCallInvitationMode.unknown,
    this.timeout = 0,
    this.caller = '',
    this.inviter = '',
    this.createTime = 0,
    List<ZIMCallUserInfo>? callUserList,
    this.extendedData = '',
  }) : callUserList = callUserList ?? [];

  ZIMCallInvitationReceivedInfo.fromMap(Map<dynamic, dynamic> map)
      : mode = ZIMCallInvitationModeExtension.mapValue[map['mode']] ??
            ZIMCallInvitationMode.unknown,
        timeout = map['timeout']!,
        caller = map['caller']!,
        inviter = map['inviter']!,
        createTime = map['createTime']!,
        callUserList = ((map['callUserList']!) as List)
            .map<ZIMCallUserInfo>((item) => ZIMCallUserInfo.fromMap(item))
            .toList(),
        extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {
      'mode': mode.value,
      'timeout': timeout,
      'caller': caller,
      'inviter': inviter,
      'createTime': createTime,
      'callUserList': callUserList.map((item) => item.toMap()).toList(),
      'extendedData': extendedData,
    };
  }
}

/// todo
///
/// todo
class ZIMCallInvitationCreatedInfo {
  ZIMCallInvitationMode mode;

  String caller;

  String extendedData;

  int timeout;

  int createTime;

  List<ZIMCallUserInfo> callUserList;

  ZIMCallInvitationCreatedInfo({
    this.mode = ZIMCallInvitationMode.unknown,
    this.caller = '',
    this.extendedData = '',
    this.timeout = 0,
    this.createTime = 0,
    List<ZIMCallUserInfo>? callUserList,
  }) : callUserList = callUserList ?? [];

  ZIMCallInvitationCreatedInfo.fromMap(Map<dynamic, dynamic> map)
      : mode = ZIMCallInvitationModeExtension.mapValue[map['mode']] ??
            ZIMCallInvitationMode.unknown,
        caller = map['caller']!,
        extendedData = map['extendedData']!,
        timeout = map['timeout']!,
        createTime = map['createTime']!,
        callUserList = ((map['callUserList']!) as List)
            .map<ZIMCallUserInfo>((item) => ZIMCallUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'mode': mode.value,
      'caller': caller,
      'extendedData': extendedData,
      'timeout': timeout,
      'createTime': createTime,
      'callUserList': callUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// todo
class ZIMCallInvitationCancelledInfo {
  String inviter;

  ZIMCallInvitationMode mode;

  String extendedData;

  ZIMCallInvitationCancelledInfo({
    this.inviter = '',
    this.mode = ZIMCallInvitationMode.unknown,
    this.extendedData = '',
  });

  ZIMCallInvitationCancelledInfo.fromMap(Map<dynamic, dynamic> map)
      : inviter = map['inviter']!,
        mode = ZIMCallInvitationModeExtension.mapValue[map['mode']] ??
            ZIMCallInvitationMode.unknown,
        extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {
      'inviter': inviter,
      'mode': mode.value,
      'extendedData': extendedData,
    };
  }
}

/// todo
///
/// todo
class ZIMCallInvitationAcceptedInfo {
  String invitee;

  String extendedData;

  ZIMCallInvitationAcceptedInfo({this.invitee = '', this.extendedData = ''});

  ZIMCallInvitationAcceptedInfo.fromMap(Map<dynamic, dynamic> map)
      : invitee = map['invitee']!,
        extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {'invitee': invitee, 'extendedData': extendedData};
  }
}

/// todo
///
/// todo
class ZIMCallInvitationRejectedInfo {
  String invitee;

  String extendedData;

  ZIMCallInvitationRejectedInfo({this.invitee = '', this.extendedData = ''});

  ZIMCallInvitationRejectedInfo.fromMap(Map<dynamic, dynamic> map)
      : invitee = map['invitee']!,
        extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {'invitee': invitee, 'extendedData': extendedData};
  }
}

/// todo
///
/// todo
class ZIMCallInvitationEndedInfo {
  String caller;

  String operatedUserID;

  String extendedData;

  ZIMCallInvitationMode mode;

  int endTime;

  ZIMCallInvitationEndedInfo({
    this.caller = '',
    this.operatedUserID = '',
    this.extendedData = '',
    this.mode = ZIMCallInvitationMode.unknown,
    this.endTime = 0,
  });

  ZIMCallInvitationEndedInfo.fromMap(Map<dynamic, dynamic> map)
      : caller = map['caller']!,
        operatedUserID = map['operatedUserID']!,
        extendedData = map['extendedData']!,
        mode = ZIMCallInvitationModeExtension.mapValue[map['mode']] ??
            ZIMCallInvitationMode.unknown,
        endTime = map['endTime']!;

  Map<String, dynamic> toMap() {
    return {
      'caller': caller,
      'operatedUserID': operatedUserID,
      'extendedData': extendedData,
      'mode': mode.value,
      'endTime': endTime,
    };
  }
}

/// todo
///
/// todo
class ZIMCallInvitationTimeoutInfo {
  ZIMCallInvitationMode mode;

  ZIMCallInvitationTimeoutInfo({this.mode = ZIMCallInvitationMode.unknown});

  ZIMCallInvitationTimeoutInfo.fromMap(Map<dynamic, dynamic> map)
      : mode = ZIMCallInvitationModeExtension.mapValue[map['mode']] ??
            ZIMCallInvitationMode.unknown;

  Map<String, dynamic> toMap() {
    return {'mode': mode.value};
  }
}

/// todo
///
/// todo
class ZIMCallInvitationQueryConfig {
  int count;

  int nextFlag;

  ZIMCallInvitationQueryConfig({this.count = 0, this.nextFlag = 0});

  ZIMCallInvitationQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : count = map['count']!,
        nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {'count': count, 'nextFlag': nextFlag};
  }
}

/// todo
///
/// todo
class ZIMCallInfo {
  String callID;

  String caller;

  String inviter;

  int createTime;

  int endTime;

  ZIMCallState state;

  ZIMCallInvitationMode mode;

  String extendedData;

  List<ZIMCallUserInfo> callUserList;

  ZIMCallInfo({
    required this.callID,
    required this.caller,
    required this.inviter,
    required this.createTime,
    required this.endTime,
    required this.state,
    required this.mode,
    required this.extendedData,
    required this.callUserList,
  });

  ZIMCallInfo.fromMap(Map<dynamic, dynamic> map)
      : callID = map['callID']!,
        caller = map['caller']!,
        inviter = map['inviter']!,
        createTime = map['createTime']!,
        endTime = map['endTime']!,
        state = ZIMCallStateExtension.mapValue[map['state']] ??
            ZIMCallState.unknown,
        mode = ZIMCallInvitationModeExtension.mapValue[map['mode']] ??
            ZIMCallInvitationMode.unknown,
        extendedData = map['extendedData']!,
        callUserList = ((map['callUserList']!) as List)
            .map<ZIMCallUserInfo>((item) => ZIMCallUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'callID': callID,
      'caller': caller,
      'inviter': inviter,
      'createTime': createTime,
      'endTime': endTime,
      'state': state.value,
      'mode': mode.value,
      'extendedData': extendedData,
      'callUserList': callUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// todo
class ZIMCallUserStateChangeInfo {
  List<ZIMCallUserInfo> callUserList;

  ZIMCallUserStateChangeInfo({List<ZIMCallUserInfo>? callUserList})
      : callUserList = callUserList ?? [];

  ZIMCallUserStateChangeInfo.fromMap(Map<dynamic, dynamic> map)
      : callUserList = ((map['callUserList']!) as List)
            .map<ZIMCallUserInfo>((item) => ZIMCallUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {'callUserList': callUserList.map((item) => item.toMap()).toList()};
  }
}

/// todo
///
/// todo
class ZIMBlacklistQueryConfig {
  int nextFlag;

  int count;

  ZIMBlacklistQueryConfig({this.nextFlag = 0, this.count = 0});

  ZIMBlacklistQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : nextFlag = map['nextFlag']!,
        count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// todo
///
/// todo
class ZIMFriendAddConfig {
  String friendAlias;

  Map<String, String> friendAttributes;

  String wording;

  ZIMFriendAddConfig({
    this.friendAlias = '',
    Map<String, String>? friendAttributes,
    this.wording = '',
  }) : friendAttributes = friendAttributes ?? {};

  ZIMFriendAddConfig.fromMap(Map<dynamic, dynamic> map)
      : friendAlias = map['friendAlias']!,
        friendAttributes = ((map['friendAttributes']!) as Map)
            .map<String, String>(
                (k, v) => MapEntry(k.toString(), v.toString())),
        wording = map['wording']!;

  Map<String, dynamic> toMap() {
    return {
      'friendAlias': friendAlias,
      'friendAttributes': friendAttributes,
      'wording': wording,
    };
  }
}

/// todo
///
/// todo
class ZIMFriendDeleteConfig {
  ZIMFriendDeleteType type;

  ZIMFriendDeleteConfig({this.type = ZIMFriendDeleteType.both});

  ZIMFriendDeleteConfig.fromMap(Map<dynamic, dynamic> map)
      : type = ZIMFriendDeleteTypeExtension.mapValue[map['type']] ??
            ZIMFriendDeleteType.both;

  Map<String, dynamic> toMap() {
    return {'type': type.value};
  }
}

/// todo
///
/// todo
class ZIMFriendListQueryConfig {
  int nextFlag;

  int count;

  ZIMFriendListQueryConfig({this.nextFlag = 0, this.count = 0});

  ZIMFriendListQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : nextFlag = map['nextFlag']!,
        count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// todo
///
/// todo
class ZIMFriendSearchConfig {
  int nextFlag;

  int count;

  List<String> keywords;

  bool isAlsoMatchFriendAlias;

  ZIMFriendSearchConfig({
    this.nextFlag = 0,
    this.count = 0,
    List<String>? keywords,
    this.isAlsoMatchFriendAlias = false,
  }) : keywords = keywords ?? [];

  ZIMFriendSearchConfig.fromMap(Map<dynamic, dynamic> map)
      : nextFlag = map['nextFlag']!,
        count = map['count']!,
        keywords = ((map['keywords']!) as List)
            .map<String>((item) => item as String)
            .toList(),
        isAlsoMatchFriendAlias = map['isAlsoMatchFriendAlias']!;

  Map<String, dynamic> toMap() {
    return {
      'nextFlag': nextFlag,
      'count': count,
      'keywords': keywords,
      'isAlsoMatchFriendAlias': isAlsoMatchFriendAlias,
    };
  }
}

/// todo
///
/// todo
class ZIMFriendRelationCheckConfig {
  ZIMFriendRelationCheckType type;

  ZIMFriendRelationCheckConfig({this.type = ZIMFriendRelationCheckType.both});

  ZIMFriendRelationCheckConfig.fromMap(Map<dynamic, dynamic> map)
      : type = ZIMFriendRelationCheckTypeExtension.mapValue[map['type']] ??
            ZIMFriendRelationCheckType.both;

  Map<String, dynamic> toMap() {
    return {'type': type.value};
  }
}

/// todo
///
/// todo
class ZIMFriendRelationInfo {
  ZIMUserRelationType type;

  String userID;

  ZIMFriendRelationInfo({required this.type, required this.userID});

  ZIMFriendRelationInfo.fromMap(Map<dynamic, dynamic> map)
      : type = ZIMUserRelationTypeExtension.mapValue[map['type']] ??
            ZIMUserRelationType.unknown,
        userID = map['userID']!;

  Map<String, dynamic> toMap() {
    return {'type': type.value, 'userID': userID};
  }
}

/// todo
///
/// todo
class ZIMFriendInfo extends ZIMUserInfo {
  String friendAlias;

  Map<String, String> friendAttributes;

  int createTime;

  String wording;

  ZIMFriendInfo({
    String userID = "",
    String userName = "",
    String userAvatarUrl = "",
    this.friendAlias = '',
    Map<String, String>? friendAttributes,
    this.createTime = 0,
    this.wording = '',
  })  : friendAttributes = friendAttributes ?? {},
        super(userID: userID, userName: userName, userAvatarUrl: userAvatarUrl);

  ZIMFriendInfo.fromMap(Map<dynamic, dynamic> map)
      : friendAlias = map['friendAlias']!,
        friendAttributes = ((map['friendAttributes']!) as Map)
            .map<String, String>(
                (k, v) => MapEntry(k.toString(), v.toString())),
        createTime = map['createTime']!,
        wording = map['wording']!,
        super.fromMap(map);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'friendAlias': friendAlias,
      'friendAttributes': friendAttributes,
      'createTime': createTime,
      'wording': wording,
      'classType': 'ZIMFriendInfo',
    });
    return baseMap;
  }
}

/// todo
///
/// todo
class ZIMFriendApplicationSendConfig {
  String wording;

  String friendAlias;

  Map<String, String> friendAttributes;

  ZIMPushConfig? pushConfig;

  ZIMFriendApplicationSendConfig({
    this.wording = '',
    this.friendAlias = '',
    Map<String, String>? friendAttributes,
    this.pushConfig,
  }) : friendAttributes = friendAttributes ?? {};

  ZIMFriendApplicationSendConfig.fromMap(Map<dynamic, dynamic> map)
      : wording = map['wording']!,
        friendAlias = map['friendAlias']!,
        friendAttributes = ((map['friendAttributes']!) as Map)
            .map<String, String>(
                (k, v) => MapEntry(k.toString(), v.toString())),
        pushConfig = (map['pushConfig'] != null)
            ? ZIMPushConfig.fromMap(map['pushConfig'])
            : null;

  Map<String, dynamic> toMap() {
    return {
      'wording': wording,
      'friendAlias': friendAlias,
      'friendAttributes': friendAttributes,
      'pushConfig': pushConfig?.toMap(),
    };
  }
}

/// todo
///
/// todo
class ZIMFriendApplicationAcceptConfig {
  String friendAlias;

  Map<String, String> friendAttributes;

  ZIMPushConfig? pushConfig;

  ZIMFriendApplicationAcceptConfig({
    this.friendAlias = '',
    Map<String, String>? friendAttributes,
    this.pushConfig,
  }) : friendAttributes = friendAttributes ?? {};

  ZIMFriendApplicationAcceptConfig.fromMap(Map<dynamic, dynamic> map)
      : friendAlias = map['friendAlias']!,
        friendAttributes = ((map['friendAttributes']!) as Map)
            .map<String, String>(
                (k, v) => MapEntry(k.toString(), v.toString())),
        pushConfig = (map['pushConfig'] != null)
            ? ZIMPushConfig.fromMap(map['pushConfig'])
            : null;

  Map<String, dynamic> toMap() {
    return {
      'friendAlias': friendAlias,
      'friendAttributes': friendAttributes,
      'pushConfig': pushConfig?.toMap(),
    };
  }
}

/// todo
///
/// todo
class ZIMFriendApplicationRejectConfig {
  ZIMPushConfig? pushConfig;

  ZIMFriendApplicationRejectConfig({this.pushConfig});

  ZIMFriendApplicationRejectConfig.fromMap(Map<dynamic, dynamic> map)
      : pushConfig = (map['pushConfig'] != null)
            ? ZIMPushConfig.fromMap(map['pushConfig'])
            : null;

  Map<String, dynamic> toMap() {
    return {'pushConfig': pushConfig?.toMap()};
  }
}

/// todo
///
/// todo
class ZIMFriendApplicationListQueryConfig {
  int nextFlag;

  int count;

  ZIMFriendApplicationListQueryConfig({this.nextFlag = 0, this.count = 0});

  ZIMFriendApplicationListQueryConfig.fromMap(Map<dynamic, dynamic> map)
      : nextFlag = map['nextFlag']!,
        count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'nextFlag': nextFlag, 'count': count};
  }
}

/// todo
///
/// todo
class ZIMFriendApplicationInfo {
  ZIMFriendApplicationType type;

  ZIMFriendApplicationState state;

  ZIMUserInfo applyUser;

  String wording;

  int createTime;

  int updateTime;

  ZIMFriendApplicationInfo({
    required this.type,
    required this.state,
    required this.applyUser,
    required this.wording,
    required this.createTime,
    required this.updateTime,
  });

  ZIMFriendApplicationInfo.fromMap(Map<dynamic, dynamic> map)
      : type = ZIMFriendApplicationTypeExtension.mapValue[map['type']] ??
            ZIMFriendApplicationType.unknown,
        state = ZIMFriendApplicationStateExtension.mapValue[map['state']] ??
            ZIMFriendApplicationState.unknown,
        applyUser = ZIMDataUtils.parseZIMUserInfoFromMap(map['applyUser']),
        wording = map['wording']!,
        createTime = map['createTime']!,
        updateTime = map['updateTime']!;

  Map<String, dynamic> toMap() {
    return {
      'type': type.value,
      'state': state.value,
      'applyUser': applyUser.toMap(),
      'wording': wording,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }
}

/// todo
class ZIMLogUploadedResult {
  ZIMLogUploadedResult();

  ZIMLogUploadedResult.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// test
///
/// test
class ZIMLoggedInResult {
  ZIMLoggedInResult();

  ZIMLoggedInResult.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// todo
///
/// - [token] TODO
class ZIMTokenRenewedResult {
  /// TODO
  String token;

  ZIMTokenRenewedResult({required this.token});

  ZIMTokenRenewedResult.fromMap(Map<dynamic, dynamic> map)
      : token = map['token']!;

  Map<String, dynamic> toMap() {
    return {'token': token};
  }
}

/// todo
///
/// - [userName] TODO
class ZIMUserNameUpdatedResult {
  /// TODO
  String userName;

  ZIMUserNameUpdatedResult({required this.userName});

  ZIMUserNameUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : userName = map['userName']!;

  Map<String, dynamic> toMap() {
    return {'userName': userName};
  }
}

/// todo
///
/// - [userAvatarUrl] TODO
class ZIMUserAvatarUrlUpdatedResult {
  /// TODO
  String userAvatarUrl;

  ZIMUserAvatarUrlUpdatedResult({required this.userAvatarUrl});

  ZIMUserAvatarUrlUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : userAvatarUrl = map['userAvatarUrl']!;

  Map<String, dynamic> toMap() {
    return {'userAvatarUrl': userAvatarUrl};
  }
}

/// todo
///
/// - [extendedData] TODO
class ZIMUserExtendedDataUpdatedResult {
  /// TODO
  String extendedData;

  ZIMUserExtendedDataUpdatedResult({required this.extendedData});

  ZIMUserExtendedDataUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : extendedData = map['extendedData']!;

  Map<String, dynamic> toMap() {
    return {'extendedData': extendedData};
  }
}

/// todo
///
/// - [customStatus] TODO
class ZIMUserCustomStatusUpdatedResult {
  /// TODO
  String customStatus;

  ZIMUserCustomStatusUpdatedResult({
    required this.customStatus,
  });

  ZIMUserCustomStatusUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : customStatus = map['customStatus']!;

  Map<String, dynamic> toMap() {
    return {'customStatus': customStatus};
  }
}

/// todo
///
/// - [userList] TODO
/// - [errorUserList] TODO
class ZIMUsersInfoQueriedResult {
  /// TODO
  List<ZIMUserFullInfo> userList;

  /// TODO
  List<ZIMErrorUserInfo> errorUserList;

  ZIMUsersInfoQueriedResult({
    required this.userList,
    required this.errorUserList,
  });

  ZIMUsersInfoQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : userList = ((map['userList']!) as List)
            .map<ZIMUserFullInfo>((item) => ZIMUserFullInfo.fromMap(item))
            .toList(),
        errorUserList = ((map['errorUserList']!) as List)
            .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'userList': userList.map((item) => item.toMap()).toList(),
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [offlinePushRule] TODO
class ZIMUserOfflinePushRuleUpdatedResult {
  /// TODO
  ZIMUserOfflinePushRule offlinePushRule;

  ZIMUserOfflinePushRuleUpdatedResult({required this.offlinePushRule});

  ZIMUserOfflinePushRuleUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : offlinePushRule =
            ZIMUserOfflinePushRule.fromMap(map['offlinePushRule']);

  Map<String, dynamic> toMap() {
    return {'offlinePushRule': offlinePushRule.toMap()};
  }
}

/// todo
///
/// - [selfUserInfo] TODO
class ZIMSelfUserInfoQueriedResult {
  /// TODO
  ZIMSelfUserInfo selfUserInfo;

  ZIMSelfUserInfoQueriedResult({required this.selfUserInfo});

  ZIMSelfUserInfoQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : selfUserInfo = ZIMSelfUserInfo.fromMap(map['selfUserInfo']);

  Map<String, dynamic> toMap() {
    return {'selfUserInfo': selfUserInfo.toMap()};
  }
}

/// todo
///
/// - [userStatusList] TODO
/// - [errorUserList] TODO
class ZIMUsersStatusQueriedResult {
  /// TODO
  List<ZIMUserStatus> userStatusList;

  /// TODO
  List<ZIMErrorUserInfo> errorUserList;

  ZIMUsersStatusQueriedResult({
    required this.userStatusList,
    required this.errorUserList,
  });

  ZIMUsersStatusQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : userStatusList = ((map['userStatusList']!) as List)
            .map<ZIMUserStatus>((item) => ZIMUserStatus.fromMap(item))
            .toList(),
        errorUserList = ((map['errorUserList']!) as List)
            .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'userStatusList': userStatusList.map((item) => item.toMap()).toList(),
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [errorUserList] TODO
class ZIMUsersStatusSubscribedResult {
  /// TODO
  List<ZIMErrorUserInfo> errorUserList;

  ZIMUsersStatusSubscribedResult({required this.errorUserList});

  ZIMUsersStatusSubscribedResult.fromMap(Map<dynamic, dynamic> map)
      : errorUserList = ((map['errorUserList']!) as List)
            .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [errorUserList] TODO
class ZIMUsersStatusUnsubscribedResult {
  /// TODO
  List<ZIMErrorUserInfo> errorUserList;

  ZIMUsersStatusUnsubscribedResult({required this.errorUserList});

  ZIMUsersStatusUnsubscribedResult.fromMap(Map<dynamic, dynamic> map)
      : errorUserList = ((map['errorUserList']!) as List)
            .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [userStatusSubscriptionList] TODO
class ZIMSubscribedUserStatusListQueriedResult {
  /// TODO
  List<ZIMUserStatusSubscription> userStatusSubscriptionList;

  ZIMSubscribedUserStatusListQueriedResult({
    required this.userStatusSubscriptionList,
  });

  ZIMSubscribedUserStatusListQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : userStatusSubscriptionList =
            ((map['userStatusSubscriptionList']!) as List)
                .map<ZIMUserStatusSubscription>(
                  (item) => ZIMUserStatusSubscription.fromMap(item),
                )
                .toList();

  Map<String, dynamic> toMap() {
    return {
      'userStatusSubscriptionList':
          userStatusSubscriptionList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [conversation] TODO
class ZIMConversationQueriedResult {
  /// TODO
  ZIMConversation conversation;

  ZIMConversationQueriedResult({required this.conversation});

  ZIMConversationQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : conversation = ZIMDataUtils.parseZIMConversationFromMap(
          map['conversation'],
        );

  Map<String, dynamic> toMap() {
    return {'conversation': conversation.toMap()};
  }
}

/// todo
///
/// - [conversationList] TODO
class ZIMConversationListQueriedResult {
  /// TODO
  List<ZIMConversation> conversationList;

  ZIMConversationListQueriedResult({required this.conversationList});

  ZIMConversationListQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : conversationList = ((map['conversationList']!) as List)
            .map<ZIMConversation>(
              (item) => ZIMDataUtils.parseZIMConversationFromMap(item),
            )
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'conversationList': conversationList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [unreadMessageCount] TODO
class ZIMConversationTotalUnreadMessageCountQueriedResult {
  /// TODO
  int unreadMessageCount;

  ZIMConversationTotalUnreadMessageCountQueriedResult({
    required this.unreadMessageCount,
  });

  ZIMConversationTotalUnreadMessageCountQueriedResult.fromMap(
    Map<dynamic, dynamic> map,
  ) : unreadMessageCount = map['unreadMessageCount']!;

  Map<String, dynamic> toMap() {
    return {'unreadMessageCount': unreadMessageCount};
  }
}

/// todo
///
/// - [conversationID] TODO
/// - [conversationType] TODO
class ZIMConversationDeletedResult {
  /// TODO
  String conversationID;

  /// TODO
  ZIMConversationType conversationType;

  ZIMConversationDeletedResult({
    required this.conversationID,
    required this.conversationType,
  });

  ZIMConversationDeletedResult.fromMap(Map<dynamic, dynamic> map)
      : conversationID = map['conversationID']!,
        conversationType =
            ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
                ZIMConversationType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
    };
  }
}

/// todo
class ZIMConversationsAllDeletedResult {
  ZIMConversationsAllDeletedResult();

  ZIMConversationsAllDeletedResult.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// todo
///
/// - [conversationID] TODO
/// - [conversationType] TODO
class ZIMConversationUnreadMessageCountClearedResult {
  /// TODO
  String conversationID;

  /// TODO
  ZIMConversationType conversationType;

  ZIMConversationUnreadMessageCountClearedResult({
    required this.conversationID,
    required this.conversationType,
  });

  ZIMConversationUnreadMessageCountClearedResult.fromMap(
    Map<dynamic, dynamic> map,
  )   : conversationID = map['conversationID']!,
        conversationType =
            ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
                ZIMConversationType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
    };
  }
}

/// todo
class ZIMConversationTotalUnreadMessageCountClearedResult {
  ZIMConversationTotalUnreadMessageCountClearedResult();

  ZIMConversationTotalUnreadMessageCountClearedResult.fromMap(
    Map<dynamic, dynamic> map,
  );

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// todo
///
/// - [conversationID] TODO
/// - [conversationType] TODO
class ZIMConversationNotificationStatusSetResult {
  /// TODO
  String conversationID;

  /// TODO
  ZIMConversationType conversationType;

  ZIMConversationNotificationStatusSetResult({
    required this.conversationID,
    required this.conversationType,
  });

  ZIMConversationNotificationStatusSetResult.fromMap(Map<dynamic, dynamic> map)
      : conversationID = map['conversationID']!,
        conversationType =
            ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
                ZIMConversationType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
    };
  }
}

/// todo
///
/// - [conversationID] TODO
/// - [conversationType] TODO
class ZIMConversationMessageReceiptReadSentResult {
  /// TODO
  String conversationID;

  /// TODO
  ZIMConversationType conversationType;

  ZIMConversationMessageReceiptReadSentResult({
    required this.conversationID,
    required this.conversationType,
  });

  ZIMConversationMessageReceiptReadSentResult.fromMap(Map<dynamic, dynamic> map)
      : conversationID = map['conversationID']!,
        conversationType =
            ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
                ZIMConversationType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
    };
  }
}

/// todo
///
/// - [conversationID] TODO
/// - [conversationType] TODO
class ZIMConversationPinnedStateUpdatedResult {
  /// TODO
  String conversationID;

  /// TODO
  ZIMConversationType conversationType;

  ZIMConversationPinnedStateUpdatedResult({
    required this.conversationID,
    required this.conversationType,
  });

  ZIMConversationPinnedStateUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : conversationID = map['conversationID']!,
        conversationType =
            ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
                ZIMConversationType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
    };
  }
}

/// todo
///
/// - [conversationList] TODO
class ZIMConversationPinnedListQueriedResult {
  /// TODO
  List<ZIMConversation> conversationList;

  ZIMConversationPinnedListQueriedResult({required this.conversationList});

  ZIMConversationPinnedListQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : conversationList = ((map['conversationList']!) as List)
            .map<ZIMConversation>(
              (item) => ZIMDataUtils.parseZIMConversationFromMap(item),
            )
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'conversationList': conversationList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [conversationID] TODO
/// - [conversationType] TODO
class ZIMConversationDraftSetResult {
  /// TODO
  String conversationID;

  /// TODO
  ZIMConversationType conversationType;

  ZIMConversationDraftSetResult({
    required this.conversationID,
    required this.conversationType,
  });

  ZIMConversationDraftSetResult.fromMap(Map<dynamic, dynamic> map)
      : conversationID = map['conversationID']!,
        conversationType =
            ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
                ZIMConversationType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
    };
  }
}

/// todo
///
/// - [failedConversationInfos] TODO
class ZIMConversationMarkSetResult {
  /// TODO
  List<ZIMConversationBaseInfo> failedConversationInfos;

  ZIMConversationMarkSetResult({required this.failedConversationInfos});

  ZIMConversationMarkSetResult.fromMap(Map<dynamic, dynamic> map)
      : failedConversationInfos = ((map['failedConversationInfos']!) as List)
            .map<ZIMConversationBaseInfo>(
              (item) => ZIMConversationBaseInfo.fromMap(item),
            )
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'failedConversationInfos':
          failedConversationInfos.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [conversationSearchInfoList] TODO
/// - [nextFlag] TODO
class ZIMConversationsSearchedResult {
  /// TODO
  List<ZIMConversationSearchInfo> conversationSearchInfoList;

  /// TODO
  int nextFlag;

  ZIMConversationsSearchedResult({
    required this.conversationSearchInfoList,
    required this.nextFlag,
  });

  ZIMConversationsSearchedResult.fromMap(Map<dynamic, dynamic> map)
      : conversationSearchInfoList =
            ((map['conversationSearchInfoList']!) as List)
                .map<ZIMConversationSearchInfo>(
                  (item) => ZIMConversationSearchInfo.fromMap(item),
                )
                .toList(),
        nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'conversationSearchInfoList':
          conversationSearchInfoList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// todo
///
/// - [message] Message object.
class ZIMMessageSentResult {
  /// Message object.
  ZIMMessage message;

  ZIMMessageSentResult({required this.message});

  ZIMMessageSentResult.fromMap(Map<dynamic, dynamic> map)
      : message = ZIMDataUtils.parseZIMMessageFromMap(map['message']);

  Map<String, dynamic> toMap() {
    return {'message': message.toMap()};
  }
}

/// todo
///
/// - [message] Message object.
typedef ZIMMessageAttachedCallback = void Function(ZIMMessage message);

/// todo
///
/// - [message] Media message object.
/// - [currentFileSize] Current file size.
/// - [totalFileSize] Total file size.
typedef ZIMMediaUploadingProgress = void Function(
  ZIMMediaMessage message,
  int currentFileSize,
  int totalFileSize,
);

/// todo
///
/// - [message] Multiple media message object.
/// - [currentFileSize] Current file size.
/// - [totalFileSize] Total file size.
/// - [messageInfoIndex] Current message index.
/// - [currentIndexFileSize] Current index file size.
/// - [totalIndexFileSize] Total index file size.
typedef ZIMMultipleMediaUploadingProgress = void Function(
  ZIMMultipleMessage message,
  int currentFileSize,
  int totalFileSize,
  int messageInfoIndex,
  int currentIndexFileSize,
  int totalIndexFileSize,
);

/// todo
///
/// - [conversationID] Conversation ID.
/// - [conversationType] Conversation type.
/// - [messageList] Message list.
class ZIMMessageQueriedResult {
  /// Conversation ID.
  String conversationID;

  /// Conversation type.
  ZIMConversationType conversationType;

  /// Message list.
  List<ZIMMessage> messageList;

  ZIMMessageQueriedResult({
    required this.conversationID,
    required this.conversationType,
    required this.messageList,
  });

  ZIMMessageQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : conversationID = map['conversationID']!,
        conversationType =
            ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
                ZIMConversationType.unknown,
        messageList = ((map['messageList']!) as List)
            .map<ZIMMessage>(
                (item) => ZIMDataUtils.parseZIMMessageFromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'messageList': messageList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [conversationID] Conversation ID.
/// - [conversationType] Conversation type.
class ZIMMessageDeletedResult {
  /// Conversation ID.
  String conversationID;

  /// Conversation type.
  ZIMConversationType conversationType;

  ZIMMessageDeletedResult({
    required this.conversationID,
    required this.conversationType,
  });

  ZIMMessageDeletedResult.fromMap(Map<dynamic, dynamic> map)
      : conversationID = map['conversationID']!,
        conversationType =
            ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
                ZIMConversationType.unknown;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
    };
  }
}

/// todo
class ZIMConversationMessagesAllDeletedResult {
  ZIMConversationMessagesAllDeletedResult();

  ZIMConversationMessagesAllDeletedResult.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// todo
///
/// - [message] Message object.
class ZIMMessageRevokedResult {
  /// Message object.
  ZIMMessage message;

  ZIMMessageRevokedResult({required this.message});

  ZIMMessageRevokedResult.fromMap(Map<dynamic, dynamic> map)
      : message = ZIMDataUtils.parseZIMMessageFromMap(map['message']);

  Map<String, dynamic> toMap() {
    return {'message': message.toMap()};
  }
}

/// todo
///
/// - [message] Message object.
class ZIMMessageInsertedResult {
  /// Message object.
  ZIMMessage message;

  ZIMMessageInsertedResult({required this.message});

  ZIMMessageInsertedResult.fromMap(Map<dynamic, dynamic> map)
      : message = ZIMDataUtils.parseZIMMessageFromMap(map['message']);

  Map<String, dynamic> toMap() {
    return {'message': message.toMap()};
  }
}

/// todo
///
/// - [message] Message object.
class ZIMMessageLocalExtendedDataUpdatedResult {
  /// Message object.
  ZIMMessage message;

  ZIMMessageLocalExtendedDataUpdatedResult({required this.message});

  ZIMMessageLocalExtendedDataUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : message = ZIMDataUtils.parseZIMMessageFromMap(map['message']);

  Map<String, dynamic> toMap() {
    return {'message': message.toMap()};
  }
}

/// todo
///
/// - [conversationID] Conversation ID.
/// - [conversationType] Conversation type.
/// - [errorMessageIDs] Error message ID list.
class ZIMMessageReceiptsReadSentResult {
  /// Conversation ID.
  String conversationID;

  /// Conversation type.
  ZIMConversationType conversationType;

  /// Error message ID list.
  List<dynamic> errorMessageIDs;

  ZIMMessageReceiptsReadSentResult({
    required this.conversationID,
    required this.conversationType,
    required this.errorMessageIDs,
  });

  ZIMMessageReceiptsReadSentResult.fromMap(Map<dynamic, dynamic> map)
      : conversationID = map['conversationID']!,
        conversationType =
            ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
                ZIMConversationType.unknown,
        errorMessageIDs = ((map['errorMessageIDs']!) as List)
            .map<dynamic>((item) => item as dynamic)
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'errorMessageIDs': errorMessageIDs,
    };
  }
}

/// todo
///
/// - [infos] Message receipt information list.
/// - [errorMessageIDs] Error message ID list.
class ZIMMessageReceiptsInfoQueriedResult {
  /// Message receipt information list.
  List<ZIMMessageReceiptInfo> infos;

  /// Error message ID list.
  List<dynamic> errorMessageIDs;

  ZIMMessageReceiptsInfoQueriedResult({
    required this.infos,
    required this.errorMessageIDs,
  });

  ZIMMessageReceiptsInfoQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : infos = ((map['infos']!) as List)
            .map<ZIMMessageReceiptInfo>(
              (item) => ZIMMessageReceiptInfo.fromMap(item),
            )
            .toList(),
        errorMessageIDs = ((map['errorMessageIDs']!) as List)
            .map<dynamic>((item) => item as dynamic)
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'infos': infos.map((item) => item.toMap()).toList(),
      'errorMessageIDs': errorMessageIDs,
    };
  }
}

/// todo
///
/// - [message] Message object.
class ZIMMediaDownloadedResult {
  /// Message object.
  ZIMMessage message;

  ZIMMediaDownloadedResult({required this.message});

  ZIMMediaDownloadedResult.fromMap(Map<dynamic, dynamic> map)
      : message = ZIMDataUtils.parseZIMMessageFromMap(map['message']);

  Map<String, dynamic> toMap() {
    return {'message': message.toMap()};
  }
}

/// todo
///
/// - [message] Message object.
/// - [currentFileSize] Current file size.
/// - [totalFileSize] Total file size.
typedef ZIMMediaDownloadingProgress = void Function(
    ZIMMessage message, int currentFileSize, int totalFileSize);

/// todo
///
/// - [conversationID] Conversation ID.
/// - [conversationType] Conversation type.
/// - [messageList] Message list.
/// - [nextMessage] Next message object.
class ZIMMessagesSearchedResult {
  /// Conversation ID.
  String conversationID;

  /// Conversation type.
  ZIMConversationType conversationType;

  /// Message list.
  List<ZIMMessage> messageList;

  /// Next message object.
  ZIMMessage? nextMessage;

  ZIMMessagesSearchedResult({
    required this.conversationID,
    required this.conversationType,
    required this.messageList,
    this.nextMessage,
  });

  ZIMMessagesSearchedResult.fromMap(Map<dynamic, dynamic> map)
      : conversationID = map['conversationID']!,
        conversationType =
            ZIMConversationTypeExtension.mapValue[map['conversationType']] ??
                ZIMConversationType.unknown,
        messageList = ((map['messageList']!) as List)
            .map<ZIMMessage>(
                (item) => ZIMDataUtils.parseZIMMessageFromMap(item))
            .toList(),
        nextMessage = (map['nextMessage'] != null)
            ? ZIMDataUtils.parseZIMMessageFromMap(map['nextMessage'])
            : null;

  Map<String, dynamic> toMap() {
    return {
      'conversationID': conversationID,
      'conversationType': conversationType.value,
      'messageList': messageList.map((item) => item.toMap()).toList(),
      'nextMessage': nextMessage?.toMap(),
    };
  }
}

/// todo
///
/// - [messageList] Message list.
/// - [nextMessage] Next message object.
class ZIMMessagesGlobalSearchedResult {
  /// Message list.
  List<ZIMMessage> messageList;

  /// Next message object.
  ZIMMessage? nextMessage;

  ZIMMessagesGlobalSearchedResult({
    required this.messageList,
    this.nextMessage,
  });

  ZIMMessagesGlobalSearchedResult.fromMap(Map<dynamic, dynamic> map)
      : messageList = ((map['messageList']!) as List)
            .map<ZIMMessage>(
                (item) => ZIMDataUtils.parseZIMMessageFromMap(item))
            .toList(),
        nextMessage = (map['nextMessage'] != null)
            ? ZIMDataUtils.parseZIMMessageFromMap(map['nextMessage'])
            : null;

  Map<String, dynamic> toMap() {
    return {
      'messageList': messageList.map((item) => item.toMap()).toList(),
      'nextMessage': nextMessage?.toMap(),
    };
  }
}

/// todo
///
/// - [reaction] Message reaction object.
class ZIMMessageReactionAddedResult {
  /// Message reaction object.
  ZIMMessageReaction reaction;

  ZIMMessageReactionAddedResult({required this.reaction});

  ZIMMessageReactionAddedResult.fromMap(Map<dynamic, dynamic> map)
      : reaction = ZIMMessageReaction.fromMap(map['reaction']);

  Map<String, dynamic> toMap() {
    return {'reaction': reaction.toMap()};
  }
}

/// todo
///
/// - [reaction] Message reaction object.
class ZIMMessageReactionDeletedResult {
  /// Message reaction object.
  ZIMMessageReaction reaction;

  ZIMMessageReactionDeletedResult({required this.reaction});

  ZIMMessageReactionDeletedResult.fromMap(Map<dynamic, dynamic> map)
      : reaction = ZIMMessageReaction.fromMap(map['reaction']);

  Map<String, dynamic> toMap() {
    return {'reaction': reaction.toMap()};
  }
}

/// todo
///
/// - [message] Message object.
/// - [userInfoList] List of user reaction information.
/// - [reactionType] Message reaction type.
/// - [nextFlag] List query anchor, used to query the next page. The current value returns 0, which means that the list has been pulled out.
/// - [totalCount] Total user count.
class ZIMMessageReactionUserListQueriedResult {
  /// Message object.
  ZIMMessage message;

  /// List of user reaction information.
  List<ZIMMessageReactionUserFullInfo> userInfoList;

  /// Message reaction type.
  String reactionType;

  /// List query anchor, used to query the next page. The current value returns 0, which means that the list has been pulled out.
  int nextFlag;

  /// Total user count.
  int totalCount;

  @Deprecated('Deprecated since 2.28.0. Please use [userInfoList] instead.')
  List<ZIMMessageReactionUserInfo> userList;

  ZIMMessageReactionUserListQueriedResult({
    required this.message,
    required this.userInfoList,
    required this.reactionType,
    required this.nextFlag,
    required this.totalCount,
    required this.userList,
  });

  ZIMMessageReactionUserListQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : message = ZIMDataUtils.parseZIMMessageFromMap(map['message']),
        userInfoList = ((map['userInfoList']!) as List)
            .map<ZIMMessageReactionUserFullInfo>(
              (item) => ZIMMessageReactionUserFullInfo.fromMap(item),
            )
            .toList(),
        reactionType = map['reactionType']!,
        nextFlag = map['nextFlag']!,
        totalCount = map['totalCount']!,
        userList = ((map['userList']!) as List)
            .map<ZIMMessageReactionUserInfo>(
              (item) => ZIMMessageReactionUserInfo.fromMap(item),
            )
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'message': message.toMap(),
      'userInfoList': userInfoList.map((item) => item.toMap()).toList(),
      'reactionType': reactionType,
      'nextFlag': nextFlag,
      'totalCount': totalCount,
      'userList': userList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [message] Combine message object. The messageList in this object already contains the sub-message list of the merged message.
class ZIMCombineMessageDetailQueriedResult {
  /// Combine message object. The messageList in this object already contains the sub-message list of the merged message.
  ZIMCombineMessage message;

  ZIMCombineMessageDetailQueriedResult({required this.message});

  ZIMCombineMessageDetailQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : message = ZIMCombineMessage.fromMap(map['message']);

  Map<String, dynamic> toMap() {
    return {'message': message.toMap()};
  }
}

/// todo
///
/// - [messageList] Message list.
/// - [nextFlag] List query anchor, used to query the next page. The current value returns 0, which means that the list has been pulled out.
/// - [rootRepliedInfo] Root message reply information.
class ZIMMessageRepliedListQueriedResult {
  /// Message list.
  List<ZIMMessage> messageList;

  /// List query anchor, used to query the next page. The current value returns 0, which means that the list has been pulled out.
  int nextFlag;

  /// Root message reply information.
  ZIMMessageRootRepliedInfo rootRepliedInfo;

  ZIMMessageRepliedListQueriedResult({
    required this.messageList,
    required this.nextFlag,
    required this.rootRepliedInfo,
  });

  ZIMMessageRepliedListQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : messageList = ((map['messageList']!) as List)
            .map<ZIMMessage>(
                (item) => ZIMDataUtils.parseZIMMessageFromMap(item))
            .toList(),
        nextFlag = map['nextFlag']!,
        rootRepliedInfo = ZIMMessageRootRepliedInfo.fromMap(
          map['rootRepliedInfo'],
        );

  Map<String, dynamic> toMap() {
    return {
      'messageList': messageList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
      'rootRepliedInfo': rootRepliedInfo.toMap(),
    };
  }
}

/// todo
///
/// - [message] Message object.
class ZIMMessageEditedResult {
  /// Message object.
  ZIMMessage message;

  ZIMMessageEditedResult({required this.message});

  ZIMMessageEditedResult.fromMap(Map<dynamic, dynamic> map)
      : message = ZIMDataUtils.parseZIMMessageFromMap(map['message']);

  Map<String, dynamic> toMap() {
    return {'message': message.toMap()};
  }
}

/// todo
class ZIMSendingMessageCancelledResult {
  ZIMSendingMessageCancelledResult();

  ZIMSendingMessageCancelledResult.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// Callback for the pin message operation result.
class ZIMMessagePinnedResult {
  ZIMMessagePinnedResult();

  ZIMMessagePinnedResult.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// Query the list of pinned messages in the conversation.
///
/// - [messageList] Message list.
class ZIMPinnedMessageListQueriedResult {
  /// Message list.
  List<ZIMMessage> messageList;

  ZIMPinnedMessageListQueriedResult({required this.messageList});

  ZIMPinnedMessageListQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : messageList = ((map['messageList']!) as List)
            .map<ZIMMessage>(
                (item) => ZIMDataUtils.parseZIMMessageFromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {'messageList': messageList.map((item) => item.toMap()).toList()};
  }
}

/// todo
class ZIMMessageImportedResult {
  ZIMMessageImportedResult();

  ZIMMessageImportedResult.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// todo
///
/// - [importedMessageCount] The number of imported messages.
/// - [totalMessageCount] The total number of messages.
typedef ZIMMessageImportingProgress = void Function(
    int importedMessageCount, int totalMessageCount);

/// todo
class ZIMMessageExportedResult {
  ZIMMessageExportedResult();

  ZIMMessageExportedResult.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// todo
///
/// - [exportedMessageCount] The number of exported messages.
/// - [totalMessageCount] The total number of messages.
typedef ZIMMessageExportingProgress = void Function(
    int exportedMessageCount, int totalMessageCount);

/// todo
///
/// - [fileCacheInfo] File cache information.
class ZIMFileCacheQueriedResult {
  /// File cache information.
  ZIMFileCacheInfo fileCacheInfo;

  ZIMFileCacheQueriedResult({required this.fileCacheInfo});

  ZIMFileCacheQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : fileCacheInfo = ZIMFileCacheInfo.fromMap(map['fileCacheInfo']);

  Map<String, dynamic> toMap() {
    return {'fileCacheInfo': fileCacheInfo.toMap()};
  }
}

/// todo
class ZIMFileCacheClearedResult {
  ZIMFileCacheClearedResult();

  ZIMFileCacheClearedResult.fromMap(Map<dynamic, dynamic> map);

  Map<String, dynamic> toMap() {
    return {};
  }
}

/// todo
///
/// - [roomInfo] Room information.
class ZIMRoomCreatedResult {
  /// Room information.
  ZIMRoomFullInfo roomInfo;

  ZIMRoomCreatedResult({required this.roomInfo});

  ZIMRoomCreatedResult.fromMap(Map<dynamic, dynamic> map)
      : roomInfo = ZIMRoomFullInfo.fromMap(map['roomInfo']);

  Map<String, dynamic> toMap() {
    return {'roomInfo': roomInfo.toMap()};
  }
}

/// todo
///
/// - [roomInfo] Room information.
class ZIMRoomJoinedResult {
  /// Room information.
  ZIMRoomFullInfo roomInfo;

  ZIMRoomJoinedResult({required this.roomInfo});

  ZIMRoomJoinedResult.fromMap(Map<dynamic, dynamic> map)
      : roomInfo = ZIMRoomFullInfo.fromMap(map['roomInfo']);

  Map<String, dynamic> toMap() {
    return {'roomInfo': roomInfo.toMap()};
  }
}

/// todo
///
/// - [roomInfo] Room information.
class ZIMRoomEnteredResult {
  /// Room information.
  ZIMRoomFullInfo roomInfo;

  ZIMRoomEnteredResult({required this.roomInfo});

  ZIMRoomEnteredResult.fromMap(Map<dynamic, dynamic> map)
      : roomInfo = ZIMRoomFullInfo.fromMap(map['roomInfo']);

  Map<String, dynamic> toMap() {
    return {'roomInfo': roomInfo.toMap()};
  }
}

/// todo
///
/// - [roomInfo] Room information.
class ZIMRoomSwitchedResult {
  /// Room information.
  ZIMRoomFullInfo roomInfo;

  ZIMRoomSwitchedResult({required this.roomInfo});

  ZIMRoomSwitchedResult.fromMap(Map<dynamic, dynamic> map)
      : roomInfo = ZIMRoomFullInfo.fromMap(map['roomInfo']);

  Map<String, dynamic> toMap() {
    return {'roomInfo': roomInfo.toMap()};
  }
}

/// todo
///
/// - [roomID] Room ID.
class ZIMRoomLeftResult {
  /// Room ID.
  String roomID;

  ZIMRoomLeftResult({required this.roomID});

  ZIMRoomLeftResult.fromMap(Map<dynamic, dynamic> map)
      : roomID = map['roomID']!;

  Map<String, dynamic> toMap() {
    return {'roomID': roomID};
  }
}

/// todo
///
/// - [roomIDs] Room ID list.
class ZIMRoomAllLeftResult {
  /// Room ID list.
  List<String> roomIDs;

  ZIMRoomAllLeftResult({required this.roomIDs});

  ZIMRoomAllLeftResult.fromMap(Map<dynamic, dynamic> map)
      : roomIDs = ((map['roomIDs']!) as List)
            .map<String>((item) => item as String)
            .toList();

  Map<String, dynamic> toMap() {
    return {'roomIDs': roomIDs};
  }
}

/// todo
///
/// - [roomID] Room ID.
/// - [memberList] Room member list.
/// - [nextFlag] Used to query the next page. The current value returns an empty string, which means that the list has been pulled out.
class ZIMRoomMemberQueriedResult {
  /// Room ID.
  String roomID;

  /// Room member list.
  List<ZIMUserInfo> memberList;

  /// Used to query the next page. The current value returns an empty string, which means that the list has been pulled out.
  String nextFlag;

  ZIMRoomMemberQueriedResult({
    required this.roomID,
    required this.memberList,
    required this.nextFlag,
  });

  ZIMRoomMemberQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : roomID = map['roomID']!,
        memberList = ((map['memberList']!) as List)
            .map<ZIMUserInfo>(
              (item) => ZIMDataUtils.parseZIMUserInfoFromMap(item),
            )
            .toList(),
        nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'roomID': roomID,
      'memberList': memberList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// todo
///
/// - [roomID] Room ID.
/// - [memberList] Room member list.
/// - [errorUserList] Error member list.
class ZIMRoomMembersQueriedResult {
  /// Room ID.
  String roomID;

  /// Room member list.
  List<ZIMRoomMemberInfo> memberList;

  /// Error member list.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMRoomMembersQueriedResult({
    required this.roomID,
    required this.memberList,
    required this.errorUserList,
  });

  ZIMRoomMembersQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : roomID = map['roomID']!,
        memberList = ((map['memberList']!) as List)
            .map<ZIMRoomMemberInfo>((item) => ZIMRoomMemberInfo.fromMap(item))
            .toList(),
        errorUserList = ((map['errorUserList']!) as List)
            .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'roomID': roomID,
      'memberList': memberList.map((item) => item.toMap()).toList(),
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [roomID] Room ID.
/// - [count] Online member count.
class ZIMRoomOnlineMemberCountQueriedResult {
  /// Room ID.
  String roomID;

  /// Online member count.
  int count;

  ZIMRoomOnlineMemberCountQueriedResult({
    required this.roomID,
    required this.count,
  });

  ZIMRoomOnlineMemberCountQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : roomID = map['roomID']!,
        count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'roomID': roomID, 'count': count};
  }
}

/// todo
///
/// - [roomID] Room ID.
/// - [errorKeys] Error key list.
class ZIMRoomAttributesOperatedCallResult {
  /// Room ID.
  String roomID;

  /// Error key list.
  List<String> errorKeys;

  ZIMRoomAttributesOperatedCallResult({
    required this.roomID,
    required this.errorKeys,
  });

  ZIMRoomAttributesOperatedCallResult.fromMap(Map<dynamic, dynamic> map)
      : roomID = map['roomID']!,
        errorKeys = ((map['errorKeys']!) as List)
            .map<String>((item) => item as String)
            .toList();

  Map<String, dynamic> toMap() {
    return {'roomID': roomID, 'errorKeys': errorKeys};
  }
}

/// todo
///
/// - [roomID] Room ID.
class ZIMRoomAttributesBatchOperatedResult {
  /// Room ID.
  String roomID;

  ZIMRoomAttributesBatchOperatedResult({required this.roomID});

  ZIMRoomAttributesBatchOperatedResult.fromMap(Map<dynamic, dynamic> map)
      : roomID = map['roomID']!;

  Map<String, dynamic> toMap() {
    return {'roomID': roomID};
  }
}

/// todo
///
/// - [roomID] Room ID.
/// - [roomAttributes] Room attributes.
class ZIMRoomAttributesQueriedResult {
  /// Room ID.
  String roomID;

  /// Room attributes.
  Map<String, String> roomAttributes;

  ZIMRoomAttributesQueriedResult({
    required this.roomID,
    required this.roomAttributes,
  });

  ZIMRoomAttributesQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : roomID = map['roomID']!,
        roomAttributes = ((map['roomAttributes']!) as Map).map<String, String>(
          (k, v) => MapEntry(k.toString(), v.toString()),
        );

  Map<String, dynamic> toMap() {
    return {'roomID': roomID, 'roomAttributes': roomAttributes};
  }
}

/// todo
///
/// - [roomID] Room ID.
/// - [infos] Room member attribute operation information list.
/// - [errorUserList] Error member list.
class ZIMRoomMembersAttributesOperatedResult {
  /// Room ID.
  String roomID;

  /// Room member attribute operation information list.
  List<ZIMRoomMemberAttributesOperatedInfo> infos;

  /// Error member list.
  List<String> errorUserList;

  ZIMRoomMembersAttributesOperatedResult({
    required this.roomID,
    required this.infos,
    required this.errorUserList,
  });

  ZIMRoomMembersAttributesOperatedResult.fromMap(Map<dynamic, dynamic> map)
      : roomID = map['roomID']!,
        infos = ((map['infos']!) as List)
            .map<ZIMRoomMemberAttributesOperatedInfo>(
              (item) => ZIMRoomMemberAttributesOperatedInfo.fromMap(item),
            )
            .toList(),
        errorUserList = ((map['errorUserList']!) as List)
            .map<String>((item) => item as String)
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'roomID': roomID,
      'infos': infos.map((item) => item.toMap()).toList(),
      'errorUserList': errorUserList,
    };
  }
}

/// todo
///
/// - [roomID] Room ID.
/// - [infos] Room member attribute information list.
class ZIMRoomMembersAttributesQueriedResult {
  /// Room ID.
  String roomID;

  /// Room member attribute information list.
  List<ZIMRoomMemberAttributesInfo> infos;

  ZIMRoomMembersAttributesQueriedResult({
    required this.roomID,
    required this.infos,
  });

  ZIMRoomMembersAttributesQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : roomID = map['roomID']!,
        infos = ((map['infos']!) as List)
            .map<ZIMRoomMemberAttributesInfo>(
              (item) => ZIMRoomMemberAttributesInfo.fromMap(item),
            )
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'roomID': roomID,
      'infos': infos.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [roomID] Room ID.
/// - [infos] Room member attribute information list.
/// - [nextFlag] Used to query the next page. The current value returns 0, which means that the list has been pulled out.
class ZIMRoomMemberAttributesListQueriedResult {
  /// Room ID.
  String roomID;

  /// Room member attribute information list.
  List<ZIMRoomMemberAttributesInfo> infos;

  /// Used to query the next page. The current value returns 0, which means that the list has been pulled out.
  String nextFlag;

  ZIMRoomMemberAttributesListQueriedResult({
    required this.roomID,
    required this.infos,
    required this.nextFlag,
  });

  ZIMRoomMemberAttributesListQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : roomID = map['roomID']!,
        infos = ((map['infos']!) as List)
            .map<ZIMRoomMemberAttributesInfo>(
              (item) => ZIMRoomMemberAttributesInfo.fromMap(item),
            )
            .toList(),
        nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'roomID': roomID,
      'infos': infos.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// todo
///
/// - [groupInfo] Group information.
/// - [userList] Group member information list.
/// - [errorUserList] Error member list.
class ZIMGroupCreatedResult {
  /// Group information.
  ZIMGroupFullInfo groupInfo;

  /// Group member information list.
  List<ZIMGroupMemberInfo> userList;

  /// Error member list.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMGroupCreatedResult({
    required this.groupInfo,
    required this.userList,
    required this.errorUserList,
  });

  ZIMGroupCreatedResult.fromMap(Map<dynamic, dynamic> map)
      : groupInfo = ZIMGroupFullInfo.fromMap(map['groupInfo']),
        userList = ((map['userList']!) as List)
            .map<ZIMGroupMemberInfo>((item) => ZIMGroupMemberInfo.fromMap(item))
            .toList(),
        errorUserList = ((map['errorUserList']!) as List)
            .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'groupInfo': groupInfo.toMap(),
      'userList': userList.map((item) => item.toMap()).toList(),
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [groupID] Group ID.
class ZIMGroupDismissedResult {
  /// Group ID.
  String groupID;

  ZIMGroupDismissedResult({required this.groupID});

  ZIMGroupDismissedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID};
  }
}

/// todo
///
/// - [groupInfo] Group information.
class ZIMGroupJoinedResult {
  /// Group information.
  ZIMGroupFullInfo groupInfo;

  ZIMGroupJoinedResult({required this.groupInfo});

  ZIMGroupJoinedResult.fromMap(Map<dynamic, dynamic> map)
      : groupInfo = ZIMGroupFullInfo.fromMap(map['groupInfo']);

  Map<String, dynamic> toMap() {
    return {'groupInfo': groupInfo.toMap()};
  }
}

/// todo
///
/// - [groupID] Group ID.
class ZIMGroupLeftResult {
  /// Group ID.
  String groupID;

  ZIMGroupLeftResult({required this.groupID});

  ZIMGroupLeftResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID};
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [userList] Group member information list.
/// - [errorUserList] Error member list.
class ZIMGroupUsersInvitedResult {
  /// Group ID.
  String groupID;

  /// Group member information list.
  List<ZIMGroupMemberInfo> userList;

  /// Error member list.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMGroupUsersInvitedResult({
    required this.groupID,
    required this.userList,
    required this.errorUserList,
  });

  ZIMGroupUsersInvitedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        userList = ((map['userList']!) as List)
            .map<ZIMGroupMemberInfo>((item) => ZIMGroupMemberInfo.fromMap(item))
            .toList(),
        errorUserList = ((map['errorUserList']!) as List)
            .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'userList': userList.map((item) => item.toMap()).toList(),
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [kickedUserIDList] List of user IDs kicked out.
/// - [errorUserList] Error member list.
class ZIMGroupMemberKickedResult {
  /// Group ID.
  String groupID;

  /// List of user IDs kicked out.
  List<String> kickedUserIDList;

  /// Error member list.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMGroupMemberKickedResult({
    required this.groupID,
    required this.kickedUserIDList,
    required this.errorUserList,
  });

  ZIMGroupMemberKickedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        kickedUserIDList = ((map['kickedUserIDList']!) as List)
            .map<String>((item) => item as String)
            .toList(),
        errorUserList = ((map['errorUserList']!) as List)
            .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'kickedUserIDList': kickedUserIDList,
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [toUserID] New group owner user ID.
class ZIMGroupOwnerTransferredResult {
  /// Group ID.
  String groupID;

  /// New group owner user ID.
  String toUserID;

  ZIMGroupOwnerTransferredResult({
    required this.groupID,
    required this.toUserID,
  });

  ZIMGroupOwnerTransferredResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        toUserID = map['toUserID']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'toUserID': toUserID};
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [groupName] Group name.
class ZIMGroupNameUpdatedResult {
  /// Group ID.
  String groupID;

  /// Group name.
  String groupName;

  ZIMGroupNameUpdatedResult({required this.groupID, required this.groupName});

  ZIMGroupNameUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        groupName = map['groupName']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'groupName': groupName};
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [groupAvatarUrl] Group avatar URL.
class ZIMGroupAvatarUrlUpdatedResult {
  /// Group ID.
  String groupID;

  /// Group avatar URL.
  String groupAvatarUrl;

  ZIMGroupAvatarUrlUpdatedResult({
    required this.groupID,
    required this.groupAvatarUrl,
  });

  ZIMGroupAvatarUrlUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        groupAvatarUrl = map['groupAvatarUrl']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'groupAvatarUrl': groupAvatarUrl};
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [groupNotice] Group notice.
class ZIMGroupNoticeUpdatedResult {
  /// Group ID.
  String groupID;

  /// Group notice.
  String groupNotice;

  ZIMGroupNoticeUpdatedResult({
    required this.groupID,
    required this.groupNotice,
  });

  ZIMGroupNoticeUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        groupNotice = map['groupNotice']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'groupNotice': groupNotice};
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [groupAlias] Group alias.
class ZIMGroupAliasUpdatedResult {
  /// Group ID.
  String groupID;

  /// Group alias.
  String groupAlias;

  ZIMGroupAliasUpdatedResult({required this.groupID, required this.groupAlias});

  ZIMGroupAliasUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        groupAlias = map['groupAlias']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'groupAlias': groupAlias};
  }
}

/// todo
///
/// - [groupInfo] Group information.
class ZIMGroupInfoQueriedResult {
  /// Group information.
  ZIMGroupFullInfo groupInfo;

  ZIMGroupInfoQueriedResult({required this.groupInfo});

  ZIMGroupInfoQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : groupInfo = ZIMGroupFullInfo.fromMap(map['groupInfo']);

  Map<String, dynamic> toMap() {
    return {'groupInfo': groupInfo.toMap()};
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [errorKeys] Error keys.
class ZIMGroupAttributesOperatedResult {
  /// Group ID.
  String groupID;

  /// Error keys.
  List<String> errorKeys;

  ZIMGroupAttributesOperatedResult({
    required this.groupID,
    required this.errorKeys,
  });

  ZIMGroupAttributesOperatedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        errorKeys = ((map['errorKeys']!) as List)
            .map<String>((item) => item as String)
            .toList();

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'errorKeys': errorKeys};
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [groupAttributes] Group attributes.
class ZIMGroupAttributesQueriedResult {
  /// Group ID.
  String groupID;

  /// Group attributes.
  Map<String, String> groupAttributes;

  ZIMGroupAttributesQueriedResult({
    required this.groupID,
    required this.groupAttributes,
  });

  ZIMGroupAttributesQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        groupAttributes =
            ((map['groupAttributes']!) as Map).map<String, String>(
          (k, v) => MapEntry(k.toString(), v.toString()),
        );

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'groupAttributes': groupAttributes};
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [forUserID] User ID.
/// - [role] User role.
class ZIMGroupMemberRoleUpdatedResult {
  /// Group ID.
  String groupID;

  /// User ID.
  String forUserID;

  /// User role.
  int role;

  ZIMGroupMemberRoleUpdatedResult({
    required this.groupID,
    required this.forUserID,
    required this.role,
  });

  ZIMGroupMemberRoleUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        forUserID = map['forUserID']!,
        role = map['role']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'forUserID': forUserID, 'role': role};
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [forUserID] User ID.
/// - [nickname] User nickname.
class ZIMGroupMemberNicknameUpdatedResult {
  /// Group ID.
  String groupID;

  /// User ID.
  String forUserID;

  /// User nickname.
  String nickname;

  ZIMGroupMemberNicknameUpdatedResult({
    required this.groupID,
    required this.forUserID,
    required this.nickname,
  });

  ZIMGroupMemberNicknameUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        forUserID = map['forUserID']!,
        nickname = map['nickname']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'forUserID': forUserID, 'nickname': nickname};
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [userInfo] Group member user information.
class ZIMGroupMemberInfoQueriedResult {
  /// Group ID.
  String groupID;

  /// Group member user information.
  ZIMGroupMemberInfo userInfo;

  ZIMGroupMemberInfoQueriedResult({
    required this.groupID,
    required this.userInfo,
  });

  ZIMGroupMemberInfoQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        userInfo = ZIMGroupMemberInfo.fromMap(map['userInfo']);

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'userInfo': userInfo.toMap()};
  }
}

/// todo
///
/// - [groupList] Group list.
/// - [nextFlag] The pagination anchor returned by the SDK is 0 if it means the list has been completely queried, and non-0 if it means there is still data to be queried.
class ZIMGroupListQueriedResult {
  /// Group list.
  List<ZIMGroup> groupList;

  /// The pagination anchor returned by the SDK is 0 if it means the list has been completely queried, and non-0 if it means there is still data to be queried.
  int nextFlag;

  ZIMGroupListQueriedResult({required this.groupList, required this.nextFlag});

  ZIMGroupListQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : groupList = ((map['groupList']!) as List)
            .map<ZIMGroup>((item) => ZIMGroup.fromMap(item))
            .toList(),
        nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'groupList': groupList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [userList] Group member list.
/// - [nextFlag] Used to query the next page. The current value returns 0, which means that the list has been pulled out.
class ZIMGroupMemberListQueriedResult {
  /// Group ID.
  String groupID;

  /// Group member list.
  List<ZIMGroupMemberInfo> userList;

  /// Used to query the next page. The current value returns 0, which means that the list has been pulled out.
  int nextFlag;

  ZIMGroupMemberListQueriedResult({
    required this.groupID,
    required this.userList,
    required this.nextFlag,
  });

  ZIMGroupMemberListQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        userList = ((map['userList']!) as List)
            .map<ZIMGroupMemberInfo>((item) => ZIMGroupMemberInfo.fromMap(item))
            .toList(),
        nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'userList': userList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [count] Group member count.
class ZIMGroupMemberCountQueriedResult {
  /// Group ID.
  String groupID;

  /// Group member count.
  int count;

  ZIMGroupMemberCountQueriedResult({
    required this.groupID,
    required this.count,
  });

  ZIMGroupMemberCountQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        count = map['count']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'count': count};
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [userList] Group member list.
/// - [nextFlag] Used to query the next page. The current value returns 0, which means that the list has been pulled out.
class ZIMGroupMessageReceiptMemberListQueriedResult {
  /// Group ID.
  String groupID;

  /// Group member list.
  List<ZIMGroupMemberInfo> userList;

  /// Used to query the next page. The current value returns 0, which means that the list has been pulled out.
  int nextFlag;

  ZIMGroupMessageReceiptMemberListQueriedResult({
    required this.groupID,
    required this.userList,
    required this.nextFlag,
  });

  ZIMGroupMessageReceiptMemberListQueriedResult.fromMap(
    Map<dynamic, dynamic> map,
  )   : groupID = map['groupID']!,
        userList = ((map['userList']!) as List)
            .map<ZIMGroupMemberInfo>((item) => ZIMGroupMemberInfo.fromMap(item))
            .toList(),
        nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'userList': userList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [isMute] Whether to mute.
/// - [mutedInfo] Group mute information.
class ZIMGroupMutedResult {
  /// Group ID.
  String groupID;

  /// Whether to mute.
  bool isMute;

  /// Group mute information.
  ZIMGroupMuteInfo mutedInfo;

  ZIMGroupMutedResult({
    required this.groupID,
    required this.isMute,
    required this.mutedInfo,
  });

  ZIMGroupMutedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        isMute = map['isMute']!,
        mutedInfo = ZIMGroupMuteInfo.fromMap(map['mutedInfo']);

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'isMute': isMute,
      'mutedInfo': mutedInfo.toMap(),
    };
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [isMute] Whether to mute.
/// - [duration] Mute duration.
/// - [mutedMemberIDs] List of muted member IDs.
/// - [errorUserList] List of user information that failed to be muted.
class ZIMGroupMembersMutedResult {
  /// Group ID.
  String groupID;

  /// Whether to mute.
  bool isMute;

  /// Mute duration.
  int duration;

  /// List of muted member IDs.
  List<String> mutedMemberIDs;

  /// List of user information that failed to be muted.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMGroupMembersMutedResult({
    required this.groupID,
    required this.isMute,
    required this.duration,
    required this.mutedMemberIDs,
    required this.errorUserList,
  });

  ZIMGroupMembersMutedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        isMute = map['isMute']!,
        duration = map['duration']!,
        mutedMemberIDs = ((map['mutedMemberIDs']!) as List)
            .map<String>((item) => item as String)
            .toList(),
        errorUserList = ((map['errorUserList']!) as List)
            .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'isMute': isMute,
      'duration': duration,
      'mutedMemberIDs': mutedMemberIDs,
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [nextFlag] Used to query the next page. The current value returns 0, which means that the list has been pulled out.
/// - [userList] Group member list.
class ZIMGroupMemberMutedListQueriedResult {
  /// Group ID.
  String groupID;

  /// Used to query the next page. The current value returns 0, which means that the list has been pulled out.
  int nextFlag;

  /// Group member list.
  List<ZIMGroupMemberInfo> userList;

  ZIMGroupMemberMutedListQueriedResult({
    required this.groupID,
    required this.nextFlag,
    required this.userList,
  });

  ZIMGroupMemberMutedListQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        nextFlag = map['nextFlag']!,
        userList = ((map['userList']!) as List)
            .map<ZIMGroupMemberInfo>((item) => ZIMGroupMemberInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'nextFlag': nextFlag,
      'userList': userList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [groupSearchInfoList] Group search information list.
/// - [nextFlag] Used to query the next page. The current value returns 0, which means that the list has been pulled out.
class ZIMGroupsSearchedResult {
  /// Group search information list.
  List<ZIMGroupSearchInfo> groupSearchInfoList;

  /// Used to query the next page. The current value returns 0, which means that the list has been pulled out.
  int nextFlag;

  ZIMGroupsSearchedResult({
    required this.groupSearchInfoList,
    required this.nextFlag,
  });

  ZIMGroupsSearchedResult.fromMap(Map<dynamic, dynamic> map)
      : groupSearchInfoList = ((map['groupSearchInfoList']!) as List)
            .map<ZIMGroupSearchInfo>((item) => ZIMGroupSearchInfo.fromMap(item))
            .toList(),
        nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'groupSearchInfoList':
          groupSearchInfoList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [userList] Group member list.
/// - [nextFlag] Used to query the next page. The current value returns 0, which means that the list has been pulled out.
class ZIMGroupMembersSearchedResult {
  /// Group ID.
  String groupID;

  /// Group member list.
  List<ZIMGroupMemberInfo> userList;

  /// Used to query the next page. The current value returns 0, which means that the list has been pulled out.
  int nextFlag;

  ZIMGroupMembersSearchedResult({
    required this.groupID,
    required this.userList,
    required this.nextFlag,
  });

  ZIMGroupMembersSearchedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        userList = ((map['userList']!) as List)
            .map<ZIMGroupMemberInfo>((item) => ZIMGroupMemberInfo.fromMap(item))
            .toList(),
        nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'userList': userList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [mode] Group join mode.
class ZIMGroupJoinModeUpdatedResult {
  /// Group ID.
  String groupID;

  /// Group join mode.
  ZIMGroupJoinMode mode;

  ZIMGroupJoinModeUpdatedResult({required this.groupID, required this.mode});

  ZIMGroupJoinModeUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        mode = ZIMGroupJoinModeExtension.mapValue[map['mode']] ??
            ZIMGroupJoinMode.any;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'mode': mode.value};
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [mode] Group invite mode.
class ZIMGroupInviteModeUpdatedResult {
  /// Group ID.
  String groupID;

  /// Group invite mode.
  ZIMGroupInviteMode mode;

  ZIMGroupInviteModeUpdatedResult({required this.groupID, required this.mode});

  ZIMGroupInviteModeUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        mode = ZIMGroupInviteModeExtension.mapValue[map['mode']] ??
            ZIMGroupInviteMode.any;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'mode': mode.value};
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [mode] Group be invite mode.
class ZIMGroupBeInviteModeUpdatedResult {
  /// Group ID.
  String groupID;

  /// Group be invite mode.
  ZIMGroupBeInviteMode mode;

  ZIMGroupBeInviteModeUpdatedResult({
    required this.groupID,
    required this.mode,
  });

  ZIMGroupBeInviteModeUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        mode = ZIMGroupBeInviteModeExtension.mapValue[map['mode']] ??
            ZIMGroupBeInviteMode.none;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'mode': mode.value};
  }
}

/// todo
///
/// - [groupID] Group ID.
class ZIMGroupJoinApplicationSentResult {
  /// Group ID.
  String groupID;

  ZIMGroupJoinApplicationSentResult({required this.groupID});

  ZIMGroupJoinApplicationSentResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID};
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [userID] User ID.
class ZIMGroupJoinApplicationAcceptedResult {
  /// Group ID.
  String groupID;

  /// User ID.
  String userID;

  ZIMGroupJoinApplicationAcceptedResult({
    required this.groupID,
    required this.userID,
  });

  ZIMGroupJoinApplicationAcceptedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        userID = map['userID']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'userID': userID};
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [userID] User ID.
class ZIMGroupJoinApplicationRejectedResult {
  /// Group ID.
  String groupID;

  /// User ID.
  String userID;

  ZIMGroupJoinApplicationRejectedResult({
    required this.groupID,
    required this.userID,
  });

  ZIMGroupJoinApplicationRejectedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        userID = map['userID']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'userID': userID};
  }
}

/// todo
///
/// - [groupID] Group ID.
/// - [errorUserList] Invite failed user information list.
class ZIMGroupInviteApplicationsSentResult {
  /// Group ID.
  String groupID;

  /// Invite failed user information list.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMGroupInviteApplicationsSentResult({
    required this.groupID,
    required this.errorUserList,
  });

  ZIMGroupInviteApplicationsSentResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        errorUserList = ((map['errorUserList']!) as List)
            .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [groupInfo] Group information.
/// - [inviterUserID] Inviter user ID.
class ZIMGroupInviteApplicationAcceptedResult {
  /// Group information.
  ZIMGroupFullInfo groupInfo;

  /// Inviter user ID.
  String inviterUserID;

  ZIMGroupInviteApplicationAcceptedResult({
    required this.groupInfo,
    required this.inviterUserID,
  });

  ZIMGroupInviteApplicationAcceptedResult.fromMap(Map<dynamic, dynamic> map)
      : groupInfo = ZIMGroupFullInfo.fromMap(map['groupInfo']),
        inviterUserID = map['inviterUserID']!;

  Map<String, dynamic> toMap() {
    return {'groupInfo': groupInfo.toMap(), 'inviterUserID': inviterUserID};
  }
}

/// todo
///
/// - [groupID] Group information.
/// - [inviterUserID] Inviter user ID.
class ZIMGroupInviteApplicationRejectedResult {
  /// Group information.
  String groupID;

  /// Inviter user ID.
  String inviterUserID;

  ZIMGroupInviteApplicationRejectedResult({
    required this.groupID,
    required this.inviterUserID,
  });

  ZIMGroupInviteApplicationRejectedResult.fromMap(Map<dynamic, dynamic> map)
      : groupID = map['groupID']!,
        inviterUserID = map['inviterUserID']!;

  Map<String, dynamic> toMap() {
    return {'groupID': groupID, 'inviterUserID': inviterUserID};
  }
}

/// todo
///
/// - [applicationList] Group application information list.
/// - [nextFlag] Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
class ZIMGroupApplicationListQueriedResult {
  /// Group application information list.
  List<ZIMGroupApplicationInfo> applicationList;

  /// Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
  int nextFlag;

  ZIMGroupApplicationListQueriedResult({
    required this.applicationList,
    required this.nextFlag,
  });

  ZIMGroupApplicationListQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : applicationList = ((map['applicationList']!) as List)
            .map<ZIMGroupApplicationInfo>(
              (item) => ZIMGroupApplicationInfo.fromMap(item),
            )
            .toList(),
        nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'applicationList': applicationList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// todo
///
/// - [callID] Call ID.
/// - [info] Call invitation information.
class ZIMCallInvitationSentResult {
  /// Call ID.
  String callID;

  /// Call invitation information.
  ZIMCallInvitationSentInfo info;

  ZIMCallInvitationSentResult({required this.callID, required this.info});

  ZIMCallInvitationSentResult.fromMap(Map<dynamic, dynamic> map)
      : callID = map['callID']!,
        info = ZIMCallInvitationSentInfo.fromMap(map['info']);

  Map<String, dynamic> toMap() {
    return {'callID': callID, 'info': info.toMap()};
  }
}

/// todo
///
/// - [callID] Call ID.
/// - [info] Calling invitation information.
class ZIMCallingInvitationSentResult {
  /// Call ID.
  String callID;

  /// Calling invitation information.
  ZIMCallingInvitationSentInfo info;

  ZIMCallingInvitationSentResult({required this.callID, required this.info});

  ZIMCallingInvitationSentResult.fromMap(Map<dynamic, dynamic> map)
      : callID = map['callID']!,
        info = ZIMCallingInvitationSentInfo.fromMap(map['info']);

  Map<String, dynamic> toMap() {
    return {'callID': callID, 'info': info.toMap()};
  }
}

/// todo
///
/// - [callID] Call ID.
/// - [errorInvitees] Call invitation failed user ID list.
class ZIMCallCancelSentResult {
  /// Call ID.
  String callID;

  /// Call invitation failed user ID list.
  List<String> errorInvitees;

  ZIMCallCancelSentResult({required this.callID, required this.errorInvitees});

  ZIMCallCancelSentResult.fromMap(Map<dynamic, dynamic> map)
      : callID = map['callID']!,
        errorInvitees = ((map['errorInvitees']!) as List)
            .map<String>((item) => item as String)
            .toList();

  Map<String, dynamic> toMap() {
    return {'callID': callID, 'errorInvitees': errorInvitees};
  }
}

/// todo
///
/// - [callID] Call ID.
class ZIMCallAcceptanceSentResult {
  /// Call ID.
  String callID;

  ZIMCallAcceptanceSentResult({required this.callID});

  ZIMCallAcceptanceSentResult.fromMap(Map<dynamic, dynamic> map)
      : callID = map['callID']!;

  Map<String, dynamic> toMap() {
    return {'callID': callID};
  }
}

/// todo
///
/// - [callID] Call ID.
class ZIMCallRejectionSentResult {
  /// Call ID.
  String callID;

  ZIMCallRejectionSentResult({required this.callID});

  ZIMCallRejectionSentResult.fromMap(Map<dynamic, dynamic> map)
      : callID = map['callID']!;

  Map<String, dynamic> toMap() {
    return {'callID': callID};
  }
}

/// todo
///
/// - [callID] Call ID.
/// - [info] Call join information.
class ZIMCallJoinSentResult {
  /// Call ID.
  String callID;

  /// Call join information.
  ZIMCallJoinSentInfo info;

  ZIMCallJoinSentResult({required this.callID, required this.info});

  ZIMCallJoinSentResult.fromMap(Map<dynamic, dynamic> map)
      : callID = map['callID']!,
        info = ZIMCallJoinSentInfo.fromMap(map['info']);

  Map<String, dynamic> toMap() {
    return {'callID': callID, 'info': info.toMap()};
  }
}

/// todo
///
/// - [callID] Call ID.
/// - [info] Call quit information.
class ZIMCallQuitSentResult {
  /// Call ID.
  String callID;

  /// Call quit information.
  ZIMCallQuitSentInfo info;

  ZIMCallQuitSentResult({required this.callID, required this.info});

  ZIMCallQuitSentResult.fromMap(Map<dynamic, dynamic> map)
      : callID = map['callID']!,
        info = ZIMCallQuitSentInfo.fromMap(map['info']);

  Map<String, dynamic> toMap() {
    return {'callID': callID, 'info': info.toMap()};
  }
}

/// todo
///
/// - [callID] Call ID.
/// - [info] Call end information.
class ZIMCallEndSentResult {
  /// Call ID.
  String callID;

  /// Call end information.
  ZIMCallEndedSentInfo info;

  ZIMCallEndSentResult({required this.callID, required this.info});

  ZIMCallEndSentResult.fromMap(Map<dynamic, dynamic> map)
      : callID = map['callID']!,
        info = ZIMCallEndedSentInfo.fromMap(map['info']);

  Map<String, dynamic> toMap() {
    return {'callID': callID, 'info': info.toMap()};
  }
}

/// todo
///
/// - [callList] Call information list.
/// - [nextFlag] Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
class ZIMCallInvitationListQueriedResult {
  /// Call information list.
  List<ZIMCallInfo> callList;

  /// Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
  int nextFlag;

  ZIMCallInvitationListQueriedResult({
    required this.callList,
    required this.nextFlag,
  });

  ZIMCallInvitationListQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : callList = ((map['callList']!) as List)
            .map<ZIMCallInfo>((item) => ZIMCallInfo.fromMap(item))
            .toList(),
        nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'callList': callList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// todo
///
/// - [friendInfo] Friend information.
class ZIMFriendAddedResult {
  /// Friend information.
  ZIMFriendInfo friendInfo;

  ZIMFriendAddedResult({required this.friendInfo});

  ZIMFriendAddedResult.fromMap(Map<dynamic, dynamic> map)
      : friendInfo = ZIMFriendInfo.fromMap(map['friendInfo']);

  Map<String, dynamic> toMap() {
    return {'friendInfo': friendInfo.toMap()};
  }
}

/// todo
///
/// - [errorUserList] Friend information.
class ZIMFriendsDeletedResult {
  /// Friend information.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMFriendsDeletedResult({required this.errorUserList});

  ZIMFriendsDeletedResult.fromMap(Map<dynamic, dynamic> map)
      : errorUserList = ((map['errorUserList']!) as List)
            .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [friendList] Friend information list.
/// - [nextFlag] Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
class ZIMFriendListQueriedResult {
  /// Friend information list.
  List<ZIMFriendInfo> friendList;

  /// Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
  int nextFlag;

  ZIMFriendListQueriedResult({
    required this.friendList,
    required this.nextFlag,
  });

  ZIMFriendListQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : friendList = ((map['friendList']!) as List)
            .map<ZIMFriendInfo>((item) => ZIMFriendInfo.fromMap(item))
            .toList(),
        nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'friendList': friendList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// todo
///
/// - [friendInfos] Friend information list.
/// - [errorUserList] Friend information.
class ZIMFriendsInfoQueriedResult {
  /// Friend information list.
  List<ZIMFriendInfo> friendInfos;

  /// Friend information.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMFriendsInfoQueriedResult({
    required this.friendInfos,
    required this.errorUserList,
  });

  ZIMFriendsInfoQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : friendInfos = ((map['friendInfos']!) as List)
            .map<ZIMFriendInfo>((item) => ZIMFriendInfo.fromMap(item))
            .toList(),
        errorUserList = ((map['errorUserList']!) as List)
            .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'friendInfos': friendInfos.map((item) => item.toMap()).toList(),
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [relationInfos] Friend relationship information list.
/// - [errorUserList] Friend information.
class ZIMFriendsRelationCheckedResult {
  /// Friend relationship information list.
  List<ZIMFriendRelationInfo> relationInfos;

  /// Friend information.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMFriendsRelationCheckedResult({
    required this.relationInfos,
    required this.errorUserList,
  });

  ZIMFriendsRelationCheckedResult.fromMap(Map<dynamic, dynamic> map)
      : relationInfos = ((map['relationInfos']!) as List)
            .map<ZIMFriendRelationInfo>(
              (item) => ZIMFriendRelationInfo.fromMap(item),
            )
            .toList(),
        errorUserList = ((map['errorUserList']!) as List)
            .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'relationInfos': relationInfos.map((item) => item.toMap()).toList(),
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [applicationInfo] Friend application information.
class ZIMFriendApplicationSentResult {
  /// Friend application information.
  ZIMFriendApplicationInfo applicationInfo;

  ZIMFriendApplicationSentResult({required this.applicationInfo});

  ZIMFriendApplicationSentResult.fromMap(Map<dynamic, dynamic> map)
      : applicationInfo = ZIMFriendApplicationInfo.fromMap(
          map['applicationInfo'],
        );

  Map<String, dynamic> toMap() {
    return {'applicationInfo': applicationInfo.toMap()};
  }
}

/// todo
///
/// - [friendInfo] Friend information.
class ZIMFriendApplicationAcceptedResult {
  /// Friend information.
  ZIMFriendInfo friendInfo;

  ZIMFriendApplicationAcceptedResult({required this.friendInfo});

  ZIMFriendApplicationAcceptedResult.fromMap(Map<dynamic, dynamic> map)
      : friendInfo = ZIMFriendInfo.fromMap(map['friendInfo']);

  Map<String, dynamic> toMap() {
    return {'friendInfo': friendInfo.toMap()};
  }
}

/// todo
///
/// - [userInfo] User information.
class ZIMFriendApplicationRejectedResult {
  /// User information.
  ZIMUserInfo userInfo;

  ZIMFriendApplicationRejectedResult({required this.userInfo});

  ZIMFriendApplicationRejectedResult.fromMap(Map<dynamic, dynamic> map)
      : userInfo = ZIMDataUtils.parseZIMUserInfoFromMap(map['userInfo']);

  Map<String, dynamic> toMap() {
    return {'userInfo': userInfo.toMap()};
  }
}

/// todo
///
/// - [applicationList] Friend application information list.
/// - [nextFlag] Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
class ZIMFriendApplicationListQueriedResult {
  /// Friend application information list.
  List<ZIMFriendApplicationInfo> applicationList;

  /// Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
  int nextFlag;

  ZIMFriendApplicationListQueriedResult({
    required this.applicationList,
    required this.nextFlag,
  });

  ZIMFriendApplicationListQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : applicationList = ((map['applicationList']!) as List)
            .map<ZIMFriendApplicationInfo>(
              (item) => ZIMFriendApplicationInfo.fromMap(item),
            )
            .toList(),
        nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'applicationList': applicationList.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// todo
///
/// - [friendInfo] Friend information.
class ZIMFriendAliasUpdatedResult {
  /// Friend information.
  ZIMFriendInfo friendInfo;

  ZIMFriendAliasUpdatedResult({required this.friendInfo});

  ZIMFriendAliasUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : friendInfo = ZIMFriendInfo.fromMap(map['friendInfo']);

  Map<String, dynamic> toMap() {
    return {'friendInfo': friendInfo.toMap()};
  }
}

/// todo
///
/// - [friendInfo] Friend information.
class ZIMFriendAttributesUpdatedResult {
  /// Friend information.
  ZIMFriendInfo friendInfo;

  ZIMFriendAttributesUpdatedResult({required this.friendInfo});

  ZIMFriendAttributesUpdatedResult.fromMap(Map<dynamic, dynamic> map)
      : friendInfo = ZIMFriendInfo.fromMap(map['friendInfo']);

  Map<String, dynamic> toMap() {
    return {'friendInfo': friendInfo.toMap()};
  }
}

/// todo
///
/// - [friendInfos] Friend information list.
/// - [nextFlag] Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
class ZIMFriendsSearchedResult {
  /// Friend information list.
  List<ZIMFriendInfo> friendInfos;

  /// Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
  int nextFlag;

  ZIMFriendsSearchedResult({required this.friendInfos, required this.nextFlag});

  ZIMFriendsSearchedResult.fromMap(Map<dynamic, dynamic> map)
      : friendInfos = ((map['friendInfos']!) as List)
            .map<ZIMFriendInfo>((item) => ZIMFriendInfo.fromMap(item))
            .toList(),
        nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'friendInfos': friendInfos.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// todo
///
/// - [errorUserList] User information.
class ZIMBlacklistUsersAddedResult {
  /// User information.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMBlacklistUsersAddedResult({required this.errorUserList});

  ZIMBlacklistUsersAddedResult.fromMap(Map<dynamic, dynamic> map)
      : errorUserList = ((map['errorUserList']!) as List)
            .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [errorUserList] User information.
class ZIMBlacklistUsersRemovedResult {
  /// User information.
  List<ZIMErrorUserInfo> errorUserList;

  ZIMBlacklistUsersRemovedResult({required this.errorUserList});

  ZIMBlacklistUsersRemovedResult.fromMap(Map<dynamic, dynamic> map)
      : errorUserList = ((map['errorUserList']!) as List)
            .map<ZIMErrorUserInfo>((item) => ZIMErrorUserInfo.fromMap(item))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'errorUserList': errorUserList.map((item) => item.toMap()).toList(),
    };
  }
}

/// todo
///
/// - [blacklist] Blacklist user information list.
/// - [nextFlag] Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
class ZIMBlacklistQueriedResult {
  /// Blacklist user information list.
  List<ZIMUserInfo> blacklist;

  /// Pagination flag, used to get the next page. The current value returns 0, indicating that all data has been pulled out.
  int nextFlag;

  ZIMBlacklistQueriedResult({required this.blacklist, required this.nextFlag});

  ZIMBlacklistQueriedResult.fromMap(Map<dynamic, dynamic> map)
      : blacklist = ((map['blacklist']!) as List)
            .map<ZIMUserInfo>(
              (item) => ZIMDataUtils.parseZIMUserInfoFromMap(item),
            )
            .toList(),
        nextFlag = map['nextFlag']!;

  Map<String, dynamic> toMap() {
    return {
      'blacklist': blacklist.map((item) => item.toMap()).toList(),
      'nextFlag': nextFlag,
    };
  }
}

/// todo
///
/// - [isUserInBlacklist] Whether in blacklist.
class ZIMBlacklistCheckedResult {
  /// Whether in blacklist.
  bool isUserInBlacklist;

  ZIMBlacklistCheckedResult({required this.isUserInBlacklist});

  ZIMBlacklistCheckedResult.fromMap(Map<dynamic, dynamic> map)
      : isUserInBlacklist = map['isUserInBlacklist']!;

  Map<String, dynamic> toMap() {
    return {'isUserInBlacklist': isUserInBlacklist};
  }
}

/// todo
///
/// - [reactions] Message reaction change info list
/// - [changeInfoList] Message reaction change info list
class ZIMMessageReactionsChangedEventResult {
  /// Message reaction change info list
  List<ZIMMessageReaction> reactions;

  /// Message reaction change info list
  List<ZIMMessageReactionChangeInfo> changeInfoList;

  ZIMMessageReactionsChangedEventResult({
    required this.reactions,
    required this.changeInfoList,
  });

  ZIMMessageReactionsChangedEventResult.fromMap(Map<dynamic, dynamic> map)
      : reactions = ((map['reactions']!) as List)
            .map<ZIMMessageReaction>((item) => ZIMMessageReaction.fromMap(item))
            .toList(),
        changeInfoList = ((map['changeInfoList']!) as List)
            .map<ZIMMessageReactionChangeInfo>(
              (item) => ZIMMessageReactionChangeInfo.fromMap(item),
            )
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'reactions': reactions.map((item) => item.toMap()).toList(),
      'changeInfoList': changeInfoList.map((item) => item.toMap()).toList(),
    };
  }
}
