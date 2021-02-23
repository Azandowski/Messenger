import 'package:equatable/equatable.dart';
import '../../domain/entities/code_entity.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateCodeEvent extends AuthenticationEvent {
  final String phone;
  CreateCodeEvent(
    this.phone,
  );

  @override
  List<Object> get props => [phone];
}

class GoToCodePage extends AuthenticationEvent {
  final CodeEntity codeEntity;
  final String userCode;
  GoToCodePage({this.codeEntity, this.userCode});

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
