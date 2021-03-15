
import 'package:contacts_service/contacts_service.dart';
import 'package:sembast/sembast.dart';
import '../../../../core/config/storage.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/localdb/app_database.dart';

abstract class AuthenticationLocalDataSource {
  Future<void> saveToken(String token);

  /// read to keystore/keychain
  Future<String> getToken();
  Stream<String> get token;

  /// delete from keystore/keychain
  Future<bool> deleteToken();

  // write sent contacts
  Future<void> saveContacts(List<Map> contacts);
  Future<void> deleteContacts ();

  Future<List> getDatabaseContacts();
  Future<List<Map>> getDeviceContacts();
}

const ACCESS_TOKEN = 'access_token';
const CONTACT = 'contact';


class AuthenticationLocalDataSourceImpl implements AuthenticationLocalDataSource {
  
  Future<Database> get  _localDb  async => await AppDatabase.instance.database;
  final _contactsFolder = intMapStoreFactory.store('contacts');

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

  // Returns New Contacts
  @override
  Future<List> getDatabaseContacts() async{
    return await _contactsFolder.find(await _localDb);
  }

  @override
  Future<void> deleteContacts() async {
    return await _contactsFolder.delete(await _localDb);
  }

  @override
  Future<void> saveContacts(List<Map> contacts) async {
    var db = await _localDb;
    _contactsFolder.delete(db);

    var contactSaveJobs = <Future>[];

    for (Map contact in contacts) {
      contactSaveJobs.add(_contactsFolder.add(db, new Map<String, dynamic>.from(contact)));
    }

    return Future.wait(contactSaveJobs);
  }

  @override
  Future<List<Map>> getDeviceContacts() async{
    Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
    
    var items =  (contacts ?? []).map((e) {      
      Map object = e.toMap();
      
      ['emails', 'postalAddresses'].forEach((key) { 
        object.remove(key);
      });

      List phones = object['phones'] ?? [];
      object['phones'] = [];
      
      phones.forEach((item) { 
        object['phones'].add({
          item['label']: item['value']
        });
      }); 

      return object;     

    }).toList();

    return items;
  }
}

extension on Contact{
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['middleName'] = middleName;
    data['displayName'] = displayName;
    if (this.phones != null) {
      data["phones"] =  this.phones.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

extension on Item {
  Map<String, dynamic> toJson() {
    return {
       this.label: this.value,
    };
  }
}