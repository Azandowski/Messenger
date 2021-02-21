import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/edit_profile/domain/repositories/edit_profile_repositories.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/profile_params.dart';

class EditUser implements UseCase<bool, EditUserParams> {
  final EditUserRepository repository;

  EditUser(this.repository);

  @override
  Future<Either<Failure, bool>> call(EditUserParams params) async {
    return await repository.updateUser(params);
  }
}

