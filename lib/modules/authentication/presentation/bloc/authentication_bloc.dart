import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/code_entity.dart';
import '../../domain/entities/token_entity.dart';
import '../../domain/usecases/create_code.dart';
import '../../domain/usecases/login.dart';
import '../../../../core/config/auth_config.dart';
import '../../../../core/config/storage.dart';
import '../../../../locator.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import 'index.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final CreateCode createCode;
  final Login login;

  AuthenticationBloc({
    @required this.createCode,
    @required this.login,
  }) : super((InitialStat()));

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is CreateCodeEvent) {
      isLoading = true;
      final params = PhoneParams(phoneNumber: event.phone);
      final errorOrCode = await createCode(params);
      yield* _eitherCodeOrFailure(errorOrCode);
    } else if (event is SendCode) {
      final loginParams = LoginParams(
          phoneNumber: event.codeEntity.phone, code: event.userCode);
      final errorOrToken = await login(loginParams);

      yield* _eitherTokenOrFailure(errorOrToken);
    }
  }

  Stream<AuthenticationState> _eitherCodeOrFailure(
    Either<Failure, CodeEntity> failureOrCode,
  ) async* {
    yield failureOrCode.fold(
      (failure) {
        _handleUnauthenticated();
        return AuthenticationError(message: failure.message);
      },
      (code) {
        return CodeState(codeEntity: code);
      },
    );
  }

  Stream<AuthenticationState> _eitherTokenOrFailure(
    Either<Failure, TokenEntity> failureOrToken,
  ) async* {
    yield failureOrToken.fold(
      (failure) {
        _handleUnauthenticated();
        return AuthenticationError(message: failure.message);
      },
      (token) {
        _handleAuthenticated(token.token);
        // return Authenticated(token: token.token);
      },
    );
  }

  void _handleAuthenticated(String token) {
    sl<AuthConfig>().token = token;
  }

  void _handleUnauthenticated() {
    // TODO: Remove Token HERE 
    sl<AuthConfig>().token = null;
  }

  //Vars
  bool isLoading = false;
}
