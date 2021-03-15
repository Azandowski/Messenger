import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_entity_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_model.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_view_model.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/chat_search_response.dart';

class ChatSearchResponseModel extends ChatMessageResponse {
  final List<ChatEntity> chats;
  final PaginatedResultViaLastItem<Message> messages;

  ChatSearchResponseModel({
    @required this.chats,
    @required this.messages
  }) : super(
    chats: chats,
    messages: messages
  );


  factory ChatSearchResponseModel.fromJson(Map<String, dynamic> json) {
    List<ChatEntity> chats = 
      ((json['chats'] ?? []) as List).map((e) => ChatEntityModel.fromJson(e)).toList();
    
    PaginatedResultViaLastItem<Message> messages = PaginatedResultViaLastItem<Message>(
      data: ((json['0']['messages'] ?? []) as List).map(
        (e) => MessageModel.fromJson(e)).toList(),
      hasReachMax: !json['0']['hasMoreResults']
    );

    return ChatSearchResponseModel(
      messages: messages,
      chats: chats
    );
  }
}