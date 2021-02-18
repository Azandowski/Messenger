import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/APIBaseHelper.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/modules/authentication/data/models/code_response.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/code_entity.dart';
import 'package:http/http.dart' as http;

class NetworkingService {

  final http.Client httpClient;
  ApiBaseHelper _apiProvider;

  NetworkingService({
    @required this.httpClient
  }) {
    _apiProvider = ApiBaseHelper(
      apiHttpClient: httpClient
    );
  }

  createCode(String phone, Function(CodeEntity) onSuccess,
      Function(Failure) onError) async {
    try {
      var response = await _apiProvider
          .post(Endpoints.createCode, params: {"phone": phone});
      onSuccess(CodeModel.fromJson(response));
    } catch (e) {
      onError(e);
    }
  }
}
