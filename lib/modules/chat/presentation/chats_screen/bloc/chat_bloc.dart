import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/send_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {

  final ChatRepository chatRepository;
  final SendMessage sendMessage;
  final int chatId;

  var _random = Random();

  ChatBloc({
    @required this.chatRepository,
    @required this.chatId,
    @required this.sendMessage,
  }) : super(ChatInitial(messages:[])){
    _chatSubscription = chatRepository.message.listen(
      (message) {
        add(MessageAdded(message: message));
      }
    );
  }
 
  StreamSubscription<Message> _chatSubscription;

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if(event is MessageAdded){
      
      var list = getCopyMessages();
      var i = list.indexWhere((element) => element.identificator == event.message.id);
      if(i != -1){
        list.removeAt(i);
      }
      list.insert(0,event.message);
      yield ChatInitial(messages: list);

    }else if(event is MessageSend){
      var list = getCopyMessages();
      int randomID = _random.nextInt(99999);
      var newMessage = Message(
        user: MessageUser(
          id: sl<AuthConfig>().user.id,
        ),
        text: event.message,
        identificator: randomID,
        isRead: false,
        messageStatus: MessageStatus.sending,
      );
      list.insert(0, newMessage);    

      yield ChatInitial(messages: list);
      final response = await sendMessage(SendMessageParams(
        chatID: chatId,
        text: event.message,
        identificator: randomID,
      ));

      yield* _eitherSentOrErrorState(response);
      
    }
  }

  Stream<ChatState> _eitherSentOrErrorState(
      Either<Failure, Message> failureOrMessage,
    ) async* {
      var list = getCopyMessages();
      yield failureOrMessage.fold(
        (failure) => ChatInitial(messages: list),
        (message) {
          var i = list.indexWhere((element) => element.identificator == message.identificator);
          list[i]= message.copyWith(identificator: message.id);
          return ChatInitial(messages: list);
        });
    }

  List<Message> getCopyMessages() => state.messages.map((e) => e.copyWith()).toList();
}
