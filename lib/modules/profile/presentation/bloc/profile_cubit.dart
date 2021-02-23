import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/get_user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/profile_params.dart';
import 'package:messenger_mobile/modules/profile/presentation/bloc/index.dart';

import '../../../../locator.dart';



class ProfileCubit extends Cubit<ProfileState> {
  final GetUser getUser;

  ProfileCubit({
    @required this.getUser
  }) : super(ProfileLoading());

  Future<void> loadUser (LoadProfile event) async {
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