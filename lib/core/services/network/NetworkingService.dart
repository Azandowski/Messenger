import 'package:flutter/foundation.dart';
import '../../error/failures.dart';
import 'APIBaseHelper.dart';
import 'Endpoints.dart';
import '../../../modules/authentication/data/models/code_response.dart';
import 'package:http/http.dart' as http;

class NetworkingService {
  final http.Client httpClient;
  ApiBaseHelper _apiProvider;

  NetworkingService({@required this.httpClient}) {
    _apiProvider = ApiBaseHelper(apiHttpClient: httpClient);
  }

  createCode(String phone, Function(CodeModel) onSuccess,
      Function(Failure) onError) async {
    try {
      Map<String, dynamic> response = await _apiProvider
          .post(Endpoints.createCode, params: {"phone": phone});
      onSuccess(CodeModel.fromJson(response));
    } catch (e) {
      if (e is Failure) {
        onError(e);
      }
    }
  }
}
