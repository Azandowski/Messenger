part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  final List<Message> messages;
  final bool hasReachedMax;
  final String wallpaperPath;

  const ChatState({
    @required this.messages,
    @required this.hasReachedMax,
    this.wallpaperPath
  });

  @override
  List<Object> get props => [
    messages, hasReachedMax, wallpaperPath
  ];
}

class ChatInitial extends ChatState {

  final List<Message> messages;
  final bool hasReachedMax;
  final String wallpaperPath;

  ChatInitial({
    @required this.messages,
    @required this.hasReachedMax,
    this.wallpaperPath
  }) : super(
    messages: messages, 
    hasReachedMax: hasReachedMax,
    wallpaperPath: wallpaperPath
  );

  @override
  List<Object> get props => [messages, hasReachedMax, wallpaperPath];
}

class ChatLoading extends ChatState {
  final bool isPagination;
  final List<Message> messages;
  final bool hasReachedMax;
  final String wallpaperPath;

  ChatLoading({
    @required this.isPagination,
    @required this.messages,
    @required this.hasReachedMax,
    this.wallpaperPath
  }) : super(
    messages: messages, 
    hasReachedMax: hasReachedMax,
    wallpaperPath: wallpaperPath
  );

  @override
  List<Object> get props => [
    isPagination,
    hasReachedMax,
    messages,
    wallpaperPath
  ];  
}


/// При [ChatLoadingSilently] сообщения не будут загружаться
/// Это для [background] операции
class ChatLoadingSilently extends ChatState {
  final List<Message> messages;
  final bool hasReachedMax;
  final String wallpaperPath;

  ChatLoadingSilently({
    @required this.messages,
    @required this.hasReachedMax,
    @required this.wallpaperPath
  });

  @override
  List<Object> get props => [
    messages, 
    hasReachedMax,
    wallpaperPath
  ];
}


class ChatError extends ChatState {

  final List<Message> messages;
  final String message;
  final bool hasReachedMax;
  final String wallpaperPath;

  ChatError({
    @required this.messages,
    @required this.message,
    @required this.hasReachedMax,
    this.wallpaperPath
  }) : super(
    messages: messages, 
    hasReachedMax: hasReachedMax,
    wallpaperPath: wallpaperPath
  );

  @override
  List<Object> get props => [
    messages, 
    message, 
    hasReachedMax,
    wallpaperPath
  ];
}

class ChatSelection extends ChatState {
  final List<Message> messages;
  final bool hasReachedMax;

  ChatSelection({
    @required this.messages,
    @required this.hasReachedMax,
  }) : super(
    hasReachedMax: hasReachedMax,
    messages: messages, 
  );

  @override
  List<Object> get props => [
    messages, 
    hasReachedMax,
  ];
}
