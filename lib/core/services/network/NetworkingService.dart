import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/profile/data/models/user_model.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
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
      Map<String, dynamic> response = await _apiProvider.post(Endpoints.createCode, params: {"phone": phone});
      onSuccess(CodeModel.fromJson(response));
    } catch (e) {
      if (e is Failure) {
        onError(e);
      }
    }
  }

  getCurrentUser ({
    @required String token,
    @required Function(User) onSuccess,
    @required Function(Failure) onError
  }) async {
    try { 
      Map response = await _apiProvider.post(Endpoints.getCurrentUser);
      onSuccess(UserModel.fromJson(response));
    } catch (e) {
      if (e is Failure) {
        onError(e);
      }
    }
  }
}
