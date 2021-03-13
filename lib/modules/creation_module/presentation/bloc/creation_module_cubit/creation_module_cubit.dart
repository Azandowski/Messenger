import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/groupChat/domain/usecases/create_chat_group.dart';
import 'package:messenger_mobile/modules/groupChat/domain/usecases/params.dart';

import '../../../../../locator.dart';

part 'creation_module_state.dart';

class CreationModuleCubit extends Cubit<CreationModuleState> {

  final CreateChatGruopUseCase createChatGruopUseCase;

  CreationModuleCubit({
    @required this.createChatGruopUseCase
  }) : super(CreationModuleInitial());


  Future<void> createChatWithUser (int userID) async {
    emit(CreationModuleLoading());

    var response = await createChatGruopUseCase(CreateChatGroupParams(
      isCreate: true,
      token: sl<AuthConfig>().token,
      contactIds: [userID],
      isPrivate: true
    ));

    response.fold(
      (failure) => emit(CreationModuleError(message: failure.message)), 
      (output) => emit(
        OpenChatWithUser(newChat: output)
    ));
  }
}
