part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  final List<Message> messages;

  const ChatState({
    @required this.messages,
  });
}

class ChatInitial extends ChatState {

  final List<Message> messages;

  ChatInitial({
    @required this.messages
  }) : super(messages: messages);

  @override
  List<Object> get props => [messages];
}

class ChatError extends ChatState {

  final List<Message> messages;

  ChatError({
    @required this.messages
  }) : super(messages: messages);

  @override
  List<Object> get props => [messages];
}
