import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/code_entity.dart';
import '../repositories/authentication_repository.dart';

class CreateCode implements UseCase<CodeEntity, PhoneParams> {
  final AuthenticationRepository repository;

  CreateCode(this.repository);

  @override
  Future<Either<Failure, CodeEntity>> call(PhoneParams params) async {
    return await repository.createCode(params);
  }
}

class PhoneParams extends Equatable {
  final String phoneNumber;

  PhoneParams({@required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}
