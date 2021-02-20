import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import '../models/code_response.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDataSource {
  Future<CodeModel> createCode(String number);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final http.Client client;

  AuthenticationRemoteDataSourceImpl({@required this.client});

  @override
  Future<CodeModel> createCode(String number) async {
    final value = await client.post(
      Endpoints.createCode.buildURL(),
    );
    if (value != null) {
      if (value.statusCode == 200) {
        var jsonMap = json.decode(value.body);
        return CodeModel.fromJson(jsonMap);
      } else {
        throw ServerFailure(message: '400 code');
      }
    }
  }
}
