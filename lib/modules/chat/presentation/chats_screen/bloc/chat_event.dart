part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class ChatScreenStarted extends ChatEvent {
  @override
  List<Object> get props => [];
}

class LoadMessages extends ChatEvent {
  final bool isPagination;
  final RequestDirection direction;
  final bool resetAll;

  /// Non-Null if chat should load message's region
  final int messageID;

  LoadMessages({
    @required this.isPagination,
    this.direction,
    this.messageID,
    this.resetAll = false
  });

  @override
  List<Object> get props => [
    isPagination, messageID, direction, resetAll
  ];
}

class MessageAdded extends ChatEvent {
  final Message message;

  MessageAdded({
   @required this.message
  });

  @override
  List<Object> get props => [message];
}

class MessageDelete extends ChatEvent {
  final List<int> ids;

  MessageDelete({
   @required this.ids
  });

  @override
  List<Object> get props => [ids];
}

class MessageSend extends ChatEvent {
  final Message forwardMessage;
  final String message;
  final int timeDeleted;

  MessageSend({
    this.message,
    this.forwardMessage,
    this.timeDeleted
  });

  @override
  List<Object> get props => [
    message, 
    forwardMessage,
    timeDeleted
  ];
}

class SetInitialTime extends ChatEvent {
  final bool isOn;

  SetInitialTime({
    this.isOn
  });

  @override
  List<Object> get props => [option];
}

class DisposeChat extends ChatEvent {
  @override
  List<Object> get props => [];
}

class ToggleBottomPin extends ChatEvent {
  final bool show;
  final int newUnreadCount;
  
  ToggleBottomPin({
    @required this.show,
    this.newUnreadCount
  });

  @override
  List<Object> get props => [
    show, newUnreadCount
  ];
}
