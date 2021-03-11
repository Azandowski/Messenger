import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';

import '../../../../../locator.dart';
import '../../../../../modules/category/domain/entities/chat_entity.dart';
import '../../../../../modules/chats/domain/repositories/chats_repository.dart';
import '../../../../../modules/chats/domain/usecase/get_chats.dart';
import '../../../../../modules/chats/domain/usecase/params.dart';
import '../../../../config/auth_config.dart';
import '../../../../services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/utils/list_helper.dart';

part 'chat_state.dart';

class ChatGlobalCubit extends Cubit<ChatState> {
  
  final ChatsRepository chatsRepository;
  final GetChats getChats;

  ChatGlobalCubit(
    this.chatsRepository,
    this.getChats
  ) : super(ChatLoading(
      chats: [],
      hasReachedMax: false,
      isPagination: false
    )) {

    // TODO: Uncomment this line
    // _chatsSubscription = chatsRepository.chatsController.stream
    //   .listen(
    //     (chats) => ChatsLoaded(
    //       chats: PaginatedResult(data: chats),
    //     )
    //   );
  }

  StreamSubscription<List<ChatEntity>> _chatsSubscription;

  // * * Manutally loading chats
  
  Future<void> loadChats ({
    @required bool isPagination
  }) async {
    emit(ChatLoading(
      chats: this.state.chats, 
      isPagination: false,
      hasReachedMax: false
    ));

    final response = await getChats(GetChatsParams(
      lastChatID: isPagination ? this.state.chats?.lastItem?.chatId : null,
      token: sl<AuthConfig>().token
    ));

    response.fold(
      (failure) => emit(ChatsError(
        chats: this.state.chats, 
        errorMessage: failure.message, 
        hasReachedMax: this.state.hasReachedMax
      )),
      (chatsResponse) {
        List<ChatEntity> newChats = isPagination ? (this.state.chats ?? []) + chatsResponse.data : chatsResponse.data;
        
        print('LOADED CHATS COUNT: ${newChats.length}');
        emit(ChatsLoaded( 
          chats: newChats,
          hasReachedMax: chatsResponse.hasReachMax ?? false
        ));
      }
    );
  }

  void leaveFromChat ({
    @required int id
  }) {
    var chats = this.state.chats.where((e) => e.chatId != id).map((e) => e.clone()).toList();

    emit(ChatsLoaded(
      hasReachedMax: this.state.hasReachedMax ?? false,
      chats: chats
    ));
  }

  void updateChatSettings ({
    @required ChatPermissions chatPermissions,
    @required int id
  }) {
    var newChat = this.state.chats.firstWhere((e) => e.chatId == id, orElse: () => null);
    if (newChat != null) {
      var updatedChat = newChat.clone(permissions: chatPermissions);

      var chats = this.state.chats.map((e) => e.chatId == id ? updatedChat : e.clone()).toList();

      emit(ChatsLoaded(
        hasReachedMax: this.state.hasReachedMax ?? false,
        chats: chats
      ));
    }
  }
}
