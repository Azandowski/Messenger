import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/chat_search_response.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/params.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/search_chats.dart';


import '../../../../../locator.dart';

part 'search_chats_state.dart';

class SearchChatsCubit extends Cubit<SearchChatsState> {
  final ChatsRepository chatsRepository;
  SearchChats searchChats;

  SearchChatsCubit({
    @required this.chatsRepository
  }) : super(SearchChatsLoading(
    data: ChatMessageResponse(
      messages: PaginatedResultViaLastItem(
        data: [],
        hasReachMax: false
      ), 
      chats: [],
    ),
    isPagination: false
  )) {
    searchChats = SearchChats(chatsRepository);
    _initSearchChatsCubit();
  }


  /// При откытии скрина нужно загрузить чаты с кэша и показать пользователю
  Future<void> _initSearchChatsCubit () async {
    showLoading(isPagination: false);

    var response = await chatsRepository.getUserChats(GetChatsParams(
      lastChatID: null, 
      token: sl<AuthConfig>().token
    ));

    response.fold((failure) => emit(
      SearchChatsError(
        message: failure.message,
        data: state.data
      )
    ), (result) {
      emit(
        SearchChatsLoaded(
          data: ChatMessageResponse(
            chats: result.data,
            messages: PaginatedResultViaLastItem(
              data: [], hasReachMax: true
            )
          )
        )
      );
    });
  }

  Future<void> search ({
    String queryText,
    int lastItemID
  }) async {
    if (queryText.trim() == '') {
      return _initSearchChatsCubit();
    } else {
      showLoading(isPagination: lastItemID != null);
      var response = await searchChats(SearchChatParams(
        lastItemID: lastItemID, 
        queryText: 'n')
      );

      response.fold((failure) => emit(
        SearchChatsError(
          message: failure.message,
          data: state.data
        )
      ), (result) => emit(
        SearchChatsLoaded(
          data: ChatMessageResponse(
            chats: result.chats,
            messages: PaginatedResultViaLastItem<Message>(
              hasReachMax: result.messages.hasReachMax,
              data: lastItemID == null ?
                result.messages.data : result.messages.data + this.state.data.messages.data
            )
          )
        )
      ));
    }    
  }


  void showLoading ({
    bool isPagination
  }) {
    emit(SearchChatsLoading(
      data: ChatMessageResponse(
        messages: !isPagination ? PaginatedResultViaLastItem(
          data: [],
          hasReachMax: false
        ) : state.data.messages, 
        chats: isPagination ? state.data.chats : []
      ),
      isPagination: isPagination
    ));
  }
}
