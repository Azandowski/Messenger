import '../../../../core/error/failures.dart';

import '../../../../core/config/storage.dart';

abstract class AuthenticationLocalDataSource {
  Future<void> saveToken(String token);

  /// read to keystore/keychain
  Future<String> getToken();

  /// delete from keystore/keychain
  Future<void> deleteToken();
}

const ACCESS_TOKEN = 'access_token';

class AuthenticationLocalDataSourceImpl
    implements AuthenticationLocalDataSource {
  @override
  Future<void> deleteToken() async {
    await Storage().secureStorage.delete(key: ACCESS_TOKEN);
  }

  @override
  Future<String> getToken() async {
    var token = await Storage().secureStorage.read(key: ACCESS_TOKEN);
    if (token != null && token != '') {
      return token;
    } else {
      throw StorageFailure();
    }
  }

  @override
  Future<void> saveToken(String token) async {
    await Storage().secureStorage.write(key: ACCESS_TOKEN, value: token);
  }
}
