part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  final List<Message> messages;
  final bool hasReachedMax;

  const ChatState({
    @required this.messages,
    @required this.hasReachedMax
  });
}

class ChatInitial extends ChatState {

  final List<Message> messages;
  final bool hasReachedMax;

  ChatInitial({
    @required this.messages,
    @required this.hasReachedMax
  }) : super(messages: messages, hasReachedMax: hasReachedMax);

  @override
  List<Object> get props => [messages, hasReachedMax];
}

class ChatLoading extends ChatState {
  final bool isPagination;
  final List<Message> messages;
  final bool hasReachedMax;

  ChatLoading({
    @required this.isPagination,
    @required this.messages,
    @required this.hasReachedMax
  }) : super(messages: messages, hasReachedMax: hasReachedMax);

  @override
  List<Object> get props => [
    isPagination,
    hasReachedMax,
    messages
  ];  
}

class ChatError extends ChatState {

  final List<Message> messages;
  final String message;
  final bool hasReachedMax;

  ChatError({
    @required this.messages,
    @required this.message,
    @required this.hasReachedMax
  }) : super(messages: messages, hasReachedMax: hasReachedMax);

  @override
  List<Object> get props => [messages, message, hasReachedMax];
}
