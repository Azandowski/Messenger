import 'package:flutter/material.dart';
import 'APIBaseHelper.dart';
import 'Endpoints.dart';
import 'package:http/http.dart' as http;

class NetworkingService {
  final http.Client httpClient;
  ApiBaseHelper _apiProvider;

  NetworkingService({@required this.httpClient}) {
    _apiProvider = ApiBaseHelper(apiHttpClient: httpClient);
  }

  createCode(String phone, Function(http.Response) onFinished) async {
    http.Response response =
        await _apiProvider.post(Endpoints.createCode, params: {"phone": phone});
    onFinished(response);
  }
}
