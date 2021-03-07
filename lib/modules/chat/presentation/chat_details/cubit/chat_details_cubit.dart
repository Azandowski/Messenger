import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_chat_details.dart';

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
}
