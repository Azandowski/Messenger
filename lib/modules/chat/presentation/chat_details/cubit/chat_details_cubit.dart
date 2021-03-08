import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_chat_details.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_setting_item.dart';

part 'chat_details_state.dart';

class ChatDetailsCubit extends Cubit<ChatDetailsState> {
  
  final GetChatDetails getChatDetails;
  
  ChatDetailsCubit({
    @required this.getChatDetails
  }) : super(ChatDetailsLoading());

  Future<void> loadDetails (int id) async {
    var response =  await getChatDetails.call(id);

    response.fold(
      (failure) => emit(ChatDetailsError(
        chatDetailed: this.state.chatDetailed, 
        message: failure.message
      )), 
      (data) {
        emit(ChatDetailsLoaded(
          chatDetailed: data
        ));
      }
    );
  }

  void toggleChatSetting (ChatSettings settings, bool newValue) {
    ChatPermissions newPermissions;
    
    switch (settings) {
      case ChatSettings.noSound:
        newPermissions = this.state.chatDetailed.settings?.copyWith(
          isSoundOn: newValue
        ) ?? ChatPermissions(isSoundOn: newValue, isMediaSendOn: false);
        break;
      case ChatSettings.noMedia:
        newPermissions = this.state.chatDetailed.settings?.copyWith(
          isMediaSendOn: newValue
        ) ?? ChatPermissions(isSoundOn: false, isMediaSendOn: newValue);
        break;
    }

    var newState = this.state.copyWith(chatDetailed: this.state.chatDetailed.copyWith(
      settings: newPermissions
    ));

    // TODO: Send chat setting update request

    emit(newState);
  }
}
