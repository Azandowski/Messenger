import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../edit_profile/domain/repositories/edit_profile_repositories.dart';
import 'profile_params.dart';

class EditUser implements UseCase<bool, EditUserParams> {
  final EditUserRepository repository;

  EditUser(this.repository);

  @override
  Future<Either<Failure, bool>> call(EditUserParams params) async {
    return await repository.updateUser(params);
  }
}
