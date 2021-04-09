import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'message.dart';

enum ChatActions {
  addUser,
  kickUser,
  newDay,
  setSecret,
  unsetSecret,
  chatCreated,
  leaveChat
}

extension ChatActionsLogicExtension on ChatActions {
  ChatActionTypes get actionType {
    if (
      this == ChatActions.addUser 
        || this == ChatActions.kickUser 
          || this == ChatActions.setSecret
            || this == ChatActions.unsetSecret 
              || this == ChatActions.chatCreated
               || this == ChatActions.leaveChat
    ) {
      return ChatActionTypes.group;
    } else {
      return ChatActionTypes.time;
    }
  }
}

extension ChatActionsExtension on ChatActions {
  String get key {
    switch (this) {
      case ChatActions.addUser:
        return 'Ad User';
      case ChatActions.kickUser:
        return 'Kick User';
      case ChatActions.setSecret:
        return 'SetSecretChat';
      case ChatActions.unsetSecret:
        return 'UnsetSecretChat';
      case ChatActions.chatCreated:
        return 'chatCreated';
      case ChatActions.leaveChat:
        return 'LeaveUserChat';
      default: 
        return null;
    }
  }

  bool get needsSecondUser {
    if (this == ChatActions.setSecret || this == ChatActions.unsetSecret) {
      return false;
    } else if (this == ChatActions.chatCreated || this == ChatActions.leaveChat) {
      return false;
    }

    return true;
  }

  String getHintText () {
    switch (this) {
      case ChatActions.addUser:
        return 'added_user'.tr();
      case ChatActions.kickUser:
        return 'deleted_user'.tr();
      case ChatActions.setSecret:
        return 'secret_mode_turned_on'.tr();
      case ChatActions.unsetSecret:
        return 'secret_mode_turned_off'.tr();
      case ChatActions.chatCreated:
        return 'chatCreated'.tr();
      case ChatActions.leaveChat:
        return 'deleted_user'.tr();
      default:
        return null;
    }
  }

  String getDescription (String userName) {
    switch (this) {
      case ChatActions.addUser:
        return 'user_added_v2'.tr(namedArgs: {
          'username': userName
        });
      case ChatActions.kickUser:
        return 'user_deleted_v2'.tr(namedArgs: {
          'username': userName
        });
      case ChatActions.leaveChat:
        return 'user_deleted_v2'.tr(namedArgs: {
          'username': userName
        });
      case ChatActions.setSecret:
        return 'secret_mode_turned_on'.tr();
      case ChatActions.unsetSecret:
        return 'secret_mode_turned_off'.tr();
      case ChatActions.chatCreated:
        return 'chatCreated'.tr();
      default:
        return null;
    }
  }

  String get imagePath {
    switch (this) {
      case ChatActions.setSecret: case ChatActions.unsetSecret:
        return 'assets/icons/hot.png';
      default:
        return null;
    }
  }
}


enum ChatActionTypes {
  group, time
}

abstract class ChatAction {}

class GroupAction extends ChatAction {
  final ChatActions action;
  final MessageUser firstUser;
  final MessageUser secondUser;

  bool get needsSecondUser => action.needsSecondUser;

  bool get isAtLeft => action == ChatActions.leaveChat;

  GroupAction({
    @required this.action,
    @required this.firstUser,
    @required this.secondUser
  });
}


class TimeAction extends ChatAction {
  final ChatActions action;
  final DateTime dateTime;

  TimeAction({
    @required this.action,
    @required this.dateTime
  });
}
