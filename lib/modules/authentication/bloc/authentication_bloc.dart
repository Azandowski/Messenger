import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../core/usecases/usecase.dart';
import '../domain/usecases/get_token.dart';
import '../../../core/config/storage.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final GetToken getToken;

  AuthenticationBloc({
    @required this.getToken,
  }) : super(Uninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    // app start
    if (event is AppStarted) {
      var token = await getToken(NoParams());
      token.fold((failure) => Error(message: failure.message), (token) async* {
        if (token != '') {
          Storage().token = token;
          yield Authenticated();
        } else {
          yield Unauthenticated();
        }
      });
    }

    // if (event is LoggedIn) {
    //   Storage().token = event.token;
    //   await _saveToken(event.token);
    //   yield Authenticated();
    // }

    // if (event is LoggedOut) {
    //   Storage().token = '';
    //   await _deleteToken();
    //   yield Unauthenticated();
    // }
  }
}
