import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/utils/chat_search_util.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_entity_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_model.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_view_model.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/chat_search_response.dart';

class ChatSearchResponseModel extends ChatMessageResponse {
  final List<ChatEntity> chats;
  final PaginatedResult<Message> messages;

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
    
    PaginatedResult<Message> messages = PaginatedResult<Message>(
      data: ((json['messages']['data'] ?? []) as List).map(
        (e) => MessageModel.fromJson(e)).toList(),
      paginationData: PaginationData(
        nextPageUrl: json['messages']['next_page_url'] != null ?
          Uri.parse(json['messages']['next_page_url']) : null
      )
    );

    return ChatSearchResponseModel(
      messages: messages,
      chats: chats
    );
  }
}