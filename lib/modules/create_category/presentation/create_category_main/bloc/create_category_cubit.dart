import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/modules/create_category/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/media/domain/usecases/get_image.dart';
import '../../../../../locator.dart';
import '../../../../chats/domain/entities/category.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../../domain/usecases/create_category.dart';

part 'create_category_state.dart';

class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  
  // * * Constructor
  
  final CreateCategoryUseCase createCategory;
  final GetImage getImageUseCase;

  CreateCategoryCubit({
    @required this.createCategory,
    @required this.getImageUseCase,
  }) : super(CreateCategoryLoading()) {
    initCubit();
  }

  // * * Events

  void initCubit () {
    emit(CreateCategoryNormal(
      imageFile: imageFile, 
      chats: [])
    );
  }

  Future<void> selectPhoto (ImageSource imageSource) async {
    var pickedFile = await getImageUseCase(imageSource);
    pickedFile.fold(
      (failure) => emit(CreateCategoryError(message: 'Unable to get image')), 
      (image) {
        imageFile = image;
        emit(CreateCategoryNormal(imageFile: imageFile, chats: chats));
    });
  }

  Future<void> sendData () async {
    // TODO: Update Chat IDS
    emit(CreateCategoryLoading());
    var response = await createCategory(CreateCategoryParams(
      token: sl<AuthConfig>().token, 
      avatarFile: imageFile, 
      name: nameController.text, 
      chatIds: []
    ));

    response.fold(
      (failure) => emit(CreateCategoryError(message: failure.message)), 
      (categories) => emit(CreateCategorySuccess(updatedCategories: categories)));
  }

  void addChats (List<ChatEntity> comingChats){
    chats = comingChats;

    emit(CreateCategoryNormal(
      imageFile: imageFile, 
      chats: chats)
    );
  }

  void deleteChat (ChatEntity chat){
    var updatedChats = (state as CreateCategoryNormal).chats;
    updatedChats.remove(chat);
    chats = updatedChats;

    emit(CreateCategoryNormal(
      imageFile: imageFile, 
      chats: chats)
    );
  }

  // * * Local Data

  File imageFile;

  TextEditingController nameController = TextEditingController();

  int chatCounts = 0;

  List<ChatEntity> chats = [];
}
