part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class ChangeLoginMode extends AuthEvent {
  final LoginScreenMode currentMode;

  ChangeLoginMode(this.currentMode);

  @override
  List<Object> get props => [currentMode];
}
