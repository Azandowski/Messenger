import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../media/domain/usecases/get_image.dart';
import '../../../profile/domain/usecases/edit_user.dart';
import '../../../profile/domain/usecases/profile_params.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final EditUser editUser;
  final GetImage getImageUseCase;
  
  EditProfileCubit({
    @required this.editUser, 
    @required this.getImageUseCase
  }) : super(EditProfileLoading());

  Future<void> updateProfile(EditProfileUpdateUser event) async {
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
        emit(EditProfileSuccess());
      }
    );
  }

  void initProfile(EditProfileInit event) {
    nameTextController.text = event.user.name ?? '';
    patronymTextController.text = event.user.patronym ?? '';
    surnameTextController.text = event.user.surname ?? '';
    emit(EditProfileNormal(imageFile: imageFile));
  }

  Future<void> pickProfileImage(PickProfileImage event) async {
    print('taking');
    var pickedFile = await getImageUseCase(event.imageSource);
    pickedFile.fold(
        (l) => emit(EditProfileError(message: 'Unable to get image')), (image) {
      imageFile = image;
      emit(EditProfileNormal(imageFile: image));
    });
  }

  // MARK: - Local Data

  File imageFile;
  TextEditingController nameTextController = TextEditingController();
  TextEditingController patronymTextController = TextEditingController();
  TextEditingController surnameTextController = TextEditingController();
}
