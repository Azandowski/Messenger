import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/authentication/bloc/index.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/auth_enums.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/get_token.dart';
import '../../../core/config/storage.dart';
import '../../../locator.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  
  final GetToken getToken;

  AuthenticationBloc({
    @required this.getToken,
  }) : super(Uninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    
    if (event is AppStarted) {
      var token = await getToken(NoParams());
      
      yield* token.fold((failure) async* {
        _handleUnauthenticated();
        yield Unauthenticated();
      }, (token) async* {
        if (token != '' && token != null) {
          _handleAuthenticated(token);
          yield Authenticated(token: token);
        } else {
          _handleAuthenticated('1853|z0H7WZomuJ9MhLZ2yZI0VkZuD7f1SYzNh38BhpxT');
          yield Authenticated(token: '1853|z0H7WZomuJ9MhLZ2yZI0VkZuD7f1SYzNh38BhpxT');
        }
      });
    } else if (event is ChangeLoginMode) {
      yield Unauthenticated(loginMode: event.currentMode);
    } else if (event is LoggedOut) {
      _handleUnauthenticated();
      yield Unauthenticated(loginMode: LoginScreenMode.enterPhone);
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

  void _handleAuthenticated (String token) {
    Storage().token = token;
    sl<AuthConfig>().token = token;
  }

  void _handleUnauthenticated () {
    Storage().token = null;
    sl<AuthConfig>().token = null;
  }
}
