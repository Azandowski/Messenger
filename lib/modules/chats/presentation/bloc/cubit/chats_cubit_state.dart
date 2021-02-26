part of 'chats_cubit_cubit.dart';

abstract class ChatsCubitState extends Equatable {
  const ChatsCubitState();

  @override
  List<Object> get props => [];
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

class ChatsCubitLoading extends ChatsCubitState {}

class ChatsCubitError extends ChatsCubitState {
  final String errorMessage;

  ChatsCubitError({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
