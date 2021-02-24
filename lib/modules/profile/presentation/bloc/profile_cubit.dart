import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/locator.dart';
import '../../domain/usecases/get_user.dart';
import 'index.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUser getUser;

  ProfileCubit({
    @required this.getUser,
  }) : super(ProfileLoaded(user: sl<AuthConfig>().user));
}
