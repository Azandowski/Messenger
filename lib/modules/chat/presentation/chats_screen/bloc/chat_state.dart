part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  final ChatEntity chatEntity;
  final List<Message> messages;
  final bool hasReachedMax;
  final bool hasReachBottomMax;
  final File wallpaperFile;
  final int unreadCount;
  final bool showBottomPin;
  final bool isSecretModeOn;
  final TimeOptions currentTimerOption;
  final Message topMessage;
  
  const ChatState({
    @required this.messages,
    @required this.hasReachedMax,
    this.chatEntity,
    this.hasReachBottomMax = true,
    this.wallpaperFile,
    this.unreadCount,
    this.showBottomPin,
    this.topMessage,
    this.isSecretModeOn,
    this.currentTimerOption
  });

  @override
  List<Object> get props => [
    messages, hasReachedMax, wallpaperFile, hasReachBottomMax,
    unreadCount, showBottomPin, showBottomPin, topMessage,
    isSecretModeOn, chatEntity, currentTimerOption
  ];
}

class ChatInitial extends ChatState {
  final ChatEntity chatEntity;
  final bool hasReachBottomMax;
  final List<Message> messages;
  final bool hasReachedMax;
  final File wallpaperFile;
  final int focusMessageID;
  final int unreadCount;
  final bool showBottomPin;
  final Message topMessage;
  final bool isSecretModeOn;
  final TimeOptions currentTimerOption;

  ChatInitial({
    @required this.messages,
    @required this.hasReachedMax,
    this.chatEntity,
    this.wallpaperFile,
    this.hasReachBottomMax = true,
    this.focusMessageID,
    this.unreadCount,
    this.showBottomPin,
    this.topMessage,
    this.isSecretModeOn,
    this.currentTimerOption
  }) : super(
    messages: messages, 
    hasReachedMax: hasReachedMax,
    wallpaperFile: wallpaperFile,
    hasReachBottomMax: hasReachBottomMax,
    unreadCount: unreadCount,
    topMessage: topMessage,
    isSecretModeOn: isSecretModeOn,
    chatEntity: chatEntity,
    currentTimerOption: currentTimerOption
  );

  @override
  List<Object> get props => [
    messages, 
    hasReachedMax, 
    wallpaperFile, 
    hasReachBottomMax, 
    focusMessageID,
    unreadCount,
    showBottomPin,
    topMessage,
    isSecretModeOn,
    chatEntity,
    currentTimerOption
  ];
}


class ChatLoading extends ChatState {
  final ChatEntity chatEntity;
  final bool isPagination;
  final List<Message> messages;
  final bool hasReachedMax;
  final bool hasReachBottomMax;
  final Message topMessage;
  final File wallpaperFile;
  final RequestDirection direction;
  final int unreadCount;
  final bool showBottomPin;
  final bool isSecretModeOn;
  final TimeOptions currentTimerOption;

  ChatLoading({
    @required this.isPagination,
    @required this.messages,
    @required this.hasReachedMax,
    this.topMessage,
    this.wallpaperFile,
    this.hasReachBottomMax = true ,
    this.direction,
    this.unreadCount,
    this.showBottomPin,
    this.isSecretModeOn,
    this.chatEntity,
    this.currentTimerOption
  }) : super(
    messages: messages, 
    hasReachedMax: hasReachedMax,
    wallpaperFile: wallpaperFile,
    hasReachBottomMax: hasReachBottomMax,
    unreadCount: unreadCount,
    topMessage: topMessage,
    isSecretModeOn: isSecretModeOn,
    chatEntity: chatEntity,
    currentTimerOption: currentTimerOption
  );
 
  @override
  List<Object> get props => [
    isPagination,
    hasReachedMax,
    messages,
    wallpaperFile,
    hasReachBottomMax,
    direction,
    unreadCount,
    showBottomPin,
    topMessage,
    isSecretModeOn,
    chatEntity,
    currentTimerOption
  ];  
}


/// При [ChatLoadingSilently] сообщения не будут загружаться
/// Это для [background] операции
class ChatLoadingSilently extends ChatState {
  final ChatEntity chatEntity;
  final List<Message> messages;
  final bool hasReachedMax;
  final File wallpaperFile;
  final bool hasReachBottomMax;
  final int unreadCount;
  final bool showBottomPin;
  final Message topMessage;
  final bool isSecretModeOn;
  final TimeOptions currentTimerOption;

  ChatLoadingSilently({
    @required this.messages,
    @required this.hasReachedMax,
    @required this.wallpaperFile,
    this.hasReachBottomMax = true,
    this.unreadCount,
    this.showBottomPin,
    this.topMessage,
    this.isSecretModeOn,
    this.chatEntity,
    this.currentTimerOption
  }) : super(
    messages: messages,
    hasReachBottomMax: hasReachBottomMax,
    hasReachedMax: hasReachedMax,
    unreadCount: unreadCount,
    wallpaperFile: wallpaperFile,
    topMessage: topMessage,
    isSecretModeOn: isSecretModeOn,
    chatEntity: chatEntity,
    currentTimerOption: currentTimerOption
  );

  @override
  List<Object> get props => [
    messages, 
    hasReachedMax,
    topMessage,
    wallpaperFile,
    hasReachBottomMax,
    unreadCount,
    showBottomPin,
    topMessage,
    isSecretModeOn,
    chatEntity,
    currentTimerOption
  ];
}


class ChatError extends ChatState {
  final ChatEntity chatEntity;
  final bool hasReachBottomMax;
  final List<Message> messages;
  final String message;
  final bool hasReachedMax;
  final File wallpaperFile;
  final int unreadCount;
  final bool showBottomPin;
  final Message topMessage;
  final TimeOptions currentTimerOption;
  final bool isSecretModeOn;

  ChatError({
    @required this.messages,
    @required this.message,
    @required this.hasReachedMax,
    this.topMessage,
    this.wallpaperFile,
    this.hasReachBottomMax = true,
    this.unreadCount,
    this.showBottomPin,
    this.isSecretModeOn,
    this.chatEntity,
    this.currentTimerOption
  }) : super(
    messages: messages, 
    hasReachedMax: hasReachedMax,
    wallpaperFile: wallpaperFile,
    hasReachBottomMax: hasReachBottomMax,
    unreadCount: unreadCount,
    topMessage: topMessage,
    isSecretModeOn: isSecretModeOn,
    chatEntity: chatEntity,
    currentTimerOption: currentTimerOption
  );

  @override
  List<Object> get props => [
    messages, 
    message, 
    hasReachedMax,
    wallpaperFile,
    hasReachBottomMax,
    unreadCount,
    showBottomPin,
    topMessage,
    isSecretModeOn,
    chatEntity,
    currentTimerOption
  ];
}
