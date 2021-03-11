import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/services/network/paginatedResult.dart';

class GetChatsParams extends Equatable {
  final String token;
  final int lastChatID;

  GetChatsParams({
    @required this.lastChatID, 
    @required this.token
  });

  @override
  List<Object> get props => [token, lastChatID];
}

class GetCategoryChatsParams extends Equatable {
  final String token;
  final int categoryID;
  final int lastChatID;

  GetCategoryChatsParams({
    @required this.token,
    @required this.categoryID,
    this.lastChatID
  });

  @override
  List<Object> get props => [token, categoryID, lastChatID];
}