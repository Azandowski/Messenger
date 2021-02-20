import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/token_entity.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/login.dart';
import '../entities/code_entity.dart';
import '../usecases/create_code.dart';
import '../../../../core/error/failures.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, CodeEntity>> createCode(PhoneParams phoneNumber);
  Future<Either<Failure, String>> getToken();
  Future<Either<Failure, TokenEntity>> login(LoginParams params);
}
