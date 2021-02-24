import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../profile/domain/entities/user.dart';
import '../repositories/authentication_repository.dart';

class GetCurrentUser implements UseCase<User, String> {
  final AuthenticationRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, User>> call(String token) async {
    return await repository.getCurrentUser(token);
  }
}
