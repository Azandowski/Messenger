part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  
  @override
  List<Object> get props => [];
}

class ChatLoading extends ChatState {}

class ChatsLoaded extends ChatState {
  final List<ChatEntity> chats;

  ChatsLoaded(this.chats);
  
  @override
  List<Object> get props => [chats];
}
