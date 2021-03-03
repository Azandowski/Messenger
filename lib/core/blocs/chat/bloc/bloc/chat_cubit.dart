import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';
part 'chat_state.dart';

class ChatGlobalCubit extends Cubit<ChatState> {
  
  final ChatsRepository chatsRepository;
  
  ChatGlobalCubit(this.chatsRepository) : 
    super(ChatLoading(
      chats: PaginatedResult(data: []),
    )) {
    _chatsSubscription = chatsRepository.chatsController.stream
      .listen(
        (chats) => ChatsLoaded(
          chats: PaginatedResult(data: chats),
        )
      );
  }

  StreamSubscription<List<ChatEntity>> _chatsSubscription;
}
