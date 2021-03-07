import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../../core/utils/http_response_extension.dart';
import '../../../category/data/models/chat_entity_model.dart';
import '../../../category/domain/entities/chat_entity.dart';

abstract class ChatsDataSource {
  Future<PaginatedResult<ChatEntity>> getUserChats ({
    @required String token,
    @required PaginationData paginationData
  });

  Future<List<ChatEntity>> getCategoryChat ({
    @required String token,
    @required int categoryID
  });
}

class ChatsDataSourceImpl extends ChatsDataSource {
  final http.Client client;

  ChatsDataSourceImpl({
    @required this.client
  });

  /**
  * * Loading List of user's all chats via token
  */
  @override
  Future<PaginatedResult<ChatEntity>> getUserChats({
    @required String token,
    @required PaginationData paginationData
  }) async {
    print(paginationData.nextPageUrl);

    http.Response response = await client.get(
      paginationData.nextPageUrl == null ? 
        Endpoints.getAllUserChats.buildURL() : paginationData.nextPageUrl,
      headers: Endpoints.getAllUserChats.getHeaders(token: token)
    );
    
    if (response.isSuccess) {
      return PaginatedResult.fromJson(
        json.decode(response.body)['chat'], 
        (jsonData) => ChatEntityModel.fromJson(jsonData));
    } else {
      throw ServerFailure(message: response.body.toString());
    }
  }

  @override
  Future<List<ChatEntity>> getCategoryChat({
    @required String token, 
    @required int categoryID
  }) async {
      http.Response response = await client.get(
        Endpoints.categoryChats.buildURL(urlParams: ['$categoryID']),
        headers: Endpoints.getAllUserChats.getHeaders(token: token),
      );

    if (response.isSuccess) { 
      List chats = (json.decode(response.body)['chats'] as List);
      return chats.map((e) => ChatEntityModel.fromJson(e)).toList();
    } else {
      throw ServerFailure(message: response.body.toString());
    }
  } 
}
