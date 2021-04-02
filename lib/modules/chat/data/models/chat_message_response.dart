import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/services/network/paginatedResult.dart';
import '../../domain/entities/message.dart';

class ChatMessageResponse extends Equatable {
  final PaginatedResultViaLastItem<Message> result;
  final Message topMessage;

  ChatMessageResponse({@required this.result, @required this.topMessage});

  @override
  List<Object> get props => [result, topMessage];

  @override
  String toString() {
    return "\nChatMessageResponse [ result=$result  topMessage=$topMessage  ]";
  }
}
