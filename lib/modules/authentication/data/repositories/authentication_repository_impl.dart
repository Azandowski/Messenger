import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/network/network_info.dart';
import 'package:messenger_mobile/modules/authentication/data/datasources/local_authentication_datasource.dart';
import 'package:messenger_mobile/modules/authentication/data/datasources/remote_authentication_datasource.dart';
import 'package:messenger_mobile/modules/authentication/domain/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';

class AuthenticationRepositiryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource remoteDataSource;
  final AuthenticationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthenticationRepositiryImpl({
    @required this.remoteDataSource,
    @required this.networkInfo,
    @required this.localDataSource,
  });

  @override
  Future<Either<Failure, String>> sendPhone(String phoneNumber) async {
    // TODO: implement sendPhone
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> getToken() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token);
    } catch (e) {
      if (e is StorageFailure) {
        return Left(e);
      }
    }
  }
}
