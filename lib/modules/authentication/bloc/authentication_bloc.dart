import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/get_token.dart';
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
      token.fold((failure) => Error(message: _mapFailureToMessage(failure)),
          (token) async* {
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

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'SERVER_FAILURE_MESSAGE';
      default:
        return 'Unexpected error';
    }
  }
}
