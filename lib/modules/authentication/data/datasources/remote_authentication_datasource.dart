import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/services/network/APIBaseHelper.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/authentication/data/models/token_response.dart';
import 'package:http/http.dart' as http;
import '../../../../core/services/network/NetworkingService.dart';
import '../models/code_response.dart';

abstract class AuthenticationRemoteDataSource {
  Future<CodeModel> createCode(String number);
  Future<TokenModel> sendCode(String code, String number);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final NetworkingService networkingService;

  AuthenticationRemoteDataSourceImpl({@required this.networkingService});

  @override
  Future<CodeModel> createCode(String number) async {
    return await networkingService.createCode(number,
        (http.Response response) async {
      if (response.statusCode == 200) {
        return CodeModel.fromJson(json.decode(response.body));
      }
    });
  }

  @override
  Future<TokenModel> sendCode(String code, String number) {
    // TODO: implement sendCode
    throw UnimplementedError();
  }
}
