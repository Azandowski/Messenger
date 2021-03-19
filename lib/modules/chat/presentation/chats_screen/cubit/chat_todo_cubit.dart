
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/widgets/independent/dialogs/achievment_view.dart';
import '../../../../category/domain/entities/chat_entity.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/usecases/attachMessage.dart';
import '../../../domain/usecases/delete_message.dart';
import '../../../domain/usecases/disattachMessage.dart';
import '../../../domain/usecases/params.dart';
import '../../../domain/usecases/reply_more.dart';

part 'chat_todo_state.dart';

class ChatTodoCubit extends Cubit<ChatTodoState> {
  final BuildContext context;
  final DeleteMessage deleteMessageUseCase;
  final AttachMessage attachMessageUseCase;
  final DisAttachMessage disAttachMessageUseCase;
  final ReplyMore replyMoreUseCase;
  ChatTodoCubit({
    @required this.deleteMessageUseCase,
    @required this.disAttachMessageUseCase,
    @required this.attachMessageUseCase,
    @required this.replyMoreUseCase,
    @required this.context,
  }) : super(ChatToDoDisabled());

  void selectMessage(Message newMessage){
    var messages = (state.selectedMessages ?? []).map((e) => e.copyWith()).toList();
    messages.add(newMessage);
    emit(ChatTodoSelection(selectedMessages: messages, isDelete: this.state.isDelete));
  }

  void removeMessage(Message message){
     var messages = (state.selectedMessages ?? []).map((e) => e.copyWith()).toList();
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

  void replyMessageToMore({List<ChatEntity> chatIds}) async {
    emit(ChatToDoLoading(
      selectedMessages: this.state.selectedMessages,
      isDelete: false,
    ));
    var messageIds = this.state.selectedMessages.map((e) => e.id).toList();
    var chatsId = chatIds.map((e) => e.chatId).toList();
    final response = await replyMoreUseCase(ReplyMoreParams(chatIds: chatsId, messageIds: messageIds));
    
    response.fold((l) => emit(ChatToDoError(errorMessage: l.message)), (r) { 
      emit(ChatToDoDisabled());
      AchievementService().showAchievmentView(
        context: context,
        isError: false,
        mainText: 'Успешно',
        subTitle: 'Все сообщения пересланы'
      );  
    });
  }

  void attachMessage(Message message) async {
    await attachMessageUseCase(message);
  }

  void disattachMessage() async {
    await disAttachMessageUseCase(NoParams());
  }
}
