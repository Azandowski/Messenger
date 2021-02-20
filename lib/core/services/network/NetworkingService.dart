import 'package:flutter/foundation.dart';
import 'APIBaseHelper.dart';
import 'Endpoints.dart';
import 'package:http/http.dart' as http;


class NetworkingService {
  
  final http.Client httpClient;
  
  ApiBaseHelper _apiProvider;

  NetworkingService({@required this.httpClient}) {
    _apiProvider = ApiBaseHelper(apiHttpClient: httpClient);
  }

  createCode({
    @required String phone
  }) async {
    return await _apiProvider.post(Endpoints.createCode, params: {"phone": phone});
  }

  Future getCurrentUser ({
    @required String token
  }) async {
    return await _apiProvider.post(
      Endpoints.getCurrentUser, token: token, params: {
        'application_id': '1'
      }
    );
  }
}
