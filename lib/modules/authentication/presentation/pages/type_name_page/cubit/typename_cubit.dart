import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/config/auth_config.dart';
import '../../../../../../locator.dart';
import '../../../../../media/domain/usecases/get_image.dart';
import '../../../../../profile/domain/entities/user.dart';
import '../../../../../profile/domain/usecases/edit_user.dart';
import '../../../../../profile/domain/usecases/profile_params.dart';
import '../../../../domain/usecases/get_current_user.dart';

part 'typename_state.dart';

class TypeNameCubit extends Cubit<TypeNameState> {
  final GetImage getImageUseCase;
  final EditUser editUserUseCase;
  final GetCurrentUser getCurrenUserUseCase;
  TypeNameCubit({
    @required this.getImageUseCase,
    @required this.editUserUseCase,
    @required this.getCurrenUserUseCase,
  }) : super(TypenameInitial()) {
    nameCtrl =
        TextEditingController(text: sl<AuthConfig>().user.fullName ?? '');
  }
  void getImage(ImageSource source) async {
    var imageOrError = await getImageUseCase(source);
    imageOrError.fold((l) => emit(ErrorSelecting()),
        (image) => emit(FileSelected(imageFile: image)));
  }

  Future<void> updateProfile(File image) async {
    emit(UpdatingUser());
    var fullNameArr = getFullName();
    var response = await editUserUseCase(EditUserParams(
        token: sl<AuthConfig>().token,
        image: image,
        name: fullNameArr[1],
        surname: fullNameArr[0],
        patronym: fullNameArr[2]));

    response.fold((l) => emit(ErrorUploading()), (r) {
      print('started');
      getCurrenUserUseCase(sl<AuthConfig>().token);
    });
  }

  List<String> getFullName() {
    var arr = nameCtrl.text.split(" ");
    return [
      arr.length >= 1 ? (arr[0] ?? "") : "",
      arr.length >= 2 ? (arr[1] ?? "") : "",
      arr.length >= 3 ? (arr[2] ?? "") : ""
    ];
  }

  TextEditingController nameCtrl;

  init(User user) {
    nameCtrl = TextEditingController(text: user.name ?? '');
  }
}
