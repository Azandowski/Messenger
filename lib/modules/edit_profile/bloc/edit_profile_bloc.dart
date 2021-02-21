import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/edit_user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/profile_params.dart';
import '../../../main.dart';
import 'index.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final EditUser editUser;

  EditProfileBloc({
    @required this.editUser
  }) : super(EditProfileNormal());

  // MARK: - Main

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is EditProfileUpdateUser) {
      yield EditProfileLoading();
      yield* _eitherErrorOrSuccess(event);
    } else if (event is PickProfileImage) {
      var pickedFile = await ImagePicker().getImage(source: event.imageSource);
      imageFile = File(pickedFile.path);
      Navigator.of(navigatorKey.currentContext).pop();
      yield(EditProfileNormal(imageFile: imageFile));
    }
  }

  // MARK: - Handle operations 

  Stream<EditProfileState> _eitherErrorOrSuccess (EditProfileUpdateUser event) async* {
    var response = await editUser(EditUserParams(
      token: event.token,
      image: event.image,
      name: event.name,
      surname: event.surname,
      phoneNumber: event.phoneNumber,
      patronym: event.patronym
    ));
    
    yield response.fold(
      (failure) => EditProfileError(message: failure.message), 
      (_) => EditProfileSuccess());
  }

  // MARK: - Props

  File imageFile;
  TextEditingController nameTextController = TextEditingController();
  TextEditingController patronymTextController = TextEditingController();
  TextEditingController surnameTextController = TextEditingController();
}
