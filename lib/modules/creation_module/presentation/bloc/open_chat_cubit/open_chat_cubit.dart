import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/groupChat/domain/usecases/create_chat_group.dart';
import 'package:messenger_mobile/modules/groupChat/domain/usecases/params.dart';

import '../../../../../locator.dart';

part 'open_chat_state.dart';

class OpenChatCubit extends Cubit<OpenChatState> {
  
  final CreateChatGruopUseCase createChatGruopUseCase;
  
  OpenChatCubit({
    @required this.createChatGruopUseCase
  }) : super(OpenChatInitial()); 

    Future<void> createChatWithUser (int userID) async {
    emit(OpenChatLoading());

    var response = await createChatGruopUseCase(CreateChatGroupParams(
      isCreate: true,
      token: sl<AuthConfig>().token,
      contactIds: [userID],
      isPrivate: true
    ));

    response.fold(
      (failure) => emit(OpenChatError(message: failure.message)), 
      (output) => emit(
        OpenChatDone(newChat: output)
    ));
  }
}
