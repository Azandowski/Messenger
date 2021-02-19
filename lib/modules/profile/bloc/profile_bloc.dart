import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/profile/bloc/profile_event.dart';
import 'package:messenger_mobile/modules/profile/bloc/profile_state.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/get_user.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUser getUser;

  ProfileBloc({
    @required this.getUser
  }) : super(ProfileLoading());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfile) {
      var userResponse = await getUser(GetUserParams(token: event.token));
      userResponse.fold((failure) async* {
        yield ProfileError(message: failure.message);
      }, (user) async* {
        yield ProfileLoaded(user: user);
      });
    }
  }
}
