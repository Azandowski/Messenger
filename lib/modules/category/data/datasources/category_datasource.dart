import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/auth_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/http_response_extension.dart';
import '../../../../core/utils/multipart_request_helper.dart';
import '../../../../locator.dart';
import '../../../chats/data/model/category_model.dart';
import '../../../chats/domain/entities/category.dart';

abstract class CategoryDataSource {
  Future<List<CategoryEntity>> createCategory({
    @required File file,
    @required String name,
    @required String token,
    List<int> chatIds,
    bool isCreate,
    int categoryID,
  });

  Future<List<CategoryEntity>> getCategories(String token);

  Future<List<CategoryEntity>> deleteCatefory(int id);

  Future<List<CategoryEntity>> transferChats (List<int> chatsIDs, int categoryID);

  Future<List<CategoryEntity>> reorderCategories (Map<String, int> categoryUpdates);
}


// * * Implementation of the CategoryDataSource
class CategoryDataSourceImpl implements CategoryDataSource {
  
  http.MultipartRequest multipartRequest;
  final http.Client client;

  CategoryDataSourceImpl({
    @required this.multipartRequest,
    @required this.client
  });
  
  /**
   * * Request to create new category
   * * Returns: List of categories of the user
   */
  @override
  Future<List<CategoryEntity>> createCategory({
    bool isCreate,
    int categoryID,
    File file, 
    String name, 
    List<int> chatIds, 
    String token
  }) async {
    var url = isCreate ? Endpoints.createCategory.buildURL() : Endpoints.updateCategory.buildURL(urlParams: ['$categoryID']);
    multipartRequest = http.MultipartRequest('POST', url);

    http.StreamedResponse streamResponse = await MultipartRequestHelper.postData(
      token: token, 
      request: multipartRequest, 
      files: file != null ? [file] : file,
      keyName: ['file'],
      data: {
        'transfer': chatIds.join(','),
        'name': name,
      }
    );

    final httpResponse = await http.Response.fromStream(streamResponse);

    if (httpResponse.isSuccess) {
      final categories = (json.decode(httpResponse.body) as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();
      return categories;
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(httpResponse.body.toString()));
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories(String token) async {
    http.Response response = await client.get(
      Endpoints.getCategories.buildURL(),
      headers: Endpoints.getCurrentUser.getHeaders(token: token));

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      List decodedCategories = (json.decode(response.body) as List);
      final categories = decodedCategories
          .map((e) => CategoryModel.fromJson(e))
          .toList();

      return categories;
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<List<CategoryEntity>> deleteCatefory(int id) async {
    var ednpoint = Endpoints.deleteCategory;
    http.Response response = await client.delete(
      ednpoint.buildURL(urlParams: [id.toString()]),
      headers: Endpoints.getCurrentUser.getHeaders(token: sl<AuthConfig>().token));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      final categories =  (json.decode(response.body) as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
      return categories;
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<List<CategoryEntity>> transferChats(List<int> chatsIDs, int categoryID) async {
    Endpoints endpoint = Endpoints.transferChats;

    http.Response response = await client.post(
      endpoint.buildURL(), 
      headers: endpoint.getHeaders(token: sl<AuthConfig>().token),
      body: json.encode({
        'new_category': categoryID == null ? null : '$categoryID',
        'chats': chatsIDs.join(',')
      })
    );

    if (!response.isSuccess) {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    } else {
      final categories =  (json.decode(response.body)['category'] as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();
      return categories;
    }
  }

  @override
  Future<List<CategoryEntity>> reorderCategories(Map<String, int> categoryUpdates) async {
    Endpoints endpoint = Endpoints.reorderCategories;

    http.Response response = await client.post(
      endpoint.buildURL(),
      headers: endpoint.getHeaders(
        token: sl<AuthConfig>().token,
      ),
      body: json.encode({
        'orders': categoryUpdates
      })
    );

    if (!response.isSuccess) {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    } else {
      var jsonBody = json.decode(response.body);
      final categories =  (jsonBody['categories'] as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();
      return categories;
    }
  }
}
