part of 'package:zego_zim/src/zim_defines.dart';

class ZIMDataUtils {
  static Uint8List convertToUInt8List(dynamic data) {
    Uint8List dataList;
    if (data is Uint8List) {
      dataList = data;
    } else if (data is List) {
      dataList = Uint8List.fromList(data.map<int>((d) => d as int).toList());
    } else if (data is Map) {
      final list = <int>[];
      for (int i = 0; i < data.length; i++) {
        list.add(data[i.toString()]);
      }
      dataList = Uint8List.fromList(list);
    } else {
      dataList = Uint8List(0);
    }

    return dataList;
  }

  static ZIMConversation parseZIMConversationFromMap(Map map) {
    ZIMConversationType type =
        ZIMConversationTypeExtension.mapValue[map['type']] ??
            ZIMConversationType.unknown;
    ZIMConversation? conversation;
    switch (type) {
      case ZIMConversationType.group:
        conversation = ZIMGroupConversation.fromMap(map);
        break;
      case ZIMConversationType.peer:
      default:
        conversation = ZIMConversation.fromMap(map);
        break;
    }

    return conversation;
  }

  static ZIMMessage parseZIMMessageFromMap(Map map) {
    map['cbInnerID'] ??= '';
    map['localExtendedData'] ??= '';

    ZIMMessageType type =
        ZIMMessageTypeExtension.mapValue[map['type']] ?? ZIMMessageType.unknown;
    ZIMMessage? message;
    switch (type) {
      case ZIMMessageType.system:
        message = ZIMSystemMessage.fromMap(map);
        break;
      case ZIMMessageType.command:
        message = ZIMCommandMessage.fromMap(map);
        break;
      case ZIMMessageType.barrage:
        message = ZIMBarrageMessage.fromMap(map);
        break;
      case ZIMMessageType.text:
        message = ZIMTextMessage.fromMap(map);
        break;
      case ZIMMessageType.custom:
        message = ZIMCustomMessage.fromMap(map);
        break;
      case ZIMMessageType.combine:
        message = ZIMCombineMessage.fromMap(map);
        break;
      case ZIMMessageType.multiple:
        message = ZIMMultipleMessage.fromMap(map);
        break;
      case ZIMMessageType.image:
        map['fileLocalPath'] ??= '';
        map['thumbnailLocalPath'] ??= '';
        map['largeImageLocalPath'] ??= '';
        message = ZIMImageMessage.fromMap(map);
        break;
      case ZIMMessageType.file:
        map['fileLocalPath'] ??= '';
        message = ZIMFileMessage.fromMap(map);
        break;
      case ZIMMessageType.audio:
        map['fileLocalPath'] ??= '';
        message = ZIMAudioMessage.fromMap(map);
        break;
      case ZIMMessageType.video:
        map['fileLocalPath'] ??= '';
        map['videoFirstFrameLocalPath'] ??= '';
        message = ZIMVideoMessage.fromMap(map);
        break;
      case ZIMMessageType.revoke:
        message = ZIMRevokeMessage.fromMap(map);
        break;
      case ZIMMessageType.tips:
        message = ZIMTipsMessage.fromMap(map);
        break;
      case ZIMMessageType.unknown:
      default:
        message = ZIMMessage.fromMap(map);
        break;
    }

    return message;
  }

