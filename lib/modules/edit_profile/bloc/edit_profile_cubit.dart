import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/modules/edit_profile/bloc/edit_profile_event.dart';
import 'package:messenger_mobile/modules/edit_profile/bloc/edit_profile_state.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/edit_user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/profile_params.dart';

import '../../../main.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final EditUser editUser;
  
  EditProfileCubit({
    @required this.editUser
  }) : super(EditProfileLoading());

  Future<void> updateProfile (EditProfileUpdateUser event) async {
    emit(EditProfileLoading());
    var response = await editUser(EditUserParams(
      token: event.token,
      image: event.image,
      name: event.name,
      surname: event.surname,
      phoneNumber: event.phoneNumber,
      patronym: event.patronym
    ));

    response.fold(
      (failure) => {
        emit(EditProfileError(message: failure.message))
      }, 
      (_) {
        emit(EditProfileError(message: 'ERROR HAPPENED'));
        // emit(EditProfileSuccess());
      });
  }

  void initProfile (EditProfileInit event) {
    nameTextController.text = event.user.name ?? '';
    patronymTextController.text = event.user.patronym ?? '';
    surnameTextController.text = event.user.surname ?? '';
    emit(EditProfileNormal(imageFile: imageFile));
  }

  Future<void> pickProfileImage (PickProfileImage event) async {
    var pickedFile = await ImagePicker().getImage(source: event.imageSource);
    imageFile = File(pickedFile.path);
    Navigator.of(navigatorKey.currentContext).pop();
    emit(EditProfileNormal(imageFile: imageFile));
  }

  // MARK: - Local Data

  File imageFile;
  TextEditingController nameTextController = TextEditingController();
  TextEditingController patronymTextController = TextEditingController();
  TextEditingController surnameTextController = TextEditingController();
}

