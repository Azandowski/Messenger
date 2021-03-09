part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  final List<ChatEntity> chats;
  final bool hasReachedMax;

  ChatState({
    @required this.chats,
    @required this.hasReachedMax
  });
  
  @override
  List<Object> get props => [chats, hasReachedMax];
}

class ChatLoading extends ChatState {
  final List<ChatEntity> chats;
  final bool isPagination;
  final bool hasReachedMax;

  ChatLoading({
    @required this.chats,
    @required this.isPagination,
    @required this.hasReachedMax
  }) : super(chats: chats, hasReachedMax: hasReachedMax);
  
  @override
  List<Object> get props => [chats, isPagination, hasReachedMax];
}


class ChatsLoaded extends ChatState {
  final List<ChatEntity> chats;
  final bool hasReachedMax;

  ChatsLoaded({
    @required this.chats,
    @required this.hasReachedMax
  }) : super(chats: chats, hasReachedMax: hasReachedMax);
  
  @override
  List<Object> get props => [chats, hasReachedMax];
}

class ChatsError extends ChatState {
  final String errorMessage;
  final List<ChatEntity> chats;
  final bool hasReachedMax;

  ChatsError({
    @required this.errorMessage,
    @required this.chats,
    @required this.hasReachedMax
  }) : super(chats: chats, hasReachedMax: hasReachedMax);

  @override
  List<Object> get props => [errorMessage, chats, hasReachedMax];
}
