import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/edit_user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/profile_params.dart';
import 'index.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final EditUser editUser;

  EditProfileBloc({
    @required this.editUser
  }) : super(EditProfileNormal());

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is EditProfileUpdateUser) {
      yield EditProfileLoading();
      var response = await editUser(EditUserParams(
        token: event.token,
        image: event.image,
        name: event.name,
        surname: event.surname,
        phoneNumber: event.phoneNumber,
        patronym: event.patronym
      ));

      yield* response.fold(
        (failure) async* {
          yield EditProfileError(message: failure.message);
        }, (_) async* {
          yield EditProfileSuccess();
        });

    }    
  }
}
