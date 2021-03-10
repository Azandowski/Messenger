import 'package:flutter/material.dart';
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
    color: getColor(colorId),
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

  static getColor(int colorId) {
    switch(colorId){
      case 1:
        return Colors.deepOrange.shade400;
      case 2:
        return Colors.cyan.shade300;
      case 3:
        return Colors.purple.shade400;
      case 4:
        return Colors.green.shade400;
      case 5:
        return Colors.indigo.shade400;
      case 6:
        return Colors.pink.shade400;
      case 7:
        return Colors.blue.shade400;
      case 8:
        return Colors.amber.shade400;
    }
  }
}

