import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'Endpoints.dart';

class ApiBaseHelper {
  final http.Client apiHttpClient;

  ApiBaseHelper({@required this.apiHttpClient});

  Future<dynamic> get(
    Endpoints endpoint, {
    Map<String, dynamic> queryParams,
    String token,
  }) async {
    return apiHttpClient.get(
      endpoint.buildURL(queryParameters: queryParams),
      headers: endpoint.getHeaders(token: token),
    );
  }

  Future<dynamic> post(Endpoints endpoint, {String token, Map params}) {
    Map headers = endpoint.getHeaders(token: token);
    return apiHttpClient.post(
      endpoint.buildURL(),
      headers: headers,
      body: jsonEncode(params),
    );
  }
}
