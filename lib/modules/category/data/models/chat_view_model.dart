import 'package:messenger_mobile/core/services/network/config.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';

class ChatViewModel {
  final ChatEntity entity;
  bool isSelected = false;

  // * * Getters

  String get imageURL {
    return ConfigExtension.buildURLHead() + entity.imageUrl;
  }

  bool get hasDescription {
    return entity.chatCategory != null;
  }

  String get description {
    return entity.chatCategory?.name ?? '';
  }

  ChatViewModel(this.entity);
}