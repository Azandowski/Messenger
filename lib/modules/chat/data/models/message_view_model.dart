import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:intl/intl.dart';

import '../../../../locator.dart';

class MessageViewModel {
  final Message message;

  MessageViewModel (this.message); 

  // MARK: - For UI

  String get userNameText {
    return message.user.name ?? '';
  }

  String get messageText {
    return message.text ?? '';
  }

  String get time {
    if (message.dateTime != null) {
      return new DateFormat("Hm").format(message.dateTime); 
    } else {
      return '';
    }
  }

  String get readImageName {
    return message.isRead ? 'assets/images/read.png': 'assets/images/unread.png';
  }

  BoxDecoration getCellDecoration ({
    @required int previousMessageUserID, 
    @required int nextMessageUserID
  }) {
    int myID = sl<AuthConfig>().user.id;

    return BoxDecoration(
      color: !isMine ? Colors.white : (isMine && messageStatus == MessageStatus.sending) ?
        AppColors.greyColor : AppColors.messageBlueBackground,
      borderRadius: BorderRadius.only(
        topLeft: isMine || previousMessageUserID != message.user.id ? Radius.circular(10) : Radius.zero,
        bottomLeft: isMine || nextMessageUserID != message.user.id ?  Radius.circular(10) : Radius.zero,
        bottomRight: !isMine || nextMessageUserID !=  message.user.id ? Radius.circular(10) : Radius.zero,
        topRight: !isMine || previousMessageUserID !=  message.user.id ? Radius.circular(10) : Radius.zero,
      ),
      border: Border.all(color: AppColors.indicatorColor)
    );
  }

  Color get readColor {
    return message.isRead ? AppColors.successGreenColor : AppColors.greyColor;
  }


  // MARK: - Logic

  Color get color {
    switch(message.colorId) {
      case 1:
        return Colors.deepOrange.shade400;
      case 2:
        return Colors.cyan.shade300;
      case 3:
        return Colors.purple.shade400;
      case 4:
        return Colors.green.shade400;
      case 5:
        return Colors.indigo.shade400;
      case 6:
        return Colors.pink.shade400;
      case 7:
        return Colors.blue.shade400;
      case 8:
        return Colors.amber.shade400;
      default:
        return Colors.black;
    }
  }

  bool get isMine {
    return sl<AuthConfig>().user.id == message.user.id;
  }

  MessageStatus get messageStatus {
    return message.messageStatus;
  }
}