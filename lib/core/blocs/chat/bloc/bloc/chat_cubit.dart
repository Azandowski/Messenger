import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';

import '../../../../../locator.dart';
import '../../../../../modules/category/domain/entities/chat_entity.dart';
import '../../../../../modules/category/domain/entities/chat_permissions.dart';
import '../../../../../modules/chats/domain/repositories/chats_repository.dart';
import '../../../../../modules/chats/domain/usecase/get_category_chats.dart';
import '../../../../../modules/chats/domain/usecase/get_chats.dart';
import '../../../../../modules/chats/domain/usecase/params.dart';
import '../../../../config/auth_config.dart';
import '../../../../error/failures.dart';
import '../../../../services/network/paginatedResult.dart';
import '../../../../utils/list_helper.dart';

part 'chat_state.dart';

class ChatGlobalCubit extends Cubit<ChatState> {
  
  final ChatsRepository chatsRepository;
  final GetChats getChats;
  final GetCategoryChats getCategoryChats;

  int lastCategoryID;

  ChatGlobalCubit(
    this.chatsRepository,
    this.getChats,
    this.getCategoryChats,
  ) : super(ChatLoading(
      chats: [],
      hasReachedMax: false,
      isPagination: false,
      currentCategory: 0
    )) {

    _chatsSubscription = chatsRepository.chats.listen((chat) {
      chatsRepository.saveNewChatLocally(chat);

      var chatIndex = this.state.chats.indexWhere((e) => e.chatId == chat.chatId);
      if (lastCategoryID == null || lastCategoryID == chat.chatCategory?.id)  {
        if (chatIndex == -1) {
          List<ChatEntity> newChats = [...this.state.chats, chat];
          emit(ChatsLoaded(
            currentCategory: this.state.currentCategory,
            hasReachedMax: this.state.hasReachedMax,
            chats: newChats
          ));
        } else {
          var newChats = this.state.chats.map((e) => e.clone()).toList();
          newChats.removeAt(chatIndex);
          newChats.insert(0, chat);
          
          emit(ChatsLoaded(
            currentCategory: this.state.currentCategory,
            hasReachedMax: this.state.hasReachedMax,
            chats: newChats
          ));
        }
      }

      var _chatIndex = this.state.chats.indexWhere((e) => e.chatId == chat.chatId);
      
      if (_chatIndex != -1) {
        /// Если до этого количество непрочитанных был [0]
        /// Значит нам нужно увеличить количество непрочитанных чатов в
        /// [CategoryBloc]

        if (this.state.chats[_chatIndex].unreadCount == 0) {
          emit(ChatCategoryReadCountChanged(
            chats: this.state.chats,
            currentCategory: this.state.currentCategory,
            hasReachedMax: this.state.hasReachedMax,
            categoryID: this.state.chats[_chatIndex].chatCategory?.id, 
            newReadCount: (this.state.chats[_chatIndex].chatCategory?.noReadCount ?? 0) + 1)
          );
        }
      }
    });
  }

  StreamSubscription<ChatEntity> _chatsSubscription;

  // * * Manutally loading chats
  
  Future<void> loadChats ({
    @required bool isPagination,
    int categoryID
  }) async {
    lastCategoryID = categoryID;

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


  void killAllCaches () {
    chatsRepository.removeAllChats();
    emit(ChatsLoaded(
      hasReachedMax: false,
      chats: [],
      currentCategory: 0
    ));
  }

  void resetChatNoReadCounts ({
    @required int chatId
  }) {
    int index = this.state.chats.indexWhere((element) => element.chatId == chatId);
    if (index != -1) {
      var newChatModel = this.state.chats[index].clone(unreadCount: 0);
      var newChats = this.state.chats.map((e) => e.chatId == chatId ? newChatModel : e.clone()).toList();
      chatsRepository.saveNewChatLocally(newChatModel);

      emit(ChatsLoaded(
        hasReachedMax: this.state.hasReachedMax ?? false,
        chats: newChats,
        currentCategory: this.state.currentCategory
      ));
    }
  }

  void setSecretMode ({
    @required bool isOn,
    @required int chatId
  }) {  
    int index = this.state.chats.indexWhere((element) => element.chatId == chatId);
    if (index != -1) {
      var newChatModel = this.state.chats[index].clone(
        permissions: this.state.chats[index].permissions.copyWith(isSecret: isOn)
      );
      
      var newChats = this.state.chats.map((e) => e.chatId == chatId ? newChatModel : e.clone()).toList();
      
      emit(ChatsLoaded(
        hasReachedMax: this.state.hasReachedMax ?? false,
        chats: newChats,
        currentCategory: this.state.currentCategory
      ));
    } 
  }

  void updateCategoryForChat (int chatId, CategoryEntity newCategory) {
    int index = this.state.chats.indexWhere((element) => element.chatId == chatId);
    if (index != -1) { 
      var newChatModel = this.state.chats[index].clone();
      newChatModel.chatCategory = newCategory;
      chatsRepository.saveNewChatLocally(newChatModel);
      var newChats = this.state.chats.map((e) => e.chatId == chatId ? newChatModel : e.clone()).toList();
      
      bool isAllChats = (lastCategoryID == null || lastCategoryID == 0);
      bool newCategoryIsEmpty = newCategory.id == 0 || newCategory.id == null;
      
      if (!((isAllChats && newCategoryIsEmpty) || lastCategoryID == newCategory.id)) {
        newChats.removeAt(index);
      } 

      emit(ChatsLoaded(
        hasReachedMax: this.state.hasReachedMax ?? false,
        chats: newChats,
        currentCategory: this.state.currentCategory
      ));
    }
  }
}
