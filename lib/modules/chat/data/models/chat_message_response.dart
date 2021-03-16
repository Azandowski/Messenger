import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';

class ChatMessageResponse {
  final PaginatedResultViaLastItem<Message> result;
  final Message topMessage;

  ChatMessageResponse({
    @required this.result,
    @required this.topMessage
  });
}