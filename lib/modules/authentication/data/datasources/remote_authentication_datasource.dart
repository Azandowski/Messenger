import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/settings.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../../profile/data/models/user_model.dart';
import '../../../profile/domain/entities/user.dart';
import '../../domain/entities/code_entity.dart';
import '../../domain/entities/token_entity.dart';
import '../models/code_response.dart';
import '../models/token_model.dart';

abstract class AuthenticationRemoteDataSource {
  Future<CodeEntity> createCode(String number);
  Future<TokenEntity> login(String number, String code);
  Future<User> getCurrentUser(String token);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final http.Client client;

  AuthenticationRemoteDataSourceImpl({@required this.client});

  @override
  Future<CodeModel> createCode(String number) async {
    http.Response response = await client.post(
      Endpoints.createCode.buildURL(),
      body: jsonEncode({'phone': number}),
      headers: Endpoints.createCode.getHeaders(),
    );
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var jsonMap = json.decode(response.body);
      return CodeModel.fromJson(jsonMap);
    } else {
      throw ServerFailure(message: response.body.toString());
    }
  }

  @override
  Future<TokenEntity> login(String number, String code) async {
    var url = Endpoints.login.buildURL();
    var headers = Endpoints.login.getHeaders();
    final response = await client.post(url,
        body: json.encode({
          'phone': number,
          'code': code,
          'application_id': APP_ID,
        }),
        headers: headers);

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var jsonMap = json.decode(response.body);
      return TokenModel.fromJson(jsonMap);
    } else {
      throw ServerFailure(message: 'invalid code');
    }
  }

  void returnUrlBodyHeaders(Endpoints endpoint) {}

  @override
  Future<User> getCurrentUser(String token) async {
    var url = Endpoints.getCurrentUser.buildURL();
    var headers = Endpoints.getCurrentUser.getHeaders(token: token);
    final response = await client.post(url,
        body: json.encode({
          'application_id': APP_ID,
        }),
        headers: headers);
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var jsonMap = json.decode(response.body);
      return UserModel.fromJson(jsonMap);
    } else {
      var errorMessage = '';
      
      try {
        var jsonMap = json.decode(response.body.toString());
        errorMessage = jsonMap['message'] ?? jsonMap.toString();
      } catch (e) {
        errorMessage = response.body.toString();
      }
      
      throw ServerFailure(message: errorMessage);
    }
  }
}
