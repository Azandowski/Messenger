import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_view_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';

import '../../../../../core/config/auth_config.dart';
import '../../../../../locator.dart';
import '../../../../creation_module/domain/entities/contact.dart';
import '../../../../media/domain/usecases/get_image.dart';
import '../../../domain/usecases/create_chat_group.dart';
import '../../../domain/usecases/params.dart';

part 'creategroup_state.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  
  final GetImage getImageUseCase;
  final CreateChatGruopUseCase createChatGruopUseCase;
  
  
  CreateGroupCubit({
    @required this.getImageUseCase,
    @required this.createChatGruopUseCase,
  }) : super(CreateGroupNormal(
    contacts: [],
    imageFile: null
  ));

  Future<void> selectPhoto (ImageSource imageSource) async {
    var pickedFile = await getImageUseCase(imageSource);
    pickedFile.fold(
      (failure) => emit(CreateCategoryError(
        message: 'Unable to get image',
        contacts: this.state.contacts,
        imageFile: this.state.imageFile
      )), 
      (image) {
        emit(CreateGroupNormal(imageFile: image, contacts: this.state.contacts));
    });
  }

  void addContacts (List<ContactEntity> comingContacts){
    emit(CreateGroupNormal(
      imageFile: this.state.imageFile, 
      contacts: comingContacts)
    );
  }

  void deleteContact (ContactEntity contact){
    var updatedContacts = this.state.contacts
      .where((e) => e.id != contact.id)
      .map((e) => e.copyWith()).toList();

    emit(CreateGroupNormal(
      imageFile: this.state.imageFile, 
      contacts: updatedContacts)
    );
  }

  Future createChat(
    String name, 
    String desc,
    {
      bool isCreate = true,
      int chatID
    }
  ) async {
    emit(CreateGroupLoading(
      imageFile: this.state.imageFile,
      contacts: this.state.contacts
    ));
    
    var response = await createChatGruopUseCase(CreateChatGroupParams(
      token: sl<AuthConfig>().token, 
      avatarFile: this.state.imageFile,
      name: name, 
      description: desc,
      contactIds: isCreate ? 
        (this.state.contacts ?? []).map((e) => e.id).toList() : [],
      isCreate: isCreate,
      chatGroupId: chatID
    ));

    response.fold(
      (failure) => emit(CreateCategoryError(
        message: failure.message,
        contacts: this.state.contacts,
        imageFile: this.state.imageFile
      )), 
      (categories) => emit(CreateGroupSuccess(
        contacts: this.state.contacts,
        imageFile: this.state.imageFile
      ))
    );
  }

  void initReadyEntity (ChatEntity entity) {

    defaultImageUrl = ChatViewModel(entity).imageURL;

    emit(CreateGroupNormal(
      imageFile: null, 
      contacts: []
    ));
  }

  /// Initial image URL
  /// Will not be null if editing the group chat only

  String defaultImageUrl;
}
