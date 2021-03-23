import 'package:flutter/foundation.dart';

import 'message.dart';

enum ChatActions {
  addUser,
  kickUser,
  newDay,
  setSecret,
  unsetSecret
}

extension ChatActionsLogicExtension on ChatActions {
  ChatActionTypes get actionType {
    if (
      this == ChatActions.addUser 
        || this == ChatActions.kickUser 
          || this == ChatActions.setSecret
            || this == ChatActions.unsetSecret
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
      default: 
        return null;
    }
  }

  String getHintText (bool isMe) {
    switch (this) {
      case ChatActions.addUser:
        return isMe ? 'добавили участника' : 
          'добавил(а) участника';
      case ChatActions.kickUser:
        return isMe ? 'удалили участника' : 
          'удалил(а) участника';
      case ChatActions.setSecret:
        return isMe ? 'включили таймер сгорания' : 
          'включил(a) таймер сгорания';
      case ChatActions.unsetSecret:
        return isMe? 'выключил таймер сгроания' : 
          'выключил(а) таймер сгорания';
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
      case ChatActions.setSecret:
        return 'Включен таймер сгорания';
      case ChatActions.unsetSecret:
        return 'Выключен таймер сгорания';
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
