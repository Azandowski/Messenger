import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
part 'chats_cubit_state.dart';

class ChatsCubit extends Cubit<ChatsCubitState> {

  ChatsCubit()
      : super(ChatsCubitNormal(
            index: 0,
            chatListsState: ChatListsLoading(),));


  void tabUpdate(int index) {
    ChatListsState listsState = this.state is ChatsCubitNormal
        ? (this.state as ChatsCubitNormal).chatListsState
        : ChatListsLoading();
    emit(ChatsCubitNormal(
        index: index,
        chatListsState: listsState));
  }

  // MARK: - Getters

  ChatListsState get currentListsState {
    return this.state is ChatsCubitNormal
      ? (this.state as ChatsCubitNormal).chatListsState
      : ChatListsLoading();
  }

}
