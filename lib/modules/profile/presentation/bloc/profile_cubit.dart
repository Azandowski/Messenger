import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/auth_config.dart';
import '../../../authentication/domain/usecases/get_current_user.dart';
import 'index.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetCurrentUser getUser;
  final AuthConfig authConfig;

  ProfileCubit({
    @required this.getUser,
    @required this.authConfig,
  }) : super(ProfileLoaded(user: authConfig.user));

  Future<void> updateProfile() async {
    emit(ProfileLoading(user: this.state.user));

    var response = await getUser(authConfig.token);

    response.fold(
        (failure) => emit(ProfileError(
              user: this.state.user,
              message: failure.message,
            )), (user) {
      print(user.fullName);

      emit(
        ProfileLoaded(user: user),
      );
    });
  }
}
