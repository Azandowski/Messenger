import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/authentication/domain/repositories/authentication_repository.dart';
import '../../../../core/usecases/usecase.dart';

class GetToken implements UseCase<String, NoParams> {
  final AuthenticationRepository repository;

  GetToken(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.getToken();
  }
}


