import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/authentication_repository.dart';

class SaveToken implements UseCase<String, String> {
  final AuthenticationRepository repository;

  SaveToken(this.repository);

  @override
  Future<Either<Failure, String>> call(String token) async {
    return await repository.saveToken(token);
  }
}
