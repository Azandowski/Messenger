import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/code_entity.dart';

abstract class AuthenticationRemoteDataSource {
  Future<Either<Failure,CodeEntity>> createCode(int number);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
 


  @override
  Future<Either<Failure,CodeEntity>> createCode(int number) {
    // TODO: implement sendPhone
    throw UnimplementedError();
  }
}
