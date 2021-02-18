import 'package:messenger_mobile/modules/authentication/domain/usecases/create_code.dart';

import '../../../../core/services/network/NetworkingService.dart';
import '../models/code_response.dart';

import '../../../../locator.dart';

abstract class AuthenticationRemoteDataSource {
  Future<CodeModel> createCode(String number);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  @override
  Future<CodeModel> createCode(String number) async {
    var codeModel;
    await sl<NetworkingService>().createCode(number, (code) async {
      codeModel = code;
    }, (error) {
      throw error;
    });
    return codeModel;
  }
}
