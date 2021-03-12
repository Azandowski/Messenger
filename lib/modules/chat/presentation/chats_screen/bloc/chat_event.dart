part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  
  const ChatEvent();
}

class LoadMessages extends ChatEvent {
  final bool isPagination;

  LoadMessages({
    @required this.isPagination
  });

  @override
  List<Object> get props => [
    isPagination
  ];
}

class MessageAdded extends ChatEvent {
  final Message message;

  MessageAdded({
   @required this.message
  });

  @override
  List<Object> get props => [message];
}

class MessageSend extends ChatEvent {
  final Message forwardMessage;
  final String message;

  MessageSend({
    this.message,
    this.forwardMessage,
  });

  @override
  List<Object> get props => [message, forwardMessage];
}
