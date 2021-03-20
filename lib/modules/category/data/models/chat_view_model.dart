import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/helpers/message_user_viewmodel.dart';

import '../../../../core/services/network/config.dart';
import '../../../chat/domain/entities/chat_actions.dart';
import '../../domain/entities/chat_entity.dart';

class ChatViewModel {
  final ChatEntity entity;
  bool isSelected; 

  // * * Getters

  String get title {
    return entity.title;
  }

  String get imageURL {
    if (entity.imageUrl != null) {
      return ConfigExtension.buildURLHead() + entity.imageUrl;
    } else {
      return null;
    }
  }

  bool get hasDescription {
    return entity.chatCategory != null || entity.lastMessage != null;
  }

  String get description {
    if (isInLive) {
      return 'Сейчас в прямом эфире'.toUpperCase();
    } else if (entity?.lastMessage != null) {
      if (entity.lastMessage.chatActions != null) {
        var userViewModel = MessageUserViewModel(entity.lastMessage.toUser);
        
        return entity.lastMessage.chatActions.getDescription(
          userViewModel.name
        );
      }
      return entity.lastMessage.text ?? '';
    } else if (entity?.chatCategory != null){
      return entity.chatCategory.name ?? '';
    } else {
      return entity?.description ?? '';
    }
  }

  TextStyle get descriptionStyle {
    if (isInLive) {
      return TextStyle(
        color: AppColors.indicatorColor, fontSize: 12, fontWeight: FontWeight.w500
      ); 
    } else if (entity.lastMessage?.chatActions != null) {
      return AppFontStyles.placeholderStyle;
    } else {
      return AppFontStyles.mediumStyle;
    }
  }

  bool get isInLive {
    // TODO: Добавить property для прямых эфиров
    return false;
  }

  String get dateTime {
    if (entity.lastMessage != null) {
      return new DateFormat("Hm").format(entity.lastMessage.dateTime); 
    }
    
    return new DateFormat("Hm").format(entity.date); 
  }

  bool get isRead {
    return entity.lastMessage?.isRead ?? false;
  }

  int get unreadMessages {
    return entity.unreadCount;
  }

  ChatBottomPin get bottomPin {
    if (unreadMessages != 0) {
      return ChatBottomPin.badge;
    } else if (isInLive) {
      return ChatBottomPin.none;
    } else if (isRead) {
      return ChatBottomPin.read;
    } else {
      return ChatBottomPin.unread;
    }
  }

  // MARK: - Chat Options 

  bool get isPinned {
    return false;
  }

  bool get isMuted {
    return !entity.permissions.isSoundOn;
  }

  bool get isHideImages {
    return !entity.permissions.isMediaSendOn;
  }

  List<ChatSettingType> get chatSettings {
    List<ChatSettingType> arr = [];
    if (isHideImages) {
      arr.add(ChatSettingType.hideImages);
    } 

    if (isMuted) {
      arr.add(ChatSettingType.muted);
    }

    if (isPinned) {
      arr.add(ChatSettingType.pinned);
    }

    return arr;

  }

  ChatViewModel(
    this.entity, { this.isSelected = false }
  );
}

enum ChatBottomPin { unread, read, badge, none }

enum ChatSettingType { muted, hideImages, pinned }
