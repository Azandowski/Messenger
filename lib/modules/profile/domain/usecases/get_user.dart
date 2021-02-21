import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:messenger_mobile/modules/profile/domain/repositories/profile_respository.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/profile_params.dart';

class GetUser implements UseCase<User, GetUserParams> {
  final ProfileRepository repository;

  GetUser(this.repository);

  @override
  Future<Either<Failure, User>> call(GetUserParams params) async {
    return await repository.getUser(params);
  }
}

