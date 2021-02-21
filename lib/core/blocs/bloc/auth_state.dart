part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class Uninitialized extends AuthState {
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthState {
  final String token;

  Authenticated({@required this.token});

  @override
  List<Object> get props => [token];
}

class Unauthenticated extends AuthState {
  final LoginScreenMode loginMode;

  Unauthenticated({this.loginMode = LoginScreenMode.enterPhone});
}
