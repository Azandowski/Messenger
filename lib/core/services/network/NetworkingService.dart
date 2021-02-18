import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/APIBaseHelper.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';


class NetworkingService {
  static final NetworkingService _shared = NetworkingService._internal();

  factory NetworkingService() {
    return _shared;
  }

  NetworkingService._internal(); 

  final _apiProvider = ApiBaseHelper();

  createCode(String phone, Function(Map) onSuccess, Function(Failure) onError) async {
    try {
      var response = await _apiProvider
        .post(Endpoints.createCode, params: {"phone": phone});
      // onSuccess(CodeEntity.fromJson(response));
    } catch (e) {
      onError(e);
    }
  }
}