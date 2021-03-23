import 'package:flutter/foundation.dart';

import '../../../../core/services/network/paginatedResult.dart';
import '../../domain/entities/message.dart';

class ChatMessageResponse {
  final PaginatedResultViaLastItem<Message> result;
  final Message topMessage;

  ChatMessageResponse({
    @required this.result,
    @required this.topMessage
  });
}