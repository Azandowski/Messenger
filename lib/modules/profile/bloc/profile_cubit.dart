import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/auth_config.dart';
import '../../../locator.dart';
import '../domain/usecases/get_user.dart';
import '../domain/usecases/profile_params.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUser getUser;

  ProfileCubit({@required this.getUser}) : super(ProfileLoading());

  Future<void> loadUser(LoadProfile event) async {
    emit(ProfileLoading());
    var userResponse = await getUser(GetUserParams(token: event.token));
    userResponse.fold((failure) {
      emit(ProfileError(message: failure.message));
    }, (user) {
      sl<AuthConfig>().user = user;
      emit(ProfileLoaded(user: user));
    });
  }
}
