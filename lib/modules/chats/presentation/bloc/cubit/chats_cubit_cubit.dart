import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';


part 'chats_cubit_state.dart';

class ChatsCubit extends Cubit<ChatsCubitState> {
  ChatsCubit() : super(
    ChatsCubitStateNormal(
      currentTabIndex: 0,
    )
  );
  
  // * * Methods

  void tabUpdate(int index) {
    emit(ChatsCubitStateNormal(
      currentTabIndex: index,
    ));
  }

  void didSelectChat(int index) {
    emit(
      ChatsCubitSelectedOne(
        currentTabIndex: this.state.currentTabIndex, 
        selectedChatIndex: index
      )
    );
  }

  void didCancelChatSelection () {
    emit(
      ChatsCubitStateNormal(
        currentTabIndex: this.state.currentTabIndex
      )
    );
  }

  // * * Useful Getters

  int get selectedChatIndex {
    if (this.state is ChatsCubitSelectedOne) {
      return (this.state as ChatsCubitSelectedOne).selectedChatIndex;
    } else {
      return null;
    }
  }

  ChatEntity get selectedChat {
    return null;
  }
}
