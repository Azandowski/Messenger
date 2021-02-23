import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:messenger_mobile/modules/authentication/domain/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../modules/authentication/domain/usecases/get_token.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetToken getToken;
  final AuthenticationRepository authRepositiry;

  StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  AuthBloc({
    @required this.getToken,
    @required this.authRepositiry,
  }) : super(AuthState.unknown()) {
    _authenticationStatusSubscription =
        authRepositiry.status.stream.listen((status) {
      print(status);
      print('lyaaaaaa');
      return add(AuthenticationStatusChanged(status));
    });
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthenticationStatusChanged) {
      print('changed auth state');
      yield await _mapAuthenticationStatusChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      print('fucking works');
      // unawaited(_authenticationRepository.logOut());
    }
  }

  Future<AuthState> _mapAuthenticationStatusChangedToState(
    AuthenticationStatusChanged event,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return const AuthState.unauthenticated();
      case AuthenticationStatus.authenticated:
        return AuthState.authenticated(event.status);
      default:
        return const AuthState.unknown();
    }
  }
}
