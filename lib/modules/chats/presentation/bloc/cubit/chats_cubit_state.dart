part of 'chats_cubit_cubit.dart';

abstract class ChatsCubitState extends Equatable {
  const ChatsCubitState();

  @override
  List<Object> get props => [];
}

class ChatsCubitNormal extends ChatsCubitState {
  final ChatListsState chatListsState;
  final ChatCategoriesState chatCategoriesState;

  ChatsCubitNormal(
      {@required this.chatListsState, @required this.chatCategoriesState});

  @override
  List<Object> get props => [chatListsState, chatCategoriesState];
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

// MARK: - Chats Categories State

abstract class ChatCategoriesState extends Equatable {
  const ChatCategoriesState();

  @override
  List<Object> get props => [];
}

class ChatCategoriesLoading extends ChatCategoriesState {
  @override
  List<Object> get props => [];
}

class ChatCategoriesLoaded extends ChatCategoriesState {
  final List<CategoryEntity> categories;
  final int index;
  ChatCategoriesLoaded({@required this.categories, @required this.index});

  @override
  List<Object> get props => [categories, index];
}
