import 'package:flutter/foundation.dart';

import 'message.dart';

enum ChatActions {
  addUser,
  kickUser,
  newDay
}

extension ChatActionsLogicExtension on ChatActions {
  ChatActionTypes get actionType {
    if (
      this == ChatActions.addUser || this == ChatActions.kickUser
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
      default: 
        return null;
    }
  }

  String get hintText {
    switch (this) {
      case ChatActions.addUser:
        return 'добавил(а) участника';
      case ChatActions.kickUser:
        return 'удалил участника';
      default:
        return null;
    }
  }

  String getDescription (String userName) {
    switch (this) {
      case ChatActions.addUser:
        return '$userName добавлен(а)';
      case ChatActions.kickUser:
        return '$userName исключен(а)';
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
