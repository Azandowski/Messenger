import '../../../../core/config/storage.dart';
import '../../../../core/error/failures.dart';

abstract class AuthenticationLocalDataSource {
  Future<void> saveToken(String token);

  /// read to keystore/keychain
  Future<String> getToken();
  Stream<String> get token;

  /// delete from keystore/keychain
  Future<bool> deleteToken();
}

const ACCESS_TOKEN = 'access_token';

class AuthenticationLocalDataSourceImpl
    implements AuthenticationLocalDataSource {
  @override
  Future<bool> deleteToken() async {
    await Storage().secureStorage.delete(key: ACCESS_TOKEN);
    return true;
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

  @override
  Stream<String> get token async* {
    var token = Storage().secureStorage.read(key: ACCESS_TOKEN).asStream();
    yield* token;
  }
}
