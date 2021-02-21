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
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_token.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import 'index.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final GetToken getToken;
  final CreateCode createCode;
  final Login login;

  AuthenticationBloc({
    @required this.getToken,
    @required this.createCode,
    @required this.login,
  }) : super(Uninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final tokenOrFailure = await getToken(NoParams());
      yield* _eitherLoginOrProfile(tokenOrFailure);
    } else if (event is ChangeLoginMode) {
      yield Unauthenticated(loginMode: event.currentMode);
    } else if (event is CreateCodeEvent) {
      final params = PhoneParams(phoneNumber: event.phone);
      final errorOrCode = await createCode(params);
      yield* _eitherCodeOrFailure(errorOrCode);
    } else if (event is SendCode) {
      final loginParams = LoginParams(
          phoneNumber: event.codeEntity.phone, code: event.userCode);
      final errorOrToken = await login(loginParams);
      yield* _eitherTokenOrFailure(errorOrToken);
    } else if (event is PoFanu) {
      print('qotaaaaq');
      yield Authenticated(token: 'sndlansld');
    }
  }

  Stream<AuthenticationState> _eitherLoginOrProfile(
    Either<Failure, String> tokenOrFailure,
  ) async* {
    yield tokenOrFailure.fold(
      (failure) => Unauthenticated(),
      (token) => Authenticated(token: token),
    );
  }

  Stream<AuthenticationState> _eitherCodeOrFailure(
    Either<Failure, CodeEntity> failureOrCode,
  ) async* {
    yield failureOrCode.fold(
      (failure) => InvalidPhone(message: failure.message),
      (code) => PreSendCode(codeEntity: code),
    );
  }

  Stream<AuthenticationState> _eitherTokenOrFailure(
    Either<Failure, TokenEntity> failureOrToken,
  ) async* {
    yield failureOrToken.fold(
      (failure) => InvalidCode(message: failure.message),
      (token) => Authenticated(token: token.token),
    );
  }

  void _handleAuthenticated(String token) {
    Storage().token = token;
    sl<AuthConfig>().token = token;
  }

  void _handleUnauthenticated() {
    Storage().token = null;
    sl<AuthConfig>().token = null;
  }
}
//  yield* token.fold((failure) async* {
//         _handleUnauthenticated();
//         yield Unauthenticated();
//       }, (token) async* {
//         if (token != '' && token != null) {
//           _handleAuthenticated(token);
//           yield Authenticated(token: token);
//         } else {
//           _handleAuthenticated('1853|z0H7WZomuJ9MhLZ2yZI0VkZuD7f1SYzNh38BhpxT');
//           yield Authenticated(
//               token: '1853|z0H7WZomuJ9MhLZ2yZI0VkZuD7f1SYzNh38BhpxT');
//         }
//       });
