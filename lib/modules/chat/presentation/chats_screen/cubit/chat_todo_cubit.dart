import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../domain/usecases/delete_message.dart';
import '../../../domain/usecases/params.dart';

import '../../../domain/entities/message.dart';

part 'chat_todo_state.dart';

class ChatTodoCubit extends Cubit<ChatTodoState> {
  DeleteMessage deleteMessageUseCase;

  ChatTodoCubit({
    @required this.deleteMessageUseCase,
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
      isDelete: this.state.isDelete,
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


}
