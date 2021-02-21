import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/code_entity.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialStat extends AuthenticationState {}

class CodeState extends AuthenticationState {
  final CodeEntity codeEntity;

  CodeState({@required this.codeEntity});

  @override
  List<Object> get props => [codeEntity];
}

class PreLogin extends AuthenticationState {
  final String code;
  final String phone;

  PreLogin({@required this.code, this.phone});

  @override
  List<Object> get props => [code, phone];
}

class Loading extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  final String message;

  AuthenticationError({@required this.message});

  @override
  List<Object> get props => [message];
}
