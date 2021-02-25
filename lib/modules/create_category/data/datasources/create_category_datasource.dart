import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../../../core/utils/multipart_request_helper.dart';
import '../../../chats/data/model/category_model.dart';
import '../../../chats/domain/entities/category.dart';
import 'package:path/path.dart';

abstract class CreateCategoryDataSource {
  Future<List<CategoryEntity>> createCategory({
    @required File file,
    @required String name,
    @required String token,
    List<int> chatIds,
  });
}

class CreateCategoryDataSourceImpl implements CreateCategoryDataSource {
  
  final http.MultipartRequest multipartRequest;

  CreateCategoryDataSourceImpl({
    @required this.multipartRequest
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

    if (httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299) {
      final categories = (json.decode(httpResponse.body) as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();
      return categories;
    } else {
      throw ServerFailure(message: httpResponse.body.toString());
    }
  } 
}
