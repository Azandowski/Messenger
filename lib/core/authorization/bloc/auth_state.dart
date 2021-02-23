part of 'auth_bloc.dart';

class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class Unknown extends AuthState {}

class Unauthenticated extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  Authenticated({this.user});
}

class AuthParams {
  final User user;
  final String token;

  AuthParams(this.user, this.token);
}