  static ZIMMessageLiteInfo parseZIMMessageLiteInfoFromMap(Map map) {
    ZIMMessageType type =
        ZIMMessageTypeExtension.mapValue[map['type']] ?? ZIMMessageType.unknown;
    ZIMMessageLiteInfo? liteInfo;
    switch (type) {
      case ZIMMessageType.text:
        liteInfo = ZIMTextMessageLiteInfo.fromMap(map);
        break;
      case ZIMMessageType.custom:
        liteInfo = ZIMCustomMessageLiteInfo.fromMap(map);
        break;
      case ZIMMessageType.combine:
        liteInfo = ZIMCombineMessageLiteInfo.fromMap(map);
        break;
      case ZIMMessageType.multiple:
        liteInfo = ZIMMultipleMessageLiteInfo.fromMap(map);
        break;
      case ZIMMessageType.image:
        map['fileLocalPath'] ??= '';
        map['thumbnailLocalPath'] ??= '';
        map['largeImageLocalPath'] ??= '';
        liteInfo = ZIMImageMessageLiteInfo.fromMap(map);
        break;
      case ZIMMessageType.file:
        map['fileLocalPath'] ??= '';
        liteInfo = ZIMFileMessageLiteInfo.fromMap(map);
        break;
      case ZIMMessageType.audio:
        map['fileLocalPath'] ??= '';
        liteInfo = ZIMAudioMessageLiteInfo.fromMap(map);
        break;
      case ZIMMessageType.video:
        map['fileLocalPath'] ??= '';
        map['videoFirstFrameLocalPath'] ??= '';
        liteInfo = ZIMVideoMessageLiteInfo.fromMap(map);
        break;
      case ZIMMessageType.revoke:
        liteInfo = ZIMRevokeMessageLiteInfo.fromMap(map);
        break;
      case ZIMMessageType.unknown:
      default:
        liteInfo = ZIMMessageLiteInfo.fromMap(map);
        break;
    }

    return liteInfo;
  }

  static ZIMTipsMessageChangeInfo parseZIMTipsMessageChangeInfoFromMap(
      Map map) {
    ZIMTipsMessageChangeInfoType type =
        ZIMTipsMessageChangeInfoTypeExtension.mapValue[map['type']] ??
            ZIMTipsMessageChangeInfoType.unknown;
    ZIMTipsMessageChangeInfo? changeInfo;
    switch (type) {
      case ZIMTipsMessageChangeInfoType.groupDataChanged:
      case ZIMTipsMessageChangeInfoType.groupNoticeChanged:
      case ZIMTipsMessageChangeInfoType.groupNameChanged:
      case ZIMTipsMessageChangeInfoType.groupAvatarUrlChanged:
      case ZIMTipsMessageChangeInfoType.groupMuteChanged:
        changeInfo = ZIMTipsMessageGroupChangeInfo.fromMap(map);
        break;
      case ZIMTipsMessageChangeInfoType.groupOwnerTransferred:
      case ZIMTipsMessageChangeInfoType.groupMemberRoleChanged:
      case ZIMTipsMessageChangeInfoType.groupMemberMuteChanged:
        changeInfo = ZIMTipsMessageGroupMemberChangeInfo.fromMap(map);
        break;
      case ZIMTipsMessageChangeInfoType.groupMessagePinInfoChanged:
        changeInfo = ZIMTipsMessagePinStatusChangeInfo.fromMap(map);
        break;
      default:
        changeInfo = ZIMTipsMessageChangeInfo.fromMap(map);
        break;
    }

    return changeInfo;
  }

  static ZIMUserInfo parseZIMUserInfoFromMap(Map map) {
    // 由于 ZIMUserInfo 没有 type 类型来标识当前子类是什么类型，所以先暂时再桥接层增加一个内部字段 map['classType'] 来标识
    String? classType = map['classType'];
    ZIMUserInfo? userInfo;
    if (classType == null) {
      // 新增兼容逻辑：无 classType 字段的情况下，检查 map 里是否存在特定子类的属性字段，有的话也按子类去赋值
      if (map.containsKey('memberRole') && map.containsKey('memberNickname')) {
        userInfo = ZIMGroupMemberSimpleInfo.fromMap(map);
      } else if (map.containsKey('friendAlias') &&
          map.containsKey('friendAttributes') &&
          map.containsKey('createTime') &&
          map.containsKey('wording')) {
        userInfo = ZIMFriendInfo.fromMap(map);
      } else {
        userInfo = ZIMUserInfo.fromMap(map);
      }
      return userInfo;
    }

    switch (classType) {
      case 'ZIMGroupMemberSimpleInfo':
        userInfo = ZIMGroupMemberSimpleInfo.fromMap(map);
        break;
      case 'ZIMGroupMemberInfo':
        userInfo = ZIMGroupMemberInfo.fromMap(map);
        break;
      case 'ZIMRoomMemberInfo':
        userInfo = ZIMRoomMemberInfo.fromMap(map);
        break;
      case 'ZIMFriendInfo':
        userInfo = ZIMFriendInfo.fromMap(map);
        break;
      default:
        userInfo = ZIMUserInfo.fromMap(map);
        break;
    }

    return userInfo;
  }
}
