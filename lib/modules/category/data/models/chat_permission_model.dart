import '../../domain/entities/chat_permissions.dart';

class ChatPermissionModel extends ChatPermissions {
  final bool isSoundOn;
  final bool isMediaSendOn;

  ChatPermissionModel({
    this.isSoundOn = true,
    this.isMediaSendOn = true
  }) : super(
    isSoundOn: isSoundOn,
    isMediaSendOn: isMediaSendOn
  );

  factory ChatPermissionModel.fromJson(Map<String, dynamic> json) {
    return ChatPermissionModel(
      isSoundOn: json['sound'] == 1,
      isMediaSendOn: json['admin_media_send'] == 1
    );
  }
}