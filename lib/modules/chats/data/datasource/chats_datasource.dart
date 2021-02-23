import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../domain/entities/category.dart';
import '../model/category_model.dart';

abstract class ChatsDataSource {
  Future<List<CategoryEntity>> getCategories(String token);
}

class ChatsDataSourceImpl extends ChatsDataSource {
  final http.Client client;

  ChatsDataSourceImpl({@required this.client});

  @override
  Future<List<CategoryEntity>> getCategories(String token) async {
    http.Response response = await client.post(
        Endpoints.getCategories.buildURL(),
        headers: Endpoints.getCurrentUser.getHeaders(token: token),
        body: json.encode({'application_id': '1'}));

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
