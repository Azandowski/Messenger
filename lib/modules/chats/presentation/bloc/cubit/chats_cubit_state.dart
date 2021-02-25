part of 'chats_cubit_cubit.dart';

abstract class ChatsCubitState extends Equatable {
  const ChatsCubitState();

  @override
  List<Object> get props => [];
}

class ChatsCubitNormal extends ChatsCubitState {
  final ChatListsState chatListsState;
  final int index;

  ChatsCubitNormal(
      {@required this.chatListsState,
      @required this.index});

  @override
  List<Object> get props => [chatListsState, index];
}

class ChatsCubitError extends ChatsCubitState {
  final String errorMessage;

  ChatsCubitError({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// MARK: - Chats State

abstract class ChatListsState extends Equatable {
  const ChatListsState();

  @override
  List<Object> get props => [];
}

class ChatListsLoading extends ChatListsState {
  @override
  List<Object> get props => [];
}

class ChatListsLoaded extends ChatListsState {
  @override
  List<Object> get props => [];
}

