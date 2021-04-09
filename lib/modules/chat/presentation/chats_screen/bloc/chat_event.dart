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
  final bool isInitial;

  /// Non-Null if chat should load message's region
  final int messageID;

  LoadMessages({
    @required this.isPagination,
    this.direction,
    this.messageID,
    this.resetAll = false,
    this.isInitial = false
  });

  @override
  List<Object> get props => [
    isPagination, messageID, direction, resetAll, isInitial
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
  final FieldFiles fieldFiles;
  final FieldAssets fieldAssets;
  final TimeOptions timeOption;
  final bool selectedTimer;
  final LatLng location;
  final String address;
  final MessageUser contact;
  final List<Uint8List> memoryPhotos;

  MessageSend({
    this.message,
    this.fieldAssets,
    this.fieldFiles,
    this.forwardMessage,
    this.timeOption,
    this.location,
    this.address,
    this.contact,
    this.memoryPhotos,
    this.selectedTimer = false
  });

  MessageSend copyWith ({
    TimeOptions timeOption,
    Message forwardMessage,
    bool selectedTimer
  }) => MessageSend(
    message: message,
    location: location,
    forwardMessage: forwardMessage ?? this.forwardMessage,
    timeOption: timeOption ?? this.timeOption,
    address: this.address,
    contact: contact,
    selectedTimer: selectedTimer ?? this.selectedTimer,
    fieldAssets: fieldAssets,
    fieldFiles: fieldFiles,
    memoryPhotos: memoryPhotos
  );

  @override
  List<Object> get props => [
    message, 
    forwardMessage,
    timeOption,
    location,
    fieldFiles,
    address,
    contact,
    selectedTimer
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


class PermissionsUpdated extends ChatEvent {
  final ChatPermissions newPermissions;

  PermissionsUpdated ({
    @required this.newPermissions
  });

  @override
  List<Object> get props => [
    newPermissions
  ];
}


class UpdateTimerOption extends ChatEvent {
  final TimeOptions newTimerOption;

  UpdateTimerOption({
    @required this.newTimerOption
  });

  @override
  List<Object> get props => [
    newTimerOption
  ];  
}