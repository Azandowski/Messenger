import 'package:messenger_mobile/core/config/storage.dart';
import 'package:messenger_mobile/core/error/failures.dart';

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
    final token = await Storage().secureStorage.read(key: ACCESS_TOKEN);
    if (token != null) {
      return Future.value(token);
    } else {
      throw StorageFailure(message: 'TOKEN_NULL');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    await Storage().secureStorage.write(key: 'access_token', value: token);
  }
}
