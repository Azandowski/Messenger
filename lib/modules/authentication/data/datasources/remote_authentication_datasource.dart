import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/modules/authentication/data/models/code_response.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/code_entity.dart';
import 'package:http/http.dart' as http;


abstract class AuthenticationRemoteDataSource {
  Future<CodeEntity> createCode(String number);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final http.Client client;

  AuthenticationRemoteDataSourceImpl({
    @required this.client
  });

  @override
  Future<CodeModel> createCode(String number) async {
    http.Response response = await client.post(
      Endpoints.createCode.buildURL(),
      body: '',
      headers: Endpoints.getCurrentUser.getHeaders(),
    );
    
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var jsonMap = json.decode(response.body);
      return CodeModel.fromJson(jsonMap);
    } else {
      throw ServerFailure(message: response.body.toString());
    }
  }
}
