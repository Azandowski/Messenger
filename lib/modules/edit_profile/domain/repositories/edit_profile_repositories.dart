import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../profile/domain/usecases/profile_params.dart';

abstract class EditUserRepository {
  Future<Either<Failure, bool>> updateUser(EditUserParams editUserParams);
}
