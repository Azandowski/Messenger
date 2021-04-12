import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:messenger_mobile/core/utils/date_helper.dart';

import '../../../../app/appTheme.dart';
import '../../../../core/config/auth_config.dart';
import '../../../../locator.dart';
import '../../domain/entities/message.dart';
import '../../presentation/chats_screen/helpers/messageCellAction.dart';

enum MessageCellPresentationType {
  contact, textAndMedia, location
}


class MessageViewModel {
  final Message message;
  final bool isSelected;
  final int timeLeftToBeDeleted;

  MessageViewModel (
    this.message, {
      this.isSelected = false,
      this.timeLeftToBeDeleted
    }
  ); 

  // MARK: - For UI

  String get userNameText {
    return message.user.name ?? '';
  }

  String get messageText {
    return message.text ?? '';
  }

  String get time {
    if (timeLeftToBeDeleted != null && timeLeftToBeDeleted > 0) {
      return sl<DateHelper>().getTimerLeft(timeLeftToBeDeleted);
    } else if (message.dateTime != null) {
      return new DateFormat("Hm").format(message.dateTime); 
    } else {
      return '';
    }
  }

  String get fullTime {
    print(message.dateTime);
    if (message.dateTime != null) {
      return new DateFormat.yMMMMEEEEd().add_Hm().format(message.dateTime); 
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
  
  bool get canBeCopied {
    return message.text != null && message.text != '';
  }

  List<MessageCellActions> getActionsList ({
    @required bool isReplyEnabled
  }) {
    if (message.text != null && message.text != '') {
      return MessageCellActions.values.where(
        (e) => 
          isReplyEnabled ? true : e != MessageCellActions.replyMessage 
            && e != MessageCellActions.replyMore 
      ).toList(); 
    } else {
      return [
        MessageCellActions.attachMessage, 
        if (isReplyEnabled)
          ...[
            MessageCellActions.replyMessage, 
            MessageCellActions.replyMore
          ],
        MessageCellActions.openProfile,
        MessageCellActions.deleteMessage,
      ];
    } 
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

  bool get hasToShowMap {
    return message.location != null;
  }

  LatLng get mapLocation {
    return message.location.position;
  }

  String get mapLocationAddress {
    return message.location.description;
  }

  String get forwardDescription {
    if (message.text != null) {
      return this.messageText;
    } else {
      return 'Вложение';
    } 
  }

  TextStyle get forwardTextStyle {
    if (message.text != null) {
      return AppFontStyles.black14w400.copyWith(
        height: 1.4,
      );
    } else {
      return AppFontStyles.black14w400.copyWith(
        height: 1.4, color: AppColors.indicatorColor
      );
    }
  }

  bool get hasMedia {
    if (message.files != null) {
      return message.files.length > 0;
    } else {
      return false;
    }
  }

  MessageCellPresentationType get presentationType {
    if ((message.contacts ?? []).length != 0) {
      return MessageCellPresentationType.contact;
    } else if (this.hasToShowMap) {
      return MessageCellPresentationType.location;
    } else {
      return MessageCellPresentationType.textAndMedia;
    }
  }

  MessageUser get contactItem {
    return message.contacts[0];
  }
}