import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';

import '../../../../core/blocs/authorization/bloc/auth_bloc.dart';
import '../../../../core/config/auth_config.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../../../core/services/network/socket_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../locator.dart';
import '../../../category/domain/usecases/get_categories.dart';
import '../../../chats/domain/entities/usecases/params.dart';
import '../../../profile/domain/entities/user.dart';
import '../../domain/entities/code_entity.dart';
import '../../domain/entities/token_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../domain/usecases/create_code.dart';
import '../datasources/local_authentication_datasource.dart';
import '../datasources/remote_authentication_datasource.dart';

class AuthenticationRepositiryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource remoteDataSource;
  final AuthenticationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final GetCategories getCategories;
  final AuthConfig authConfig;

  AuthenticationRepositiryImpl({
    @required this.remoteDataSource,
    @required this.networkInfo,
    @required this.localDataSource,
    @required this.getCategories,
    @required this.authConfig,
  }) {
    initToken();
  }

  Future initToken() async {
    try {
      final token = await localDataSource.getToken();

      authConfig.token = token;
      if (token != null && token != '') {
        sl<SocketService>().init();
        print(token);  
        await getCurrentUser(token);
        getCategories(GetCategoriesParams(token: token));
      }
    } on StorageFailure {
      params.add(AuthParams(null, null));
    }
  }

  @override
  Future<Either<Failure, CodeEntity>> createCode(PhoneParams params) async {
      try {
        final codeEntity =
            await remoteDataSource.createCode(params.phoneNumber);
        return Right(codeEntity);
      } on ServerFailure catch(e) {
        return Left(e);
      }
  }

  @override
  Future<Either<Failure, String>> getToken() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token);
    } on StorageFailure {
      return Left(StorageFailure());
    }
  }

  @override
  Future<Either<Failure, TokenEntity>> login(params) async {
    try {
      final token =
          await remoteDataSource.login(params.phoneNumber, params.code);
      // getCurrentUser(token.token);
      localDataSource.saveToken(token.token);
      var status = await OneSignal.shared.getPermissionSubscriptionState();
      String playerID = status.subscriptionStatus.userId;
      remoteDataSource.sendPlayerID(playerID, token.token);
      getCategories(GetCategoriesParams(token: token.token));
      return Right(token);
    } on ServerFailure {
      return Left(ServerFailure(message: FailureMessages.invalidCode));
    }
  }

  @override
  Future<Either<Failure, String>> saveToken(String token) async {
    await localDataSource.saveToken(token);
    authConfig.token = token;
    if (token != null && token != '') {
      sl<SocketService>().init();
    }

    await initToken();
    return Right(token);
  }

  @override
  Future<Either<Failure, User>> getCurrentUser(String token) async {
    try {
      var user = await remoteDataSource.getCurrentUser(token);
      // print(user.surname);
      authConfig.user = user;
      params.add(AuthParams(user, token));
      return Right(user);
    } on ServerFailure {
      params.add(AuthParams(null, null));
      return Left(ServerFailure(message: FailureMessages.noConnection));
    }
  }

  Stream<String> get token async* {
    yield* localDataSource.token;
  }

  @override
  StreamController<AuthParams> params =
      StreamController<AuthParams>.broadcast();

  @override
  Future<Either<Failure, bool>> logout(NoParams params) async {
    try {
      var status = await OneSignal.shared.getPermissionSubscriptionState();
      String playerID = status.subscriptionStatus.userId;
      remoteDataSource.deletePlayerID(playerID, token);
      await localDataSource.deleteToken();
      await localDataSource.deleteContacts();
      initToken();
      return Right(true);
    } on StorageFailure {
      return Left(StorageFailure());
    }
  }

  @override
  Future sendContacts() async {
    var deviceContacts = await localDataSource.getDeviceContacts();
    List<RecordSnapshot> dbContacts =
        await localDataSource.getDatabaseContacts();
    var contactsShouldBeUpdated = [];

    deviceContacts.forEach((e) {
      if ((e['phones'] ?? []).length != 0) {
        e['displayName'] = e['displayName'] ?? '';
        
        var foundContact = dbContacts.firstWhere((d) {
          var allPhonesMatch = true;

          ((d.value['phones'] ?? []) as List).forEach((phoneMap) {
            var result = ((e['phones'] ?? []) as List).firstWhere(
                (k) => k['mobile'] == phoneMap['mobile'],
                orElse: () => null);
            if (result == null) {
              allPhonesMatch = false;
            }
          });

          return allPhonesMatch;
        }, orElse: () => null);

        if (foundContact == null) {
          contactsShouldBeUpdated.add(_updatedContactToSendToBackend(e));
        }
      }
    });

    File file = await _writeJson(jsonEncode(contactsShouldBeUpdated));
    var result = await remoteDataSource.sendContacts(file);


    if (result) {
      return localDataSource.saveContacts(deviceContacts);
    }
  }

  Future<File> _writeJson(String newJson) async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/contacts.json';
    final File file = File(path);
    await file.writeAsString(newJson);
    print(file.path);
    return file;
  }

  Map _updatedContactToSendToBackend(Map inputContact) {
    Map object = inputContact;

    ['emails', 'postalAddresses'].forEach((key) {
      object.remove(key);
    });

    return object;
  }
}
