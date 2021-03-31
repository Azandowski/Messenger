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

  ChatState copyWith ({
    List<Message> messages,
    bool hasReachedMax,
    bool hasReachBottomMax,
    String wallpaperPath,
    int unreadCount,
    bool showBottomPin,
    ChatEntity chatEntity
  });
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
  ChatInitial copyWith ({
    bool hasReachBottomMax,
    List<Message> messages,
    bool hasReachedMax,
    String wallpaperPath,
    int focusMessageID,
    int unreadCount,
    bool showBottomPin,
    ChatEntity chatEntity
  }) {
    return ChatInitial(
      hasReachBottomMax: hasReachBottomMax ?? this.hasReachBottomMax,
      messages: messages ?? this.messages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      wallpaperPath: wallpaperPath ?? this.wallpaperPath,
      focusMessageID: focusMessageID ?? this.focusMessageID,
      unreadCount: unreadCount ?? this.unreadCount,
      showBottomPin: showBottomPin ?? this.showBottomPin,
      chatEntity: chatEntity ?? this.chatEntity,
      isSecretModeOn: this.isSecretModeOn
    );
  }

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
  ChatLoading copyWith ({
    bool hasReachBottomMax,
    List<Message> messages,
    bool hasReachedMax,
    String wallpaperPath,
    int focusMessageID,
    int unreadCount,
    bool showBottomPin,
    bool isPagination,
    ChatEntity chatEntity
  }) {
    return ChatLoading(
      hasReachBottomMax: hasReachBottomMax ?? this.hasReachBottomMax,
      messages: messages ?? this.messages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      wallpaperPath: wallpaperPath ?? this.wallpaperPath,
      unreadCount: unreadCount ?? this.unreadCount,
      showBottomPin: showBottomPin ?? this.showBottomPin,
      isPagination: isPagination ?? this.isPagination,
      chatEntity: chatEntity ?? this.chatEntity,
      isSecretModeOn: this.isSecretModeOn
    );
  }
 
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
  ChatLoadingSilently copyWith ({
    bool hasReachBottomMax,
    List<Message> messages,
    bool hasReachedMax,
    String wallpaperPath,
    int focusMessageID,
    int unreadCount,
    bool showBottomPin,
    bool isPagination,
    ChatEntity chatEntity
  }) {
    return ChatLoadingSilently(
      hasReachBottomMax: hasReachBottomMax ?? this.hasReachBottomMax,
      messages: messages ?? this.messages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      wallpaperPath: wallpaperPath ?? this.wallpaperPath,
      unreadCount: unreadCount ?? this.unreadCount,
      showBottomPin: showBottomPin ?? this.showBottomPin,
      chatEntity: chatEntity ?? this.chatEntity,
      isSecretModeOn: this.isSecretModeOn
    );
  }

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
  ChatError copyWith ({
    bool hasReachBottomMax,
    List<Message> messages,
    bool hasReachedMax,
    String wallpaperPath,
    int focusMessageID,
    int unreadCount,
    bool showBottomPin,
    bool isPagination,
    String message,
    ChatEntity chatEntity
  }) {
    return ChatError(
      hasReachBottomMax: hasReachBottomMax ?? this.hasReachBottomMax,
      messages: messages ?? this.messages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      wallpaperPath: wallpaperPath ?? this.wallpaperPath,
      unreadCount: unreadCount ?? this.unreadCount,
      showBottomPin: showBottomPin ?? this.showBottomPin,
      message: message ?? this.message,
      chatEntity: chatEntity ?? this.chatEntity,
      isSecretModeOn: this.isSecretModeOn
    );
  }

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
