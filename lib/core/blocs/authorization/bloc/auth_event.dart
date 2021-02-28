part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStatusChanged extends AuthEvent {
  const AuthenticationStatusChanged(this.params);

  final AuthParams params;

  @override
  List<Object> get props => [params];
}

class AuthenticationLogoutRequested extends AuthEvent {

  final CategoryBloc categoryBloc;
  final ChatBloc chatBloc;

  AuthenticationLogoutRequested({
    @required this.categoryBloc,
    @required this.chatBloc
    });
}
