import 'package:equatable/equatable.dart';

class ChatPermissions extends Equatable {
  final bool isSoundOn;
  // Only Admins
  final bool isMediaSendOn;
  final bool adminMessageSend;
  final bool isForwardOn;

  ChatPermissions({
    this.isSoundOn = true,
    this.isMediaSendOn = true,
    this.isForwardOn = true,
    this.adminMessageSend = false,
  });

  ChatPermissions copyWith({
    bool isSoundOn,
    bool isMediaSendOn,
    bool adminMessageSend,
    bool isForwardOn
  }) {
    return ChatPermissions(
      isSoundOn: isSoundOn ?? this.isSoundOn,
      isMediaSendOn: isMediaSendOn ?? this.isMediaSendOn,
      adminMessageSend: adminMessageSend ?? this.adminMessageSend,
      isForwardOn: isForwardOn ?? this.isForwardOn
    );
  }

  @override
  List<Object> get props => [
    isSoundOn, 
    isMediaSendOn,
    adminMessageSend,
    isForwardOn
  ];
}
