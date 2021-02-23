import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/login.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import 'index.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Login login;

  AuthenticationBloc({
    @required this.login,
  }) : super((InitialStat()));

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is GoToCodePage) {
      yield CodeState(codeEntity: event.codeEntity);
    }
  }
}
