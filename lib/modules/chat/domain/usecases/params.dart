import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';

class GetChatMembersParams {
  final int id;
  final Pagination pagination;

  GetChatMembersParams({
    @required this.id, 
    @required this.pagination
  });
}

class SendMessageParams{
  final text;
  final chatID;

  SendMessageParams({
    @required this.chatID,
    this.text
  });

}