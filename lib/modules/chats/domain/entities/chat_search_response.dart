import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';

class ChatMessageResponse extends Equatable {
  final List<ChatEntity> chats;
  final PaginatedResult<Message> messages;

  ChatMessageResponse({
    @required this.chats,
    @required this.messages
  });

  @override
  List<Object> get props => [
    chats, messages
  ];
}