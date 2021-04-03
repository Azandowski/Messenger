import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../app/appTheme.dart';

enum MessageCellActions {
  copyMessage, 
  attachMessage, 
  replyMessage,
  replyMore,
  openProfile,
  deleteMessage,
  translateMessage
}

extension MessageCellActionsUiExtensin on MessageCellActions {
  String get title {
    switch (this) {
      case MessageCellActions.copyMessage:
        return 'copy'.tr();
      case MessageCellActions.attachMessage:
        return 'attach'.tr();
      case MessageCellActions.replyMessage:
        return 'reply'.tr();
      case MessageCellActions.replyMore:
        return 'forward'.tr();
      case MessageCellActions.deleteMessage:
        return 'delete'.tr();
      case MessageCellActions.openProfile:
        return 'profile'.tr();
      case MessageCellActions.translateMessage:
        return 'translate'.tr();
      default:
        return '';
    }
  }

  Icon get icon {
    switch (this) {
      case MessageCellActions.copyMessage:
        return Icon(Icons.copy);
      case MessageCellActions.attachMessage:
        return Icon(Icons.push_pin);
      case MessageCellActions.replyMessage:
        return Icon(Icons.reply_rounded);
      case MessageCellActions.replyMore:
        return Icon(Icons.reply_all_sharp);
      case MessageCellActions.deleteMessage:
        return Icon(Icons.delete, color: AppColors.redDeleteColor,);
      case MessageCellActions.openProfile:
        return Icon(Icons.person);
      case MessageCellActions.translateMessage:
        return Icon(Icons.translate);
    }
  }
}