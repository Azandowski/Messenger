import '../../domain/entities/chat_permissions.dart';

class ChatPermissionModel extends ChatPermissions {
  final bool isSoundOn;
  final bool isMediaSendOn;
  final bool adminMessageSend;
  final bool isForwardOn;
  final bool isSecret;

  ChatPermissionModel({
    this.isSoundOn = true,
    this.isMediaSendOn = true,
    this.adminMessageSend = false,
    this.isForwardOn = true,
    this.isSecret = false
  }) : super(
    isSoundOn: isSoundOn,
    isMediaSendOn: isMediaSendOn,
    adminMessageSend: adminMessageSend,
    isForwardOn: isForwardOn,
    isSecret: isSecret
  );

  factory ChatPermissionModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return ChatPermissionModel();
    } else {
      return ChatPermissionModel(
        isSoundOn: json['sound'] == 1,
        isMediaSendOn: json['admin_media_send'] == 1,
        adminMessageSend: json['admin_message_send'] == 1,
        isForwardOn: json['transfer_chat_message'] == 1,
        isSecret: json['is_secret'] == 1
      ); 
    }
  }

  Map toJson () {
    return {
      'sound': isSoundOn ? 1 : 0,
      'admin_media_send': isMediaSendOn ? 1 : 0,
      'admin_message_send': adminMessageSend ? 1 : 0 ,
      'transfer_chat_message': isForwardOn ? 1 : 0,
      'is_secret': isSecret? 1 : 0
    };
  }
}