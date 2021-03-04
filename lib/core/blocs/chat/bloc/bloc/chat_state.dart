part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  final PaginatedResult<ChatEntity> chats;

  ChatState({
    @required this.chats,
  });
  
  @override
  List<Object> get props => [chats];
}

class ChatLoading extends ChatState {
  final PaginatedResult<ChatEntity> chats;
  final bool isPagination;

  ChatLoading({
    @required this.chats,
    @required this.isPagination
  }) : super(chats: chats);
  
  @override
  List<Object> get props => [chats, isPagination];
}


class ChatsLoaded extends ChatState {
  final PaginatedResult<ChatEntity> chats;

  ChatsLoaded({
    @required this.chats,
  }) : super(chats: chats);
  
  @override
  List<Object> get props => [chats];
}

class ChatsError extends ChatState {
  final String errorMessage;
  final PaginatedResult<ChatEntity> chats;

  ChatsError({
    @required this.errorMessage,
    @required this.chats,
  }) : super(chats: chats);

  @override
  List<Object> get props => [errorMessage, chats];
}
