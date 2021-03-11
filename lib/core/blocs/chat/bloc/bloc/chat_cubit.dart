import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/get_category_chats.dart';

import '../../../../../locator.dart';
import '../../../../../modules/category/domain/entities/chat_entity.dart';
import '../../../../../modules/chats/domain/repositories/chats_repository.dart';
import '../../../../../modules/chats/domain/usecase/get_chats.dart';
import '../../../../../modules/chats/domain/usecase/params.dart';
import '../../../../config/auth_config.dart';
import 'package:messenger_mobile/core/utils/list_helper.dart';

part 'chat_state.dart';

class ChatGlobalCubit extends Cubit<ChatState> {
  
  final ChatsRepository chatsRepository;
  final GetChats getChats;
  final GetCategoryChats getCategoryChats;

  ChatGlobalCubit(
    this.chatsRepository,
    this.getChats,
    this.getCategoryChats
  ) : super(ChatLoading(
      chats: [],
      hasReachedMax: false,
      isPagination: false,
      currentCategory: 0
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
    @required bool isPagination,
    int categoryID
  }) async {
    
    emit(ChatLoading(
      chats: isPagination ? this.state.chats : [], 
      isPagination: false,
      hasReachedMax: false,
      currentCategory: categoryID
    ));

    Either<Failure, PaginatedResultViaLastItem<ChatEntity>> response;

    if (categoryID == null) {
      response = await getChats(GetChatsParams(
        lastChatID: isPagination ? this.state.chats?.lastItem?.chatId : null,
        token: sl<AuthConfig>().token
      ));
    } else {
      response = await getCategoryChats(GetCategoryChatsParams(
        token: sl<AuthConfig>().token,
        categoryID: categoryID,
        lastChatID: isPagination ? this.state.chats?.lastItem?.chatId : null
      ));
    }

    response.fold(
      (failure) => emit(ChatsError(
        chats: this.state.chats, 
        errorMessage: failure.message, 
        hasReachedMax: this.state.hasReachedMax,
        currentCategory: this.state.currentCategory
      )),
      (chatsResponse) {
        if (this.state.currentCategory == categoryID) {
          List<ChatEntity> newChats = isPagination ? (this.state.chats ?? []) + chatsResponse.data : chatsResponse.data;
          emit(ChatsLoaded( 
            chats: newChats,
            hasReachedMax: chatsResponse.hasReachMax ?? false,
            currentCategory: this.state.currentCategory)
          );
        }
      }
    );
  }


  void leaveFromChat ({
    @required int id
  }) {
    var chats = this.state.chats.where((e) => e.chatId != id).map((e) => e.clone()).toList();

    emit(ChatsLoaded(
      hasReachedMax: this.state.hasReachedMax ?? false,
      chats: chats,
      currentCategory: this.state.currentCategory
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
        chats: chats,
        currentCategory: this.state.currentCategory
      ));
    }
  }
}
