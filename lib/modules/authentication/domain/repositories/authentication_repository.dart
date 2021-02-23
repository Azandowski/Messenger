import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/authorization/bloc/auth_bloc.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';

import '../../../../core/error/failures.dart';
import '../entities/code_entity.dart';
import '../entities/token_entity.dart';
import '../usecases/create_code.dart';
import '../usecases/login.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, CodeEntity>> createCode(PhoneParams phoneNumber);
  Future<Either<Failure, String>> getToken();
  Future<Either<Failure, User>> getCurrentUser(String token);
  Future<Either<Failure, TokenEntity>> login(LoginParams params);
  Future<Either<Failure, String>> saveToken(String token);
  StreamController<AuthenticationStatus> status;
}
