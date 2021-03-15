part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}


class ChatScreenStarted extends ChatEvent {
  @override
  List<Object> get props => [];
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

class SetInitialTime extends ChatEvent {
  final TimeOptions option;

  SetInitialTime({
    this.option
  });

  @override
  List<Object> get props => [option];
}

class DisposeChat extends ChatEvent{
  @override
  List<Object> get props => [];
}

