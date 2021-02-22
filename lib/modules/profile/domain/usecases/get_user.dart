import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/profile_respository.dart';
import 'profile_params.dart';

class GetUser implements UseCase<User, GetUserParams> {
  final ProfileRepository repository;

  GetUser(this.repository);

  @override
  Future<Either<Failure, User>> call(GetUserParams params) async {
    return await repository.getUser(params);
  }
}
