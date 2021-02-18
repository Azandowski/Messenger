import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, String>> sendPhone(String phoneNumber);
  Future<Either<Failure,String>> getToken();
}
