part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class StartLoadingChats extends ChatEvent {}

class LoadedNewChats extends StartLoadingChats {
  final List<ChatEntity> chats;

  LoadedNewChats(this.chats);
  
  @override
  List<Object> get props => [chats]; 
}
