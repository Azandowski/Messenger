import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';

enum MessageCellActions {
  copyMessage, 
  attachMessage, 
  replyMessage,
  replyMore,
  deleteMessage
}

extension MessageCellActionsUiExtensin on MessageCellActions {
  String get title {
    switch (this) {
      case MessageCellActions.copyMessage:
        return 'Копировать';
      case MessageCellActions.attachMessage:
        return 'Закрепить';
      case MessageCellActions.replyMessage:
         return 'Ответить';
      case MessageCellActions.replyMore:
         return 'Переслать';
      case MessageCellActions.deleteMessage:
         return 'Удалить';
    }
  }

  Icon get icon {
    switch (this) {
      case MessageCellActions.copyMessage:
        return Icon(Icons.copy);
      case MessageCellActions.attachMessage:
        return Icon(Icons.attach_money);
      case MessageCellActions.replyMessage:
        return Icon(Icons.reply_rounded);
      case MessageCellActions.replyMore:
        return Icon(Icons.reply_all_sharp);
      case MessageCellActions.deleteMessage:
        return Icon(Icons.delete, color: AppColors.redDeleteColor,);
    }
  }
}