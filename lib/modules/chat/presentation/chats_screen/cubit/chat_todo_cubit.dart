import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_view_model.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/attachMessage.dart';
import '../../../domain/usecases/delete_message.dart';
import '../../../domain/usecases/params.dart';

import '../../../domain/entities/message.dart';

part 'chat_todo_state.dart';

class ChatTodoCubit extends Cubit<ChatTodoState> {
  final DeleteMessage deleteMessageUseCase;
  final AttachMessage attachMessageUseCase;
  ChatTodoCubit({
    @required this.deleteMessageUseCase,
    @required this.attachMessageUseCase,
  }) : super(ChatToDoDisabled());

  void selectMessage(Message newMessage){
    var messages = state.selectedMessages.map((e) => e.copyWith()).toList();
    messages.add(newMessage);
    emit(ChatTodoSelection(selectedMessages: messages, isDelete: this.state.isDelete));
  }

  void removeMessage(Message message){
     var messages = state.selectedMessages.map((e) => e.copyWith()).toList();
     messages.removeWhere((element) => element.id == message.id);
     emit(ChatTodoSelection(selectedMessages: messages, isDelete: this.state.isDelete));
  }

  void enableSelectionMode(Message message, bool isDelete){
    emit(ChatTodoSelection(selectedMessages: [message], isDelete: isDelete));
  }

  void disableSelectionMode(){
    emit(ChatToDoDisabled());
  }

  void deleteMessage({@required int chatID,@required  bool forMe}) async {
    emit(ChatToDoLoading(
      selectedMessages: this.state.selectedMessages,
      isDelete: true,
    ));
    var ids = this.state.selectedMessages.map((e) => e.id.toString()).join(',');
    final result = await deleteMessageUseCase(
      DeleteMessageParams(
        ids: ids,
        chatID: chatID,
        forMe: forMe ? 1 : 0,
      )
    );
    result.fold((l) => emit(ChatToDoError(errorMessage: l.message)), (r) => emit(ChatToDoDisabled()));
  }

  void replyMessageToMore({List<ChatViewModel> chatIds}) async {
    // emit(ChatToDoLoading(-
    //   selectedMessages: this.state.selectedMessages,
    //   isDelete: false,
    // ));
    var ids = this.state.selectedMessages.map((e) => e.id.toString()).join(',');
    //TODO: ADD New ReplyMore UseCase
   
  }

  void attachMessage(Message message) async {
    await attachMessageUseCase(message);
  }

}
