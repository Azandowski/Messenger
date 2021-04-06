import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/config/auth_config.dart';
import '../../../../../core/utils/list_helper.dart';
import '../../../../../locator.dart';
import '../../../../chats/domain/entities/category.dart';
import '../../../../chats/domain/usecase/get_category_chats.dart';
import '../../../../chats/domain/usecase/params.dart';
import '../../../../media/domain/usecases/get_image.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../../domain/entities/create_category_screen_params.dart';
import '../../../domain/usecases/create_category.dart';
import '../../../domain/usecases/params.dart';
import '../../../domain/usecases/transfer_chat.dart';

part 'create_category_state.dart';

class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  // * * Constructor

  final CreateCategoryUseCase createCategory;
  final GetImage getImageUseCase;
  final TransferChats transferChats;
  final GetCategoryChats getCategoryChats;
  final AuthConfig authConfig;

  CreateCategoryCubit(
      {@required this.createCategory,
      @required this.getImageUseCase,
      @required this.authConfig,
      @required this.transferChats,
      @required this.getCategoryChats})
      : super(CreateCategoryLoading(
            imageFile: null, chats: [], hasReachMax: true)) {
    initCubit();
  }

  // * * Events

  void initCubit() {
    emit(CreateCategoryNormal(
        imageFile: this.state.imageFile, chats: [], hasReachMax: true));
  }

  Future<void> selectPhoto(ImageSource imageSource) async {
    var pickedFile = await getImageUseCase(imageSource);
    pickedFile.fold(
        (failure) => emit(CreateCategoryError(message: 'Unable to get image')),
        (image) {
      emit(CreateCategoryNormal(
          imageFile: image,
          chats: this.state.chats,
          hasReachMax: state.hasReachMax));
    });
  }

  Future<void> sendData(CreateCategoryScreenMode mode, int categoryId) async {
    emit(CreateCategoryLoading(
        imageFile: this.state.imageFile,
        chats: this.state.chats,
        hasReachMax: state.hasReachMax));

    var response = await createCategory(CreateCategoryParams(
        token: sl<AuthConfig>().token,
        avatarFile: this.state.imageFile,
        name: nameController.text,
        chatIds: (this.state.chats ?? []).map((e) => e.chatId).toList(),
        isCreate: mode == CreateCategoryScreenMode.create,
        categoryID: categoryId));

    response.fold(
        (failure) => emit(CreateCategoryError(
            message: failure.message,
            imageFile: this.state.imageFile,
            chats: this.state.chats,
            hasReachMax: state.hasReachMax)),
        (categories) => emit(CreateCategorySuccess(
            updatedCategories: categories,
            chats: this.state.chats,
            imageFile: this.state.imageFile,
            hasReachMax: state.hasReachMax)));
  }

  Future<void> doTransferChats(int newCategory) async {
    emit(CreateCategoryTransferLoading(
        chats: this.state.chats,
        imageFile: this.state.imageFile,
        categoryID: newCategory,
        chatsIDs: movingChats,
        hasReachMax: state.hasReachMax));

    var response = await transferChats(
        TransferChatsParams(newCategoryId: newCategory, chatsIDs: movingChats));

    response.fold(
        (failure) => emit(CreateCategoryError(
              message: failure.message,
              imageFile: this.state.imageFile,
              chats: this.state.chats,
            )), (_) {
      var updatedChats = this
          .state
          .chats
          .where((e) => !movingChats.contains(e.chatId))
          .map((e) => e.clone())
          .toList();
      emit(CreateCategoryFinishedTransfer(
          imageFile: this.state.imageFile,
          chats: updatedChats,
          hasReachMax: state.hasReachMax,
          categoryID: newCategory,
          chatID: movingChats.getItemAt(0)));
    });
  }

  void addChats(List<ChatEntity> comingChats) {
    List<ChatEntity> newChats = [...comingChats, ...state.chats];

    emit(CreateCategoryNormal(
        imageFile: this.state.imageFile,
        chats: newChats,
        hasReachMax: state.hasReachMax));
  }

  Future<void> prepareEditing(CategoryEntity entity) async {
    nameController.text = entity.name;
    defaultImageUrl = entity.avatar;

    emit(CreateCategoryChatsLoading(
        imageFile: null, chats: [], hasReachMax: state.hasReachMax));

    var response = await getCategoryChats(GetCategoryChatsParams(
      token: sl<AuthConfig>().token,
      categoryID: entity.id,
    ));

    response.fold(
        (failure) => emit(CreateCategoryError(
            message: failure.message,
            imageFile: this.state.imageFile,
            chats: this.state.chats)),
        (chats) => emit(CreateCategoryNormal(
            imageFile: this.state.imageFile,
            chats: chats.data,
            hasReachMax: chats.hasReachMax)));
  }

  Future<void> loadChatsNextPage(int entityID) async {
    emit(CreateCategoryChatsLoading(
        imageFile: state.imageFile,
        chats: state.chats,
        hasReachMax: state.hasReachMax));

    var response = await getCategoryChats(GetCategoryChatsParams(
        token: sl<AuthConfig>().token,
        categoryID: entityID,
        lastChatID: state.chats.lastItem?.chatId));

    response.fold(
        (failure) => emit(CreateCategoryError(
            message: failure.message,
            imageFile: this.state.imageFile,
            chats: this.state.chats)),
        (chats) => emit(CreateCategoryNormal(
            imageFile: this.state.imageFile,
            chats: [...state.chats, ...chats.data],
            hasReachMax: chats.hasReachMax)));
  }

  // * * Local Data

  List<int> movingChats = [];

  String defaultImageUrl;

  TextEditingController nameController = TextEditingController();
}
