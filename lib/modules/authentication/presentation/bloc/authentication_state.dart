import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/code_entity.dart';
import '../../domain/entities/auth_enums.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class PreSendCode extends AuthenticationState {
  final CodeEntity codeEntity;

  PreSendCode({@required this.codeEntity});

  @override
  List<Object> get props => [codeEntity];
}

class InvalidPhone extends AuthenticationState {
  final String message;

  InvalidPhone({@required this.message});

  @override
  List<Object> get props => [message];
}

class InvalidCode extends AuthenticationState {
  final String message;

  InvalidCode({@required this.message});

  @override
  List<Object> get props => [message];
}

class PreLogin extends AuthenticationState {
  final String code;
  final String phone;

  PreLogin({@required this.code, this.phone});

  @override
  List<Object> get props => [code, phone];
}

class Authenticated extends AuthenticationState {
  final String token;

  Authenticated({@required this.token});

  @override
  List<Object> get props => [token];
}

class Unauthenticated extends AuthenticationState {
  final LoginScreenMode loginMode;

  Unauthenticated({this.loginMode = LoginScreenMode.enterPhone});
}

class Loading extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  final String message;

  AuthenticationError({@required this.message});

  @override
  List<Object> get props => [message];
}
