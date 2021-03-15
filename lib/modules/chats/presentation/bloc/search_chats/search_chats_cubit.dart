import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/utils/chat_search_util.dart';
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
      messages: PaginatedResult(
        data: [],
        paginationData: PaginationData(nextPageUrl: null)
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
      token: sl<AuthConfig>().token,
      fromCache: true
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
            messages: PaginatedResult(
              data: [], 
              paginationData: PaginationData(nextPageUrl: null)
            )
          )
        )
      );
    });
  }

  Future<void> search ({
    String queryText,
    bool isPagination,
    int chatID
  }) async {
    if (queryText.trim() == '' && chatID == null) {
      return _initSearchChatsCubit();
    } else {
      showLoading(isPagination: isPagination);
      
      var response = await searchChats(SearchChatParams(
        nextPageURL: isPagination && state.data.messages?.paginationData?.nextPageUrl != null ? 
          state.data.messages.paginationData.nextPageUrl : null,
        queryText: queryText,
        chatID: chatID
      ));

      response.fold((failure) => emit(
        SearchChatsError(
          message: failure.message,
          data: state.data
        )
      ), (result) => emit(
        SearchChatsLoaded(
          data: _getResponse(
            response: result,
            queryText: queryText
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
        messages: !isPagination ? PaginatedResult(
          data: [],
          paginationData: PaginationData(nextPageUrl: null)
        ) : state.data.messages, 
        chats: isPagination ? state.data.chats : []
      ),
      isPagination: isPagination
    ));
  }

  /// Returns only query results's region
  ChatMessageResponse _getResponse ({
    @required ChatMessageResponse response,
    @required String queryText
  }) {
    final ChatSearchUtil searchUtil = ChatSearchUtil();
    
    return ChatMessageResponse(
      chats: response.chats,
      messages: PaginatedResult<Message>(
        paginationData: response.messages.paginationData,
        data: response.messages.data.map((e) => e.copyWith(
          text: searchUtil.getSearchResult(queryText: queryText, inputText: e.text)
        )).toList()
      ) 
    );
  }
}
