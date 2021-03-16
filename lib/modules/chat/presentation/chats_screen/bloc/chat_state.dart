part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  final List<Message> messages;
  final bool hasReachedMax;
  final bool hasReachBottomMax;
  final String wallpaperPath;
  final Message topMessage;
  const ChatState({
    @required this.messages,
    @required this.hasReachedMax,
    this.hasReachBottomMax = true,
    this.wallpaperPath,
    this.topMessage,
  });

  @override
  List<Object> get props => [
    messages, hasReachedMax, wallpaperPath, hasReachBottomMax
  ];
}

class ChatInitial extends ChatState {
  final bool hasReachBottomMax;
  final List<Message> messages;
  final bool hasReachedMax;
  final String wallpaperPath;
  final int focusMessageID;
  final Message topMessage;

  ChatInitial({
    @required this.messages,
    @required this.hasReachedMax,
    this.wallpaperPath,
    this.hasReachBottomMax = true,
    this.focusMessageID,
    this.topMessage,
  }) : super(
    messages: messages, 
    hasReachedMax: hasReachedMax,
    wallpaperPath: wallpaperPath,
    topMessage: topMessage,
    hasReachBottomMax: hasReachBottomMax
  );

  @override
  List<Object> get props => [messages, hasReachedMax, wallpaperPath, hasReachBottomMax, focusMessageID, topMessage];
}

class ChatLoading extends ChatState {
  final bool isPagination;
  final List<Message> messages;
  final bool hasReachedMax;
  final String wallpaperPath;
  final bool hasReachBottomMax;

  ChatLoading({
    @required this.isPagination,
    @required this.messages,
    @required this.hasReachedMax,
    this.wallpaperPath,
    this.hasReachBottomMax = true 
  }) : super(
    messages: messages, 
    hasReachedMax: hasReachedMax,
    wallpaperPath: wallpaperPath,
    hasReachBottomMax: hasReachBottomMax
  );

  @override
  List<Object> get props => [
    isPagination,
    hasReachedMax,
    messages,
    wallpaperPath,
    hasReachBottomMax
  ];  
}


/// При [ChatLoadingSilently] сообщения не будут загружаться
/// Это для [background] операции
class ChatLoadingSilently extends ChatState {
  final List<Message> messages;
  final bool hasReachedMax;
  final String wallpaperPath;
  final bool hasReachBottomMax;

  ChatLoadingSilently({
    @required this.messages,
    @required this.hasReachedMax,
    @required this.wallpaperPath,
    this.hasReachBottomMax = true 
  });

  @override
  List<Object> get props => [
    messages, 
    hasReachedMax,
    wallpaperPath,
    hasReachBottomMax
  ];
}


class ChatError extends ChatState {
  final bool hasReachBottomMax;
  final List<Message> messages;
  final String message;
  final bool hasReachedMax;
  final String wallpaperPath;

  ChatError({
    @required this.messages,
    @required this.message,
    @required this.hasReachedMax,
    this.wallpaperPath,
    this.hasReachBottomMax = true 
  }) : super(
    messages: messages, 
    hasReachedMax: hasReachedMax,
    wallpaperPath: wallpaperPath,
    hasReachBottomMax: hasReachBottomMax
  );

  @override
  List<Object> get props => [
    messages, 
    message, 
    hasReachedMax,
    wallpaperPath,
    hasReachBottomMax
  ];
}
