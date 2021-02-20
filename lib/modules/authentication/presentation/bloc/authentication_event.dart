import 'package:equatable/equatable.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/auth_enums.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String token;

  LoggedIn(this.token);

  @override
  List<Object> get props => [token];
}

class LoggedOut extends AuthenticationEvent {}

class ChangeLoginMode extends AuthenticationEvent {
  final LoginScreenMode currentMode;
  
  ChangeLoginMode(this.currentMode);

  @override
  List<Object> get props => [currentMode];
}
