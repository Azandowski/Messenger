import 'package:dartz/dartz.dart';
import '../../../../core/services/network/network_info.dart';
import '../datasources/local_authentication_datasource.dart';
import '../datasources/remote_authentication_datasource.dart';
import '../../domain/entities/code_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../domain/usecases/create_code.dart';
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
  Future<Either<Failure, CodeEntity>> createCode(PhoneParams params) async {
    try {
      final codeEntity = await remoteDataSource.createCode(params.phoneNumber);
      return Right(codeEntity);
    } catch (e) {
      return Left(e);
    }
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
