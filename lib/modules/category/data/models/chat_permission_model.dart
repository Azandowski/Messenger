import '../../domain/entities/chat_permissions.dart';

class ChatPermissionModel extends ChatPermissions {
  final bool isSoundOn;

  ChatPermissionModel({
    this.isSoundOn = true
  }) : super(
    isSoundOn: isSoundOn
  );

  factory ChatPermissionModel.fromJson(Map<String, dynamic> json) {
    return ChatPermissionModel(
      isSoundOn: json['sound'] == 1
    );
  }
}