import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/get_user.dart';


abstract class ProfileRepository {
  Future<Either<Failure, User>> getUser(GetUserParams getUserParams);
}


