import 'package:messenger_mobile/modules/chat/domain/entities/chat_actions.dart';

import '../../domain/entities/message.dart';
import 'message_user_model.dart';

class MessageModel extends Message {
  final int id;
  final bool isRead;
  final DateTime dateTime;
  final String text;
  final MessageUser user;
  final ChatActions chatActions;
  final int colorId;

  MessageModel({
    this.id,
    this.isRead,
    this.dateTime,
    this.text,
    this.user,
    this.colorId,
    this.chatActions
  }) : super(
    id: id,
    isRead: isRead,
    colorId: colorId,
    text: text,
    dateTime: dateTime,
    user: user,
    chatActions: chatActions
  );

  factory MessageModel.fromJson(Map json) {
    return MessageModel(
      id: json['id'],
      colorId: json['color'],
      user: json['from_contact'] != null ? 
        MessageUserModel.fromJson(json['from_contact']) : null,
      text: json['text'],
      isRead: json['is_read'] == 1,
      dateTime: DateTime.parse(json['created_at']),
      chatActions: ChatActions.values.firstWhere((e) => e.key == json['action'], orElse: () => null)
    );
  }

  Map toJson () {
    return {
      'id': id,
      'color': colorId,
      'from_contact': user?.toJson(),
      'text': text,
      'is_read': isRead ? 1 : 0,
      'created_at': dateTime.toIso8601String(),
      'action': chatActions?.key,
    };
  }
}

