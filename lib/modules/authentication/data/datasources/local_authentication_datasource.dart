import '../../../../core/config/storage.dart';
import '../../../../core/error/failures.dart';

abstract class AuthenticationLocalDataSource {
  Future<void> saveToken(String token);

  /// read to keystore/keychain
  Future<String> getToken();
  Stream<String> get token;

  /// delete from keystore/keychain
  Future<bool> deleteToken();

  // write sent contacts
  Future<void> saveContactsState();

  Future<bool> getContacts();
}

const ACCESS_TOKEN = 'access_token';
const CONTACT = 'contact';

const WROTE = 'contacts_wrote';

class AuthenticationLocalDataSourceImpl
    implements AuthenticationLocalDataSource {
  @override
  Future<bool> deleteToken() async {
    await Storage().secureStorage.delete(key: ACCESS_TOKEN);
    await Storage().secureStorage.delete(key: CONTACT);
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

  @override
  Future<void> saveContactsState() async {
    await Storage().secureStorage.write(key: CONTACT, value: WROTE);
  }

  @override
  Future<bool> getContacts() async{
    var contactsSent = await Storage().secureStorage.read(key: CONTACT);
    if (contactsSent != null && contactsSent != '') {
      return true;
    } else {
      return false;
    }
  }
}
