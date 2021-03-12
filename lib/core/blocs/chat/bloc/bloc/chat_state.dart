part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  final List<ChatEntity> chats;
  final bool hasReachedMax;
  final int currentCategory;

  ChatState({
    @required this.chats,
    @required this.hasReachedMax,
    this.currentCategory
  });
  
  @override
  List<Object> get props => [chats, hasReachedMax, currentCategory];
}

class ChatLoading extends ChatState {
  final List<ChatEntity> chats;
  final bool isPagination;
  final bool hasReachedMax;
  final int currentCategory;

  ChatLoading({
    @required this.chats,
    @required this.isPagination,
    @required this.hasReachedMax,
    this.currentCategory
  }) : super(
    chats: chats, 
    hasReachedMax: hasReachedMax, 
    currentCategory: currentCategory
  );
  
  @override
  List<Object> get props => [
    chats, 
    isPagination, 
    hasReachedMax, 
    currentCategory
  ];
}


class ChatsLoaded extends ChatState {
  final List<ChatEntity> chats;
  final bool hasReachedMax;
  final int currentCategory;

  ChatsLoaded({
    @required this.chats,
    @required this.hasReachedMax,
    this.currentCategory
  }) : super(
    chats: chats, 
    hasReachedMax: hasReachedMax,
    currentCategory: currentCategory
  );
  
  @override
  List<Object> get props => [
    chats, 
    hasReachedMax,
    currentCategory
  ];
}

class ChatsError extends ChatState {
  final String errorMessage;
  final List<ChatEntity> chats;
  final bool hasReachedMax;
  final int currentCategory;

  ChatsError({
    @required this.errorMessage,
    @required this.chats,
    @required this.hasReachedMax,
    this.currentCategory
  }) : super(
    chats: chats, 
    hasReachedMax: hasReachedMax,
    currentCategory: currentCategory
  );

  @override
  List<Object> get props => [
    errorMessage, 
    chats, 
    hasReachedMax,
    currentCategory
  ];
}
