import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:messenger_mobile/modules/authentication/domain/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import '../../../modules/authentication/domain/usecases/get_token.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetToken getToken;
  final AuthenticationRepository authRepositiry;

  StreamSubscription<AuthParams> _authenticationStatusSubscription;

  AuthBloc({
    @required this.getToken,
    @required this.authRepositiry,
  }) : super(Unknown()) {
    _authenticationStatusSubscription = authRepositiry.params.stream
        .listen((params) => add(AuthenticationStatusChanged(params)));
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthenticationStatusChanged) {
      yield await _mapAuthenticationStatusChangedToState(event.params);
    } else if (event is AuthenticationLogoutRequested) {
      // unawaited(_authenticationRepository.logOut());
    }
  }

  Future<AuthState> _mapAuthenticationStatusChangedToState(
    AuthParams params,
  ) async {
    if (params.user != null) {
      return Authenticated(user: params.user);
    } else if (params.token == null || params.token == '') {
      return Unauthenticated();
    } else {
      return Unknown();
    }
  }
}
