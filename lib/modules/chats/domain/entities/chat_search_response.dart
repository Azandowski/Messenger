import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/services/network/paginatedResult.dart';
import '../../../category/domain/entities/chat_entity.dart';
import '../../../chat/domain/entities/message.dart';

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