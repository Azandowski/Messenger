import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:messenger_mobile/modules/profile/domain/repositories/profile_respository.dart';

class GetUser implements UseCase<User, GetUserParams> {
  final ProfileRepository repository;

  GetUser(this.repository);

  @override
  Future<Either<Failure, User>> call(GetUserParams params) async {
    return await repository.getUser(params);
  }
}

class GetUserParams extends Equatable {
  final String token;

  GetUserParams({
    @required this.token
  });

  @override
  List<Object> get props => [token];
}