import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_entity_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/get_chats.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/params.dart';

import '../../../../../locator.dart';
import '../../../../../main.dart';

part 'chats_cubit_state.dart';

class ChatsCubit extends Cubit<ChatsCubitState> {

  final GetChats getChats;

  PaginationData paginationData = PaginationData(
    isFirstPage: true,
    nextPageUrl: null
  );

  ChatsCubit(this.getChats) : super(
    ChatsCubitLoading(
      chats: PaginatedResult(data: []),
      currentTabIndex: 0
    )
  );
  
  // * * Methods

  void tabUpdate(int index) {
    emit(ChatsCubitLoaded(
      currentTabIndex: index,
      chats: this.state.chats
    ));
  }

  Future<void> loadAllChats () async {
    String token = sl<AuthConfig>().token;
    var response = await getChats(GetChatsParams(
      token: token,
      paginationData: paginationData
    ));

    response.fold(
      (failure) => emit(ChatsCubitError(
        errorMessage: failure.message,
        chats: this.state.chats,
        currentTabIndex: this.state.currentTabIndex
      )), 
      (loadedChats) {
        emit(ChatsCubitLoaded(
          chats: loadedChats, 
          currentTabIndex: this.state.currentTabIndex
        ));
      }
    );
  }

  void didSelectChat(int index) {
    emit(
      ChatsCubitSelectedOne(
        chats: this.state.chats, 
        currentTabIndex: this.state.currentTabIndex, 
        selectedChatIndex: index
      )
    );
  }

  void didCancelChatSelection () {
    emit(
      ChatsCubitLoaded(
        chats: this.state.chats, 
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

  ChatEntityModel get selectedChat {
    if (this.state is ChatsCubitSelectedOne) {
      int index = (this.state as ChatsCubitSelectedOne).selectedChatIndex;
      return this.state.chats.data[index];
    } else {
      return null;
    }
  }
}
