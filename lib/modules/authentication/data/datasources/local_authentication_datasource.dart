import '../../../../core/config/storage.dart';
import '../../../../core/error/failures.dart';

abstract class AuthenticationLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  ///
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
    return await Storage().secureStorage.read(key: ACCESS_TOKEN);
  }

  @override
  Future<void> saveToken(String token) async {
    await Storage().secureStorage.write(key: ACCESS_TOKEN, value: token);
  }
}
