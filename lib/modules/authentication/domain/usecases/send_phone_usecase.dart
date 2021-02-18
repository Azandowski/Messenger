import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/authentication/domain/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';

class SendPhone implements UseCase<String, Params> {
  final AuthenticationRepository repository;

  SendPhone(this.repository);

  @override
  Future<Either<Failure, String>> call(Params params) async {
    return await repository.sendPhone(params.phoneNumber);
  }
}

class Params extends Equatable {
  final String phoneNumber;

  Params({@required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}
