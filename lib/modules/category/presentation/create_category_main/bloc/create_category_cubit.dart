import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/transfer_chat.dart';
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
  final TransferChats transferChats;

  CreateCategoryCubit({
    @required this.createCategory,
    @required this.getImageUseCase,
    @required this.transferChats
  }) : super(CreateCategoryLoading(
    imageFile: null,
    chats: []
  )) {
    initCubit();
  }

  // * * Events

  void initCubit () {
    emit(CreateCategoryNormal(
      imageFile: this.state.imageFile, 
      chats: [])
    );
  }

  Future<void> selectPhoto (ImageSource imageSource) async {
    var pickedFile = await getImageUseCase(imageSource);
    pickedFile.fold(
      (failure) => emit(CreateCategoryError(message: 'Unable to get image')), 
      (image) {
        emit(CreateCategoryNormal(imageFile: image, chats: this.state.chats));
    });
  }

  Future<void> sendData () async {
    // TODO: Update Chat IDS
    
    emit(CreateCategoryLoading(
      imageFile: this.state.imageFile,
      chats: this.state.chats
    ));
    
    var response = await createCategory(CreateCategoryParams(
      token: sl<AuthConfig>().token, 
      avatarFile: this.state.imageFile,
      name: nameController.text, 
      chatIds: []
    ));

    response.fold(
      (failure) => emit(CreateCategoryError(message: failure.message)), 
      (categories) => emit(CreateCategorySuccess(
        updatedCategories: categories,
        chats: this.state.chats,
        imageFile: this.state.imageFile
      ))
    );
  }

  Future<void> doTransferChats (int newCategory) async {
    emit(CreateCategoryTransferLoading(
      chats: this.state.chats, 
      imageFile: this.state.imageFile, 
      categoryID: newCategory, 
      chatsIDs: movingChats
    ));
    
    var response = await transferChats(TransferChatsParams(
      newCategoryId: newCategory, chatsIDs: movingChats
    ));

    response.fold(
      (failure) => emit(CreateCategoryError(message: failure.message)), 
      (_) {
        var updatedChats = this.state.chats
          .where((e) => !movingChats.contains(e.chatId))
          .map((e) => e.clone()).toList();
        emit(CreateCategoryNormal(
          imageFile: this.state.imageFile, 
          chats: updatedChats)
        );
    });
  } 

  void addChats (List<ChatEntity> comingChats){
    emit(CreateCategoryNormal(
      imageFile: this.state.imageFile, 
      chats: comingChats)
    );
  }

  void deleteChat (ChatEntity chat){
    var updatedChats = this.state.chats
      .where((e) => e.chatId != chat.chatId)
      .map((e) => e.clone()).toList();

    emit(CreateCategoryNormal(
      imageFile: this.state.imageFile, 
      chats: updatedChats)
    );
  }

  // * * Local Data
   
  List<int> movingChats = [];

  TextEditingController nameController = TextEditingController();
}
