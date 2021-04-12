import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/config/auth_config.dart';
import '../../../../core/config/settings.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/Endpoints.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/multipart_request_helper.dart';
import '../../../../locator.dart';
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
  Future<bool> sendContacts(File contacts);
  Future<bool> sendPlayerID(String playerID, String token);
  Future<bool> deletePlayerID(String playerID, token);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final http.Client client;
  final http.MultipartRequest request;

  AuthenticationRemoteDataSourceImpl(
      {@required this.client, @required this.request});

  @override
  Future<CodeModel> createCode(String number) async {
    try {
      http.Response response = await client.post(
        Endpoints.createCode.buildURL(),
        body: jsonEncode({'phone': number}),
        headers: Endpoints.createCode.getHeaders(),
      );
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        var jsonMap = json.decode(response.body);
        return CodeModel.fromJson(jsonMap);
      } else {
        throw ServerFailure(
            message: ErrorHandler.getErrorMessage(response.body.toString()));
      }
    }catch(e){
      print(e);
      throw ServerFailure(
          message: ErrorHandler.getErrorMessage('no_connection'.tr()));
    }
  }

  @override
  Future<TokenEntity> login(String number, String code) async {
    try {
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
    }catch (e){
        throw ServerFailure(message: 'no_connection'.tr());
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
      headers: headers
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var jsonMap = json.decode(response.body);
      return UserModel.fromJson(jsonMap);
    } else {
      throw ServerFailure(message: ErrorHandler.getErrorMessage(response.body.toString()));
    }
  }

  @override
  Future<bool> sendContacts(File contacts) async {
    http.StreamedResponse response = await MultipartRequestHelper.postData(
      token: sl<AuthConfig>().token,
      request: request,
      data: {},
      files: contacts != null ? [contacts] : [],
      keyName: ['contacts']
    );

    final httpResponse = await http.Response.fromStream(response);
    print(httpResponse);
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> sendPlayerID(String playerID, String token) async{
    var url = Endpoints.sendTokenOneSignal.buildURL();
    var headers = Endpoints.sendTokenOneSignal.getHeaders(token: token);
    final response = await client.post(url,
      body: json.encode({
        "application_id": APP_ID,
        "player_id": playerID,
      }),
      headers: headers
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return true;
    } else {
      throw ServerFailure(message: 'Not able to send player id');
    }
  }

  @override
  Future<bool> deletePlayerID(String playerID, token) async {
    var url = Endpoints.deleteTokenOneSignal.buildURL();
    var headers = Endpoints.getCurrentUser.getHeaders(token: token);
    final response = await client.post(url,
      body: json.encode({
        "application_id": APP_ID,
        "player_id": playerID,
      }),
      headers: headers
    );
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return true;
    }else{
      throw ServerFailure(message: 'Not able to delete player id');
    }
  }
}
