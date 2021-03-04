import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/get_chats.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/params.dart';

import '../../../../../locator.dart';
part 'chat_state.dart';

class ChatGlobalCubit extends Cubit<ChatState> {
  
  final ChatsRepository chatsRepository;
  final GetChats getChats;

  ChatGlobalCubit(
    this.chatsRepository,
    this.getChats
  ) : super(ChatLoading(
      chats: PaginatedResult(data: []),
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
      isPagination: false
    ));

    final response = await getChats(GetChatsParams(
      paginationData: isPagination ? 
        this.state.chats?.paginationData ?? PaginationData.defaultInit() : PaginationData.defaultInit(),
      token: sl<AuthConfig>().token
    ));

    response.fold(
      (failure) => emit(ChatsError(
        chats: this.state.chats, 
        errorMessage: failure.message, 
      )),
      (chatsResponse) {
        List<ChatEntity> newChats = isPagination ? (this.state.chats?.data ?? []) + chatsResponse.data : chatsResponse.data;
        print('LOADED CHATS COUNT: ${newChats.length}');
        emit(ChatsLoaded( 
          chats: PaginatedResult<ChatEntity> (
            paginationData: chatsResponse.paginationData,
            data: newChats
          )
        ));
      }
    );
  }
}
