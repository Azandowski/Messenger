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