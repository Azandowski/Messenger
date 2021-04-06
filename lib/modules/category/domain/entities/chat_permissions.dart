import 'package:equatable/equatable.dart';

class ChatPermissions extends Equatable {
  final bool isSoundOn;
  // Only Admins
  final bool isMediaSendOn;
  final bool adminMessageSend;
  final bool isForwardOn;
  final bool isSecret;

  ChatPermissions({
    this.isSoundOn = true,
    this.isMediaSendOn = true,
    this.isForwardOn = true,
    this.adminMessageSend = false,
    this.isSecret = false
  });

  ChatPermissions copyWith({
    bool isSoundOn,
    bool isMediaSendOn,
    bool adminMessageSend,
    bool isForwardOn,
    bool isSecret
  }) {
    return ChatPermissions(
      isSoundOn: isSoundOn ?? this.isSoundOn,
      isMediaSendOn: isMediaSendOn ?? this.isMediaSendOn,
      adminMessageSend: adminMessageSend ?? this.adminMessageSend,
      isForwardOn: isForwardOn ?? this.isForwardOn,
      isSecret: isSecret ?? this.isSecret
    );
  }

  @override
  List<Object> get props => [
    isSoundOn, 
    isMediaSendOn,
    adminMessageSend,
    isForwardOn,
    isSecret
  ];


  Map toJson () {
    return {
      'sound': isSoundOn ? 1 : 0,
      'admin_media_send': isMediaSendOn ? 0 : 1,
      'admin_message_send': adminMessageSend ? 1 : 0 ,
      'transfer_chat_message': isForwardOn ? 1 : 0,
      'is_secret': isSecret? 1 : 0
    };
  }
}
