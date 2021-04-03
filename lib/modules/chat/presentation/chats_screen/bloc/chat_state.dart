part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  final ChatEntity chatEntity;
  final List<Message> messages;
  final bool hasReachedMax;
  final bool hasReachBottomMax;
  final String wallpaperPath;
  final int unreadCount;
  final bool showBottomPin;
  final bool isSecretModeOn;

  final Message topMessage;
  const ChatState({
    @required this.messages,
    @required this.hasReachedMax,
    this.chatEntity,
    this.hasReachBottomMax = true,
    this.wallpaperPath,
    this.unreadCount,
    this.showBottomPin,
    this.topMessage,
    this.isSecretModeOn
  });

  @override
  List<Object> get props => [
    messages, hasReachedMax, wallpaperPath, hasReachBottomMax,
    unreadCount, showBottomPin, showBottomPin, topMessage,
    isSecretModeOn, chatEntity
  ];
}

class ChatInitial extends ChatState {
  final ChatEntity chatEntity;
  final bool hasReachBottomMax;
  final List<Message> messages;
  final bool hasReachedMax;
  final String wallpaperPath;
  final int focusMessageID;
  final int unreadCount;
  final bool showBottomPin;
  final Message topMessage;
  final bool isSecretModeOn;

  ChatInitial({
    @required this.messages,
    @required this.hasReachedMax,
    this.chatEntity,
    this.wallpaperPath,
    this.hasReachBottomMax = true,
    this.focusMessageID,
    this.unreadCount,
    this.showBottomPin,
    this.topMessage,
    this.isSecretModeOn
  }) : super(
    messages: messages, 
    hasReachedMax: hasReachedMax,
    wallpaperPath: wallpaperPath,
    hasReachBottomMax: hasReachBottomMax,
    unreadCount: unreadCount,
    topMessage: topMessage,
    isSecretModeOn: isSecretModeOn,
    chatEntity: chatEntity
  );

  @override
  List<Object> get props => [
    messages, 
    hasReachedMax, 
    wallpaperPath, 
    hasReachBottomMax, 
    focusMessageID,
    unreadCount,
    showBottomPin,
    topMessage,
    isSecretModeOn,
    chatEntity
  ];
}


class ChatLoading extends ChatState {
  final ChatEntity chatEntity;
  final bool isPagination;
  final List<Message> messages;
  final bool hasReachedMax;
  final bool hasReachBottomMax;
  final Message topMessage;
  final String wallpaperPath;
  final RequestDirection direction;
  final int unreadCount;
  final bool showBottomPin;
  final bool isSecretModeOn;

  ChatLoading({
    @required this.isPagination,
    @required this.messages,
    @required this.hasReachedMax,
    this.topMessage,
    this.wallpaperPath,
    this.hasReachBottomMax = true ,
    this.direction,
    this.unreadCount,
    this.showBottomPin,
    this.isSecretModeOn,
    this.chatEntity
  }) : super(
    messages: messages, 
    hasReachedMax: hasReachedMax,
    wallpaperPath: wallpaperPath,
    hasReachBottomMax: hasReachBottomMax,
    unreadCount: unreadCount,
    topMessage: topMessage,
    isSecretModeOn: isSecretModeOn,
    chatEntity: chatEntity
  );
 
  @override
  List<Object> get props => [
    isPagination,
    hasReachedMax,
    messages,
    wallpaperPath,
    hasReachBottomMax,
    direction,
    unreadCount,
    showBottomPin,
    topMessage,
    isSecretModeOn,
    chatEntity
  ];  
}


/// При [ChatLoadingSilently] сообщения не будут загружаться
/// Это для [background] операции
class ChatLoadingSilently extends ChatState {
  final ChatEntity chatEntity;
  final List<Message> messages;
  final bool hasReachedMax;
  final String wallpaperPath;
  final bool hasReachBottomMax;
  final int unreadCount;
  final bool showBottomPin;
  final Message topMessage;
  final bool isSecretModeOn;

  ChatLoadingSilently({
    @required this.messages,
    @required this.hasReachedMax,
    @required this.wallpaperPath,
    this.hasReachBottomMax = true,
    this.unreadCount,
    this.showBottomPin,
    this.topMessage,
    this.isSecretModeOn,
    this.chatEntity
  }) : super(
    messages: messages,
    hasReachBottomMax: hasReachBottomMax,
    hasReachedMax: hasReachedMax,
    unreadCount: unreadCount,
    wallpaperPath: wallpaperPath,
    topMessage: topMessage,
    isSecretModeOn: isSecretModeOn,
    chatEntity: chatEntity
  );

  @override
  List<Object> get props => [
    messages, 
    hasReachedMax,
    topMessage,
    wallpaperPath,
    hasReachBottomMax,
    unreadCount,
    showBottomPin,
    topMessage,
    isSecretModeOn,
    chatEntity
  ];
}


class ChatError extends ChatState {
  final ChatEntity chatEntity;
  final bool hasReachBottomMax;
  final List<Message> messages;
  final String message;
  final bool hasReachedMax;
  final String wallpaperPath;
  final int unreadCount;
  final bool showBottomPin;
  final Message topMessage;
  final bool isSecretModeOn;

  ChatError({
    @required this.messages,
    @required this.message,
    @required this.hasReachedMax,
    this.topMessage,
    this.wallpaperPath,
    this.hasReachBottomMax = true,
    this.unreadCount,
    this.showBottomPin,
    this.isSecretModeOn,
    this.chatEntity
  }) : super(
    messages: messages, 
    hasReachedMax: hasReachedMax,
    wallpaperPath: wallpaperPath,
    hasReachBottomMax: hasReachBottomMax,
    unreadCount: unreadCount,
    topMessage: topMessage,
    isSecretModeOn: isSecretModeOn,
    chatEntity: chatEntity
  );

  @override
  List<Object> get props => [
    messages, 
    message, 
    hasReachedMax,
    wallpaperPath,
    hasReachBottomMax,
    unreadCount,
    showBottomPin,
    topMessage,
    isSecretModeOn,
    chatEntity
  ];
}
