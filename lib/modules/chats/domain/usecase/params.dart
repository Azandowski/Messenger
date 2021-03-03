import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';

class GetChatsParams extends Equatable {
  final String token;
  final PaginationData paginationData;

  GetChatsParams({
    @required this.paginationData, 
    @required this.token
  });

  @override
  List<Object> get props => [token, paginationData];
}

class GetCategoryChatsParams extends Equatable {
  final String token;
  final int categoryID;

  GetCategoryChatsParams({
    @required this.token,
    @required this.categoryID
  });

  @override
  List<Object> get props => [token, categoryID];
}