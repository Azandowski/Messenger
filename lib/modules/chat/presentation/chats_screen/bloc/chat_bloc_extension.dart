part of 'chat_bloc.dart';


extension ChatBlocExtension on ChatBloc {
  ChatState getNewState<T> ({
    bool hasReachBottomMax,
    List<Message> messages,
    bool hasReachedMax,
    File wallpaperFile,
    int focusMessageID,
    int unreadCount,
    bool showBottomPin,
    ChatEntity chatEntity,
    bool isPagination,
    String message,
    RequestDirection direction,
    Message topMessage,
    T oldState,
    bool isSecretModeOn,
    TimeOptions currentTimerOption,
    bool isTimerDeleted = false
  }) {
    if (T == ChatInitial || oldState is ChatInitial) {
      return ChatInitial(
        hasReachBottomMax: hasReachBottomMax ?? state.hasReachBottomMax,
        messages: messages ?? state.messages,
        hasReachedMax: hasReachedMax ?? state.hasReachedMax,
        wallpaperFile: wallpaperFile ?? state.wallpaperFile,
        focusMessageID: focusMessageID,
        unreadCount: unreadCount ?? state.unreadCount,
        showBottomPin: showBottomPin ?? state.showBottomPin,
        chatEntity: chatEntity ?? state.chatEntity,
        isSecretModeOn: isSecretModeOn ?? state.isSecretModeOn,
        topMessage: topMessage ?? state.topMessage,
        currentTimerOption: isTimerDeleted ? null : currentTimerOption ?? state.currentTimerOption
      );
    } else if (T == ChatLoading || oldState is ChatLoading) {
      return ChatLoading(
        hasReachBottomMax: hasReachBottomMax ?? state.hasReachBottomMax,
        messages: messages ?? state.messages,
        hasReachedMax: hasReachedMax ?? state.hasReachedMax,
        wallpaperFile: wallpaperFile ?? state.wallpaperFile,
        unreadCount: unreadCount ?? state.unreadCount,
        showBottomPin: showBottomPin ?? state.showBottomPin,
        isPagination: isPagination ?? false,
        chatEntity: chatEntity ?? state.chatEntity,
        isSecretModeOn: state.isSecretModeOn,
        direction: direction,
        topMessage: topMessage ?? state.topMessage,
        currentTimerOption: isTimerDeleted ? null : currentTimerOption ?? state.currentTimerOption
      );
    } else if (T == ChatLoadingSilently || oldState is ChatLoadingSilently) {
      return ChatLoadingSilently(
        hasReachBottomMax: hasReachBottomMax ?? state.hasReachBottomMax,
        messages: messages ?? state.messages,
        hasReachedMax: hasReachedMax ?? state.hasReachedMax,
        wallpaperFile: wallpaperFile ?? state.wallpaperFile,
        unreadCount: unreadCount ?? state.unreadCount,
        showBottomPin: showBottomPin ?? state.showBottomPin,
        chatEntity: chatEntity ?? state.chatEntity,
        isSecretModeOn: state.isSecretModeOn,
        topMessage: topMessage ?? state.topMessage,
        currentTimerOption: isTimerDeleted ? null : currentTimerOption ?? state.currentTimerOption
      );
    } else if (T == ChatError || oldState is ChatError) {
      return ChatError(
        hasReachBottomMax: hasReachBottomMax ?? state.hasReachBottomMax,
        messages: messages ?? state.messages,
        hasReachedMax: hasReachedMax ?? state.hasReachedMax,
        wallpaperFile: wallpaperFile ?? state.wallpaperFile,
        unreadCount: unreadCount ?? state.unreadCount,
        showBottomPin: showBottomPin ?? state.showBottomPin,
        message: message,
        chatEntity: chatEntity ?? state.chatEntity,
        isSecretModeOn: state.isSecretModeOn,
        topMessage: topMessage ?? state.topMessage,
        currentTimerOption: isTimerDeleted ? null : currentTimerOption ?? state.currentTimerOption
      );
    } 

    return null;
  }
}