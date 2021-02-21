import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/profile_respository.dart';

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