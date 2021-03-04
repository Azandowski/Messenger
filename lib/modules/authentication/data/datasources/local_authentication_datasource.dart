import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
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
  Future<void> saveContactsAsString(String contactsString);

  Future<String> getDatabaseContacts();
  Future<String> getDeviceContacts();
}

const ACCESS_TOKEN = 'access_token';
const CONTACT = 'contact';


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
  Future<String> getDatabaseContacts() async{
    var contactsSent = await Storage().secureStorage.read(key: CONTACT);
    if (contactsSent != null) {
      return contactsSent;
    } else {
      return '';
    }
  }

  @override
  Future<void> saveContactsAsString(String contactsJson) async {
    await Storage().secureStorage.write(key: CONTACT, value: contactsJson);
  }

  @override
  Future<String> getDeviceContacts() async{
    Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
    return jsonEncode(contacts.map((e) => e.toJson()).toList());
  }
}

extension on Contact{
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data['middleName'] = middleName;
      data['displayName'] = displayName;
      if(this.phones != null) {
        data["phones"] =  this.phones.map((e) => e.toJson()).toList();
      }
      return data;
  }
}

extension on Item{
  Map<String, dynamic> toJson() {
    return {
       this.label: this.value,
    };
  }
}