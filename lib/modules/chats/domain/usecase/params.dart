import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class GetChatsParams extends Equatable {
  final String token;
  final int lastChatID;
  final bool fromCache;

  GetChatsParams({
    @required this.lastChatID, 
    @required this.token,
    this.fromCache = false
  });

  @override
  List<Object> get props => [token, lastChatID, fromCache];
}

class GetCategoryChatsParams extends Equatable {
  final String token;
  final int categoryID;
  final int lastChatID;
  final bool fromCache;

  GetCategoryChatsParams({
    @required this.token,
    @required this.categoryID,
    this.lastChatID,
    this.fromCache = false
  });

  @override
  List<Object> get props => [token, categoryID, lastChatID, fromCache];
}

class SearchChatParams extends Equatable {
  
  final int lastItemID;
  final String queryText;

  SearchChatParams({
    @required this.lastItemID,
    @required this.queryText
  });

  @override
  List<Object> get props => [
    lastItemID,
    queryText
  ];
}