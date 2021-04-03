part of 'chat_bloc.dart';


extension ChatBlocExtension on ChatBloc {
  ChatState getNewState<T> ({
    bool hasReachBottomMax,
    List<Message> messages,
    bool hasReachedMax,
    String wallpaperPath,
    int focusMessageID,
    int unreadCount,
    bool showBottomPin,
    ChatEntity chatEntity,
    bool isPagination,
    String message,
    RequestDirection direction,
    Message topMessage,
    T oldState,
    bool isSecretModeOn
  }) {
    if (T == ChatInitial || oldState is ChatInitial) {
      return ChatInitial(
        hasReachBottomMax: hasReachBottomMax ?? state.hasReachBottomMax,
        messages: messages ?? state.messages,
        hasReachedMax: hasReachedMax ?? state.hasReachedMax,
        wallpaperPath: wallpaperPath ?? state.wallpaperPath,
        focusMessageID: focusMessageID,
        unreadCount: unreadCount ?? state.unreadCount,
        showBottomPin: showBottomPin ?? state.showBottomPin,
        chatEntity: chatEntity ?? state.chatEntity,
        isSecretModeOn: isSecretModeOn ?? state.isSecretModeOn,
        topMessage: topMessage ?? state.topMessage,
      );
    } else if (T == ChatLoading || oldState is ChatLoading) {
      return ChatLoading(
        hasReachBottomMax: hasReachBottomMax ?? state.hasReachBottomMax,
        messages: messages ?? state.messages,
        hasReachedMax: hasReachedMax ?? state.hasReachedMax,
        wallpaperPath: wallpaperPath ?? state.wallpaperPath,
        unreadCount: unreadCount ?? state.unreadCount,
        showBottomPin: showBottomPin ?? state.showBottomPin,
        isPagination: isPagination ?? false,
        chatEntity: chatEntity ?? state.chatEntity,
        isSecretModeOn: state.isSecretModeOn,
        direction: direction,
        topMessage: topMessage ?? state.topMessage
      );
    } else if (T == ChatLoadingSilently || oldState is ChatLoadingSilently) {
      return ChatLoadingSilently(
        hasReachBottomMax: hasReachBottomMax ?? state.hasReachBottomMax,
        messages: messages ?? state.messages,
        hasReachedMax: hasReachedMax ?? state.hasReachedMax,
        wallpaperPath: wallpaperPath ?? state.wallpaperPath,
        unreadCount: unreadCount ?? state.unreadCount,
        showBottomPin: showBottomPin ?? state.showBottomPin,
        chatEntity: chatEntity ?? state.chatEntity,
        isSecretModeOn: state.isSecretModeOn,
        topMessage: topMessage ?? state.topMessage
      );
    } else if (T == ChatError || oldState is ChatError) {
      return ChatError(
        hasReachBottomMax: hasReachBottomMax ?? state.hasReachBottomMax,
        messages: messages ?? state.messages,
        hasReachedMax: hasReachedMax ?? state.hasReachedMax,
        wallpaperPath: wallpaperPath ?? state.wallpaperPath,
        unreadCount: unreadCount ?? state.unreadCount,
        showBottomPin: showBottomPin ?? state.showBottomPin,
        message: message,
        chatEntity: chatEntity ?? state.chatEntity,
        isSecretModeOn: state.isSecretModeOn,
        topMessage: topMessage ?? state.topMessage
      );
    } 

    return null;
  }
}