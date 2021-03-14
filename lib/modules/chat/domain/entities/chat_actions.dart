import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';

enum ChatActions {
  addUser,
  newDay
}

extension ChatActionsLogicExtension on ChatActions {
  ChatActionTypes get actionType {
    if (this == ChatActions.addUser) {
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
      default: 
        return null;
    }
  }

  String get hintText {
    switch (this) {
      case ChatActions.addUser:
        return 'добавил(а) участника';
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
