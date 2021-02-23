import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/modules/chats/data/model/category_model.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class ChatsDataSource {
  Future<List<CategoryEntity>> getCategories (String token);
}

class ChatsDataSourceImpl extends ChatsDataSource {
  final http.Client client;

  ChatsDataSourceImpl({
    @required this.client
  });

  @override
  Future<List<CategoryEntity>> getCategories(String token) async {
    http.Response response = await client.post(
      Endpoints.getCategories.buildURL(), 
      headers: Endpoints.getCurrentUser.getHeaders(token: token),
      body: json.encode({ 'application_id': '1' })
    );
    
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      final categories = 
        (json.decode(response.body) as List).map((e) => CategoryModel.fromJson(e)).toList();
      
      return categories;
    } else {
      throw ServerFailure(message: response.body.toString());
    }
  }
}