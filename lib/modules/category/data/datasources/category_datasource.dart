import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/modules/create_category/data/models/chat_entity_model.dart';
import 'package:messenger_mobile/modules/create_category/domain/entities/chat_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/multipart_request_helper.dart';
import '../../../chats/data/model/category_model.dart';
import '../../../chats/domain/entities/category.dart';
import 'package:messenger_mobile/core/utils/http_response_extension.dart';

abstract class CreateCategoryDataSource {
  Future<List<CategoryEntity>> createCategory({
    @required File file,
    @required String name,
    @required String token,
    List<int> chatIds,
  });

  Future<PaginatedResult<ChatEntity>> getUserChats ({
    @required String token
  });

  Future<List<CategoryEntity>> getCategories(String token);
}

class CreateCategoryDataSourceImpl implements CreateCategoryDataSource {
  
  final http.MultipartRequest multipartRequest;
  final http.Client client;

  CreateCategoryDataSourceImpl({
    @required this.multipartRequest,
    @required this.client
  });
  
  /**
   * * Request to create new category
   * * Returns: List of categories of the user
   */
  @override
  Future<List<CategoryEntity>> createCategory({
    File file, String name, List<int> chatIds, String token
  }) async {
    http.StreamedResponse streamResponse = await MultipartRequestHelper.postData(
      token: token, 
      request: multipartRequest, 
      files: file != null ? [file] : file,
      keyName: 'file',
      data: {
        'chat_ids': chatIds,
        'name': name
      }
    );

    final httpResponse = await http.Response.fromStream(streamResponse);

    if (httpResponse.isSuccess) {
      final categories = (json.decode(httpResponse.body) as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();
      return categories;
    } else {
      throw ServerFailure(message: httpResponse.body.toString());
    }
  }


  /**
   * * Loading List of user's all chats via token
   */
  @override
  Future<PaginatedResult<ChatEntity>> getUserChats({
    @required String token
  }) async {
    http.Response response = await client.get(
      Endpoints.getAllUserChats.buildURL(), 
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
  Future<List<CategoryEntity>> getCategories(String token) async {
    http.Response response = await client.get(
      Endpoints.getCategories.buildURL(),
      headers: Endpoints.getCurrentUser.getHeaders(token: token));

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      final categories = (json.decode(response.body) as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();

      return categories;
    } else {
      throw ServerFailure(message: response.body.toString());
    }
  }
}
