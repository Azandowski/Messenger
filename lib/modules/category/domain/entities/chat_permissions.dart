import 'package:equatable/equatable.dart';

class ChatPermissions extends Equatable {
  final bool isSoundOn;
  // Only Admins
  final bool isMediaSendOn;
  final bool adminMessageSend;

  ChatPermissions({
    this.isSoundOn = true,
    this.isMediaSendOn = true,
    this.adminMessageSend = false
  });

  ChatPermissions copyWith({
    bool isSoundOn,
    bool isMediaSendOn,
    bool adminMessageSend
  }) {
    return ChatPermissions(
      isSoundOn: isSoundOn ?? this.isSoundOn,
      isMediaSendOn: isMediaSendOn ?? this.isMediaSendOn,
      adminMessageSend: adminMessageSend ?? this.adminMessageSend
    );
  }

  @override
  List<Object> get props => [
    isSoundOn, 
    isMediaSendOn,
    adminMessageSend
  ];
}
