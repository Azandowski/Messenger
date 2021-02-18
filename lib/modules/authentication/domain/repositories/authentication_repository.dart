import 'package:dartz/dartz.dart';
import '../entities/code_entity.dart';
import '../usecases/create_code.dart';
import '../../../../core/error/failures.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, CodeEntity>> createCode(PhoneParams phoneNumber);
  Future<Either<Failure, String>> getToken();
}
