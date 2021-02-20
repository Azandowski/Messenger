import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/token_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/code_entity.dart';
import '../repositories/authentication_repository.dart';
import 'package:meta/meta.dart';

class Login implements UseCase<TokenEntity, LoginParams> {
  final AuthenticationRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, TokenEntity>> call(LoginParams params) async {
    return await repository.login(params);
  }
}

class LoginParams extends Equatable {
  final String phoneNumber;
  final String code;

  LoginParams({@required this.phoneNumber, @required this.code});

  @override
  List<Object> get props => [phoneNumber];
}
