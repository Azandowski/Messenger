import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/set_wallpaper.dart';

import '../../../../core/config/auth_config.dart';
import '../../../../locator.dart';
import '../../../authentication/domain/usecases/get_current_user.dart';
import 'index.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetCurrentUser getUser;
  final SetWallpaper setWallpaper;

  ProfileCubit({
    @required this.getUser,
    @required this.setWallpaper
  }) : super(ProfileLoaded(user: sl<AuthConfig>().user));

  Future<void> updateProfile () async {
    emit(ProfileLoading(
      user: this.state.user
    ));

    var response = await getUser(sl<AuthConfig>().token);

    response.fold(
      (failure) => emit(ProfileError(
        user: this.state.user,
        message: failure.message
      )), 
      (user) => emit(
        ProfileLoaded(
          user: user
        )
      )
    );
  }

  Future<void> setWallpaperFile (File file) async {
    return setWallpaper(file);
  }
}
