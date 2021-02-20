import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:messenger_mobile/core/config/settings.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/modules/authentication/data/models/code_response.dart';
import 'package:messenger_mobile/modules/authentication/data/models/token_model.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/code_entity.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/modules/authentication/domain/entities/token_entity.dart';

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
        body: {
          'phone': number,
          'code': code,
          'application_id': APP_ID,
        },
        headers: headers);

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var jsonMap = json.decode(response.body);
      return TokenModel.fromJson(jsonMap);
    } else {
      throw ServerFailure(message: 'invalid code');
    }
  }

  void returnUrlBodyHeaders(Endpoints endpoint) {}
}
