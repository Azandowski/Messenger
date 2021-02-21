import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

abstract class ProfileDataSource {
  Future<User> getCurrentUser(String token);
}

class ProfileDataSourceImpl implements ProfileDataSource {
  final http.Client client;

  ProfileDataSourceImpl({
    @required this.client
  });
  
  @override
  Future<User> getCurrentUser(String token) async {
    http.Response response = await client.post(
      Endpoints.getCurrentUser.buildURL(), 
      headers: Endpoints.getCurrentUser.getHeaders(token: token),
      body: json.encode({ 'application_id': '1' })
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure(message: response.body.toString());
    }
  }
}
