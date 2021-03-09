import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../../locator.dart';
import '../../../../../modules/category/domain/entities/chat_entity.dart';
import '../../../../../modules/chats/domain/repositories/chats_repository.dart';
import '../../../../../modules/chats/domain/usecase/get_chats.dart';
import '../../../../../modules/chats/domain/usecase/params.dart';
import '../../../../config/auth_config.dart';
import '../../../../services/network/paginatedResult.dart';

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
      lastChatID: isPagination ? this.state.chats?.last?.chatId : null,
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
}
