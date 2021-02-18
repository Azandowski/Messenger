import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/NetworkingService.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/code_entity.dart';

abstract class AuthenticationRemoteDataSource {
  Future<Either<Failure, CodeEntity>> createCode(String number);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  @override
  Future<Either<Failure, CodeEntity>> createCode(String number) async {
    NetworkingService().createCode(number, (codeModel) {
      return codeModel;
    }, (error) {
      throw error;
    });
  }
}
