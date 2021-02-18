import 'package:messenger_mobile/core/services/network/NetworkingService.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/code_entity.dart';

import '../../../../locator.dart';

abstract class AuthenticationRemoteDataSource {
  Future<CodeEntity> createCode(String number);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  
  @override
  Future<CodeEntity> createCode(String number) async {
    sl<NetworkingService>().createCode(number, (codeModel) {
      return codeModel;
    }, (error) {
      throw error;
    });
  }
}
