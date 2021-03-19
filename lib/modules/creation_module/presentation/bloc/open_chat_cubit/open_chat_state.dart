part of 'open_chat_cubit.dart';


abstract class OpenChatState extends Equatable {
  const OpenChatState();

  @override
  List<Object> get props => [];
}

class OpenChatInitial extends OpenChatState {}

class OpenChatLoading extends OpenChatState {} 

class OpenChatDone extends OpenChatState {
  final ChatEntity newChat;

  OpenChatDone({
    @required this.newChat
  });

  @override
  List<Object> get props => [newChat];
}

class OpenChatError extends OpenChatState {
  final String message;

  OpenChatError({
    @required this.message
  });

  @override
  List<Object> get props => [message];
}