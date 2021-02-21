import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/profile/bloc/profile_event.dart';
import 'package:messenger_mobile/modules/profile/bloc/profile_state.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/get_user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/profile_params.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUser getUser;

  ProfileBloc({
    @required this.getUser
  }) : super(ProfileLoading());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfile) {
      yield ProfileLoading();
      var userResponse = await getUser(GetUserParams(token: event.token));
      yield* userResponse.fold((failure) async* {
        yield ProfileError(message: failure.message);
      }, (user) async* {
        sl<AuthConfig>().user = user;
        yield ProfileLoaded(user: user);
      });
    }
  }
}
