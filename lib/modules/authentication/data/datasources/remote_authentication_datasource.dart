import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/modules/authentication/data/models/token_response.dart';
import 'package:http/http.dart' as http;
import '../models/code_response.dart';

abstract class AuthenticationRemoteDataSource {
  Future<CodeModel> createCode(String number);
  Future<TokenModel> sendCode(String code, String number);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final http.Client client;

  AuthenticationRemoteDataSourceImpl({@required this.client});
  Uri url = Endpoints.createCode.buildURL();
  @override
  Future<CodeModel> createCode(String number) => _getCreateCode(url);

  @override
  Future<TokenModel> sendCode(String code, String number) async {
    var url = Endpoints.login.buildURL();
    print(url);
    final response = await client.post(
      url,
      body: {'phone': number},
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response?.statusCode == 200) {
      return TokenModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure(message: 'Enter correct phone number');
    }
  }

  Future<CodeModel> _getCreateCode(Uri url) async {
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return CodeModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure(message: 'Enter correct phone number');
    }
  }
}
