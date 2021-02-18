import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/authentication/domain/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';

class SendPhone implements UseCase<String, PhoneParams> {
  final AuthenticationRepository repository;

  SendPhone(this.repository);

  @override
  Future<Either<Failure, String>> call(PhoneParams params) async {
    return await repository.sendPhone(params.phoneNumber);
  }
}

class PhoneParams extends Equatable {
  final String phoneNumber;

  PhoneParams({@required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}
