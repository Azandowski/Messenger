import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/contact_bloc/contact_bloc.dart';

import '../../../../modules/authentication/domain/repositories/authentication_repository.dart';
import '../../../../modules/authentication/domain/usecases/logout.dart';
import '../../../../modules/profile/domain/entities/user.dart';
import '../../../usecases/usecase.dart';
import '../../category/bloc/category_bloc.dart';
import '../../chat/bloc/bloc/chat_cubit.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository authRepositiry;
  final Logout logoutUseCase;

  StreamSubscription<AuthParams> _authenticationStatusSubscription;

  AuthBloc({@required this.authRepositiry, @required this.logoutUseCase})
      : super(Unknown()) {
    _authenticationStatusSubscription = authRepositiry.params.stream
        .listen((params) => add(AuthenticationStatusChanged(params)));
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthenticationStatusChanged) {
      yield await _mapAuthenticationStatusChangedToState(event.params);
    } else if (event is AuthenticationLogoutRequested) {
      await logoutUseCase(NoParams());
      event.categoryBloc.add(CategoriesReset());
      event.chatBloc.killAllCaches();
      event.contactBloc.add(ContactReset());
    }
  }

  Future<AuthState> _mapAuthenticationStatusChangedToState(
    AuthParams params,
  ) async {
    var user = params.user;
    if (user != null && user.fullName != null && user.fullName != "") {
      return Authenticated(user: user);
    } else if (user != null && user?.fullName == null || user?.fullName == "") {
      return NeedsNamePhoto(user: user);
    } else if (params.token == null || params.token == '') {
      return Unauthenticated();
    } else {
      return Unknown();
    }
  }
}
