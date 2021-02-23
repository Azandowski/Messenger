part of 'chats_cubit_cubit.dart';

abstract class ChatsCubitState extends Equatable {
  const ChatsCubitState();

  @override
  List<Object> get props => [];
}

class ChatsCubitNormal extends ChatsCubitState {
  final ChatListsState chatListsState;
  final ChatCategoriesState chatCategoriesState;

  ChatsCubitNormal({
    @required this.chatListsState, 
    @required this.chatCategoriesState
  });
}

class ChatsCubitError extends ChatsCubitState {
  final String errorMessage;

  ChatsCubitError({
    @required this.errorMessage
  });
 
  @override
  List<Object> get props => [errorMessage];
}

// MARK: - Chats State

abstract class ChatListsState extends Equatable {
  const ChatListsState();

  @override
  List<Object> get props => [];
}

class ChatListsLoading extends ChatListsState {}

class ChatListsLoaded extends ChatListsState {
  // TODO: Add here list of chat messages
}


// MARK: - Chats Categories State

abstract class ChatCategoriesState extends Equatable {
  const ChatCategoriesState();

  @override
  List<Object> get props => [];
}

class ChatCategoriesLoading extends ChatCategoriesState {}

class ChatCategoriesLoaded extends ChatCategoriesState {
  final List<CategoryEntity> categories;

  ChatCategoriesLoaded({
    @required this.categories
  });

  @override
  List<Object> get props => [categories];
}