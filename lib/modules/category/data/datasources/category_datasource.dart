import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/locator.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/multipart_request_helper.dart';
import '../../../chats/data/model/category_model.dart';
import '../../../chats/domain/entities/category.dart';
import 'package:messenger_mobile/core/utils/http_response_extension.dart';

abstract class CategoryDataSource {
  Future<List<CategoryEntity>> createCategory({
    @required File file,
    @required String name,
    @required String token,
    List<int> chatIds,
  });

  Future<List<CategoryEntity>> getCategories(String token);

  Future<CategoryEntity> deleteCatefory(int id);
  }

class CategoryDataSourceImpl implements CategoryDataSource {
  
  final http.MultipartRequest multipartRequest;
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

  @override
  Future<CategoryEntity> deleteCatefory(int id) async {
    var ednpoint = Endpoints.deleteCategory;
    http.Response response = await client.delete(
      ednpoint.buildURL(queryParameters: {'id':id}),
      headers: Endpoints.getCurrentUser.getHeaders(token: sl<AuthConfig>().token));

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      final category =  CategoryModel.fromJson(json.decode(response.body));
      return category;
    } else {
      throw ServerFailure(message: response.body.toString());
    }
  }
}
