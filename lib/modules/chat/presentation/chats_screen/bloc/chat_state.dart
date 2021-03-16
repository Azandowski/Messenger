part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  final List<Message> messages;
  final bool hasReachedMax;
  final bool hasReachBottomMax;
  final String wallpaperPath;
  final int unreadCount;
  final bool showBottomPin;

  const ChatState({
    @required this.messages,
    @required this.hasReachedMax,
    this.hasReachBottomMax = true,
    this.wallpaperPath,
    this.unreadCount,
    this.showBottomPin
  });

  @override
  List<Object> get props => [
    messages, hasReachedMax, wallpaperPath, hasReachBottomMax,
    unreadCount, showBottomPin, showBottomPin
  ];

  ChatState copyWith ({
    List<Message> messages,
    bool hasReachedMax,
    bool hasReachBottomMax,
    String wallpaperPath,
    int unreadCount,
    bool showBottomPin,
  });
}

class ChatInitial extends ChatState {
  final bool hasReachBottomMax;
  final List<Message> messages;
  final bool hasReachedMax;
  final String wallpaperPath;
  final int focusMessageID;
  final int unreadCount;
  final bool showBottomPin;

  ChatInitial({
    @required this.messages,
    @required this.hasReachedMax,
    this.wallpaperPath,
    this.hasReachBottomMax = true,
    this.focusMessageID,
    this.unreadCount,
    this.showBottomPin
  }) : super(
    messages: messages, 
    hasReachedMax: hasReachedMax,
    wallpaperPath: wallpaperPath,
    hasReachBottomMax: hasReachBottomMax,
    unreadCount: unreadCount
  );

  @override
  ChatInitial copyWith ({
    bool hasReachBottomMax,
    List<Message> messages,
    bool hasReachedMax,
    String wallpaperPath,
    int focusMessageID,
    int unreadCount,
    bool showBottomPin
  }) {
    return ChatInitial(
      hasReachBottomMax: hasReachBottomMax ?? this.hasReachBottomMax,
      messages: messages ?? this.messages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      wallpaperPath: wallpaperPath ?? this.wallpaperPath,
      focusMessageID: focusMessageID ?? this.focusMessageID,
      unreadCount: unreadCount ?? this.unreadCount,
      showBottomPin: showBottomPin ?? this.showBottomPin
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
    showBottomPin
  ];
}


class ChatLoading extends ChatState {
  final bool isPagination;
  final List<Message> messages;
  final bool hasReachedMax;
  final bool hasReachBottomMax;
  final String wallpaperPath;
  final RequestDirection direction;
  final int unreadCount;
  final bool showBottomPin;

  ChatLoading({
    @required this.isPagination,
    @required this.messages,
    @required this.hasReachedMax,
    this.wallpaperPath,
    this.hasReachBottomMax = true ,
    this.direction,
    this.unreadCount,
    this.showBottomPin
  }) : super(
    messages: messages, 
    hasReachedMax: hasReachedMax,
    wallpaperPath: wallpaperPath,
    hasReachBottomMax: hasReachBottomMax,
    unreadCount: unreadCount
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
    bool isPagination
  }) {
    return ChatLoading(
      hasReachBottomMax: hasReachBottomMax ?? this.hasReachBottomMax,
      messages: messages ?? this.messages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      wallpaperPath: wallpaperPath ?? this.wallpaperPath,
      unreadCount: unreadCount ?? this.unreadCount,
      showBottomPin: showBottomPin ?? this.showBottomPin,
      isPagination: isPagination ?? this.isPagination
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
    showBottomPin
  ];  
}


/// При [ChatLoadingSilently] сообщения не будут загружаться
/// Это для [background] операции
class ChatLoadingSilently extends ChatState {
  final List<Message> messages;
  final bool hasReachedMax;
  final String wallpaperPath;
  final bool hasReachBottomMax;
  final int unreadCount;
  final bool showBottomPin;

  ChatLoadingSilently({
    @required this.messages,
    @required this.hasReachedMax,
    @required this.wallpaperPath,
    this.hasReachBottomMax = true,
    this.unreadCount,
    this.showBottomPin
  }) : super(
    messages: messages,
    hasReachBottomMax: hasReachBottomMax,
    hasReachedMax: hasReachedMax,
    unreadCount: unreadCount,
    wallpaperPath: wallpaperPath
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
    bool isPagination
  }) {
    return ChatLoadingSilently(
      hasReachBottomMax: hasReachBottomMax ?? this.hasReachBottomMax,
      messages: messages ?? this.messages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      wallpaperPath: wallpaperPath ?? this.wallpaperPath,
      unreadCount: unreadCount ?? this.unreadCount,
      showBottomPin: showBottomPin ?? this.showBottomPin,
    );
  }

  @override
  List<Object> get props => [
    messages, 
    hasReachedMax,
    wallpaperPath,
    hasReachBottomMax,
    unreadCount,
    showBottomPin
  ];
}


class ChatError extends ChatState {
  final bool hasReachBottomMax;
  final List<Message> messages;
  final String message;
  final bool hasReachedMax;
  final String wallpaperPath;
  final int unreadCount;
  final bool showBottomPin;

  ChatError({
    @required this.messages,
    @required this.message,
    @required this.hasReachedMax,
    this.wallpaperPath,
    this.hasReachBottomMax = true,
    this.unreadCount,
    this.showBottomPin
  }) : super(
    messages: messages, 
    hasReachedMax: hasReachedMax,
    wallpaperPath: wallpaperPath,
    hasReachBottomMax: hasReachBottomMax,
    unreadCount: unreadCount
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
    String message
  }) {
    return ChatError(
      hasReachBottomMax: hasReachBottomMax ?? this.hasReachBottomMax,
      messages: messages ?? this.messages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      wallpaperPath: wallpaperPath ?? this.wallpaperPath,
      unreadCount: unreadCount ?? this.unreadCount,
      showBottomPin: showBottomPin ?? this.showBottomPin,
      message: message ?? this.message
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
    showBottomPin
  ];
}
