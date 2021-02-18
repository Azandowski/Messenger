import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/APIBaseHelper.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/modules/authentication/data/models/code_response.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/code_entity.dart';

class NetworkingService {
  static final NetworkingService _shared = NetworkingService._internal();

  factory NetworkingService() {
    return _shared;
  }

  NetworkingService._internal();

  final _apiProvider = ApiBaseHelper();

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
