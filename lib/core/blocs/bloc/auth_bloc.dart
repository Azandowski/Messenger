import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/config/storage.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/auth_enums.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/get_token.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetToken getToken;
  AuthBloc({
    @required this.getToken,
  }) : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStarted) {
      final tokenOrFailure = await getToken(NoParams());

      yield* _eitherLoginOrProfile(tokenOrFailure);
    } else if (event is ChangeLoginMode) {
      yield Unauthenticated(loginMode: event.currentMode);
    }
  }

  Stream<AuthState> _eitherLoginOrProfile(
    Either<Failure, String> tokenOrFailure,
  ) async* {
    yield tokenOrFailure.fold(
      (failure) {
        _handleUnauthenticated();
        return Unauthenticated();
      },
      (token) {
        _handleAuthenticated(token);
        return Authenticated(token: token);
      },
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
