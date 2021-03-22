import 'package:flutter/foundation.dart';

import '../../../../core/services/network/paginatedResult.dart';
import '../../../category/data/models/chat_entity_model.dart';
import '../../../category/domain/entities/chat_entity.dart';
import '../../../chat/data/models/message_model.dart';
import '../../../chat/domain/entities/message.dart';
import '../../../chat/presentation/chats_screen/pages/chat_screen_import.dart';
import '../../domain/entities/chat_search_response.dart';

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