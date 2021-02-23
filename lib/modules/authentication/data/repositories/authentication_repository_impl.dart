import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/authorization/bloc/auth_bloc.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
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

  AuthenticationRepositiryImpl({
    @required this.remoteDataSource,
    @required this.networkInfo,
    @required this.localDataSource,
  }) {
    // localDataSource.deleteToken();
    initToken();
  }

  Future initToken() async {
    try {
      final token = await localDataSource.getToken();

      sl<AuthConfig>().token = token;

      print(token);

      var failOrUser = await getCurrentUser(token);

      failOrUser.fold((error) => params.add(AuthParams(null, null)),
          (user) => params.add(AuthParams(user, token)));
    } on StorageFailure {
      params.add(AuthParams(null, null));
    }
  }

  @override
  Future<Either<Failure, CodeEntity>> createCode(PhoneParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final codeEntity =
            await remoteDataSource.createCode(params.phoneNumber);
        return Right(codeEntity);
      } on ServerFailure {
        return Left(ServerFailure(message: 'invalid phone'));
      }
    } else {
      throw ServerFailure(message: 'no_internet');
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
      localDataSource.saveToken(token.token);
      return Right(token);
    } on ServerFailure {
      return Left(ServerFailure(message: 'null'));
    }
  }

  StreamSubscription<String> _tokenSubscription;

  @override
  Future<Either<Failure, String>> saveToken(String token) async {
    await localDataSource.saveToken(token);
    sl<AuthConfig>().token = token;
    await initToken();
    return Right(token);
  }

  @override
  Future<Either<Failure, User>> getCurrentUser(String token) async {
    try {
      var user = await remoteDataSource.getCurrentUser(token);
      print(user.surname);
      sl<AuthConfig>().user = user;
      return Right(user);
    } on ServerFailure {
      return Left(ServerFailure(message: 'Error'));
    }
  }

  Stream<String> get token async* {
    yield* localDataSource.token;
  }

  @override
  StreamController<AuthParams> params =
      StreamController<AuthParams>.broadcast();
}
