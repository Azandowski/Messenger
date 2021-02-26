import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  
  final ChatsRepository chatsRepository;
  
  ChatBloc(this.chatsRepository) : super(ChatLoading()) {
    _chatsSubscription = chatsRepository.chatsController.stream
      .listen((chats) => add(LoadedNewChats(chats)));
  }

  StreamSubscription<List<ChatEntity>> _chatsSubscription;

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is LoadedNewChats) {
      yield ChatsLoaded(event.chats);
    }
  }
}
