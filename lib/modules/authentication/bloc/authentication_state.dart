import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/auth_enums.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String token;

  Authenticated({
    @required this.token
  });

  @override
  List<Object> get props => [token];  
}

class Unauthenticated extends AuthenticationState {
  final LoginScreenMode loginMode;

  Unauthenticated({
    this.loginMode = LoginScreenMode.enterPhone
  });
}

class AuthenticationError extends AuthenticationState {
  final String message;

  AuthenticationError({@required this.message});

  @override
  List<Object> get props => [message];
}