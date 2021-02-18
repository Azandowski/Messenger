import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {}

class Unauthenticated extends AuthenticationState {}

class Error extends AuthenticationState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}