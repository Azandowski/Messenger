part of 'chats_cubit_cubit.dart';

abstract class ChatsCubitState extends Equatable {
  final PaginatedResult<ChatEntity> chats;
  final int currentTabIndex;
  
  const ChatsCubitState({
    @required this.chats,
    @required this.currentTabIndex
  });

  @override
  List<Object> get props => [currentTabIndex, chats];
}

class ChatsCubitLoaded extends ChatsCubitState {
  final PaginatedResult<ChatEntity> chats;
  final int currentTabIndex;

  ChatsCubitLoaded({
    @required this.chats,
    @required this.currentTabIndex
  });

  @override
  List<Object> get props => [chats, currentTabIndex];
}

class ChatsCubitLoading extends ChatsCubitState {
  final PaginatedResult<ChatEntity> chats;
  final bool isPagination;
  final int currentTabIndex;

  ChatsCubitLoading({
    @required this.chats, 
    @required this.currentTabIndex,
    this.isPagination = false
  }) : super(chats: chats, currentTabIndex: currentTabIndex);
  
  @override
  List<Object> get props => [chats, isPagination, currentTabIndex];
}

class ChatsCubitError extends ChatsCubitState {
  final String errorMessage;
  final PaginatedResult<ChatEntity> chats;
  final int currentTabIndex;

  ChatsCubitError({
    @required this.errorMessage,
    @required this.chats,
    @required this.currentTabIndex
  }) : super(chats: chats, currentTabIndex: currentTabIndex);

  @override
  List<Object> get props => [errorMessage, chats, currentTabIndex];
}
