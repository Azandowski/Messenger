import 'package:messenger_mobile/core/services/network/config.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:intl/intl.dart';

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
    } else if (entity.lastMessage != null) {
      return entity.lastMessage.text ?? '';
    } else {
      return entity.chatCategory?.name ?? '';
    }
  }

  bool get isInLive {
    // TODO: Добавить property для прямых эфиров
    return false;
  }

  bool get isGroup {
     // TODO: Добавить property для групп
    return false;
  }

  String get dateTime {
    return new DateFormat("Hm").format(entity.date); 
  }

  bool get isRead {
    return entity.lastMessage?.isRead ?? false;
  }

  int get unreadMessages {
    return 0;
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
    return true;
  }

  bool get isMuted {
    return !entity.permissions.isSoundOn;
  }

  bool get isHideImages {
    return false;
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
