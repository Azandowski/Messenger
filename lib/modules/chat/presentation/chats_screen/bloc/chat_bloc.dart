import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, List<Message>> {
  final ChatRepository chatRepository;
  final int chatId;
  ChatBloc({
    @required this.chatRepository,
    @required this.chatId,
  }) : super([]){
    _chatSubscription = chatRepository.message.listen(
      (message) {
        add(MessageAdded(message: message));
      }
    );
  }
 
  StreamSubscription<Message> _chatSubscription;

  @override
  Stream<List<Message>> mapEventToState(ChatEvent event) async* {
    if(event is MessageAdded){
      print('messages added');
      var list = state.map((e) => e.copyWith()).toList();
      list.add(event.message);
      yield list.reversed.toList();
    }   
  }
}
