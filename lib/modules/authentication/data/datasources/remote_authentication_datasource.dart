import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../../core/config/settings.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../domain/entities/code_entity.dart';
import '../../domain/entities/token_entity.dart';
import '../models/code_response.dart';
import '../models/token_model.dart';

abstract class AuthenticationRemoteDataSource {
  Future<CodeEntity> createCode(String number);
  Future<TokenEntity> login(String number, String code);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final http.Client client;

  AuthenticationRemoteDataSourceImpl({@required this.client});

  @override
  Future<CodeModel> createCode(String number) async {
    http.Response response = await client.post(
      Endpoints.createCode.buildURL(),
      body: {'phone': number},
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
      body: json.encode({'phone': number, 'code': code, 'application_id': APP_ID, }),
      headers: headers
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var jsonMap = json.decode(response.body);
      return TokenModel.fromJson(jsonMap);
    } else {
      throw ServerFailure(message: 'invalid code');
    }
  }

  void returnUrlBodyHeaders(Endpoints endpoint) {}
}
