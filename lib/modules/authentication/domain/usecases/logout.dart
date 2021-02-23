import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/authentication_repository.dart';

class Logout implements UseCase<bool, NoParams> {
  final AuthenticationRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.logout(params);
  }
}
