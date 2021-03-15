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
  
  final Uri nextPageURL;
  final String queryText;
  final int chatID;

  SearchChatParams({
    @required this.nextPageURL,
    @required this.queryText,
    this.chatID
  });

  @override
  List<Object> get props => [
    nextPageURL,
    queryText,
    chatID
  ];
}