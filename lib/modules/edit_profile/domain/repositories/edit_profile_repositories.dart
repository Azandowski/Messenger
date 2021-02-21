import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/profile_params.dart';

abstract class EditUserRepository {
  Future<Either<Failure, bool>> updateUser(EditUserParams editUserParams);
}