import 'package:equatable/equatable.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/code_entity.dart';
import '../../domain/entities/auth_enums.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class CreateCodeEvent extends AuthenticationEvent {
  final String phone;
  CreateCodeEvent(
    this.phone,
  );

  @override
  List<Object> get props => [
        phone,
      ];
}

class SendCode extends AuthenticationEvent {
  final CodeEntity codeEntity;
  final String userCode;
  SendCode({this.codeEntity, this.userCode});

  @override
  List<Object> get props => [codeEntity, userCode];
}

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
