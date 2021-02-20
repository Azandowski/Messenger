import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/token_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/authentication_repository.dart';

class SendCode implements UseCase<TokenEntity, String> {
  final AuthenticationRepository repository;

  SendCode(this.repository);

  @override
  Future<Either<Failure, TokenEntity>> call(String code) async {
    return await repository.sendCode(code);
  }
}


