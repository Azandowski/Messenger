import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:messenger_mobile/core/services/network/NetworkExceptions.dart';
import './Endpoints.dart';

class ApiBaseHelper {
  Future<dynamic> get(
    Endpoints endpoint, {
    Map<String, dynamic> queryParams,
    String token,
  }) async {
    return http.get(
      endpoint.buildURL(queryParameters: queryParams),
      headers: endpoint.getHeaders(token: token),
    ).then((value) {
      return _returnResponse(value, endpoints: endpoint);
    }).catchError((error) {
      if (error is SocketException) {
        throw CustomError("no_internet");
      } else {
        throw error;
      }
    });
  }

  Future<dynamic> post(Endpoints endpoint, {String token, Map params}) async {
    return http.post(
      endpoint.buildURL(),
      headers: endpoint.getHeaders(token: token),
      body: params,
    ).then((value) {
      if (value.statusCode >= 200 && value.statusCode <= 299) {
        return _returnResponse(value, endpoints: endpoint);
      } else {
        throw CustomError(value.body.toString());
      }
    }).catchError((e) {
      if (e is SocketException) {
        throw CustomError("no_internet");
      } else {
        throw e;
      }
    });
  }

  dynamic _returnResponse(http.Response response, {Endpoints endpoints}) {
    if (response.statusCode >= 200 || response.statusCode <= 299) {
      var returnResponse = json.decode(response.body.toString());
      return returnResponse;
    } else {
      throw CustomError(response.body.toString());
    }
  }
}