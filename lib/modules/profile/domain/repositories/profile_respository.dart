import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../usecases/get_user.dart';


abstract class ProfileRepository {
  Future<Either<Failure, User>> getUser(GetUserParams getUserParams);
}


