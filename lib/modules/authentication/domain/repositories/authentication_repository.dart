import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/code_entity.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/create_code.dart';
import '../../../../core/error/failures.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, CodeEntity>> createCode(PhoneParams phoneNumber);
  Future<Either<Failure, String>> getToken();
}
