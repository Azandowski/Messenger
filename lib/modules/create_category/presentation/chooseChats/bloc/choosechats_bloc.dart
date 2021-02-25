import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/chat_entity.dart';

part 'choosechats_event.dart';
part 'choosechats_state.dart';

String url = 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png';
 
class ChooseChatsBloc extends Bloc<ChooseChatsEvent, ChooseChatsState> {
 
  ChooseChatsBloc() : super(ChooseChatsLoaded(chatEntities: List.generate(20, (index) => ChatEntity(
    chatId: index,
    imageUrl: url,
    title: 'Yelzhan Yerkebulan',
    chatCategories: ['Superwork', 'Microphone', 'MedApp']
  ))));

  @override
  Stream<ChooseChatsState> mapEventToState(
    ChooseChatsEvent event,
  ) async* {
    if(event is ChatChosen){
       yield* _mapTodoUpdatedToState(event);
    }
  }

    Stream<ChooseChatsState> _mapTodoUpdatedToState(ChatChosen event) async* {
    if (state is ChooseChatsLoaded) {
      final List<ChatEntity> updatedChats =
          (state as ChooseChatsLoaded).chatEntities.map((chat) {
        return chat.chatId == event.chat.chatId ? event.chat : chat;
      }).toList();
      yield ChooseChatsLoaded(chatEntities: updatedChats);
      // _saveTodos(updatedTodos);
    }
  }
}
