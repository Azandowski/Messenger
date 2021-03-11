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
