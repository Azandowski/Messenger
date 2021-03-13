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
  final int deletionSeconds;
  final DateTime willBeDeletedAt;
  final List<Message> transfers;
  final MessageStatus messageStatus;

  MessageModel({
    this.id,
    this.isRead,
    this.transfers,
    this.dateTime,
    this.text,
    this.user,
    this.colorId,
    this.chatActions,
    this.deletionSeconds,
    this.willBeDeletedAt,
    this.messageStatus
  }) : super(
    id: id,
    isRead: isRead,
    colorId: colorId,
    text: text,
    dateTime: dateTime,
    transfer: transfers,
    user: user,
    chatActions: chatActions,
    willBeDeletedAt: willBeDeletedAt,
    deletionSeconds: deletionSeconds,
    messageStatus: messageStatus
  );

  factory MessageModel.fromJson(Map json) {
    return MessageModel(
      id: json['id'],
      colorId: json['color'],
      user: json['from_contact'] != null ? 
        MessageUserModel.fromJson(json['from_contact']) : null,
      text: json['text'],
      isRead: json['is_read'] == 1,
      dateTime: DateTime.parse(json['created_at']).toLocal(),
      chatActions: ChatActions.values.firstWhere((e) => e.key == json['action'], orElse: () => null),
      willBeDeletedAt: json['deleted_at']  != null ? 
        DateTime.parse(json['deleted_at']).toLocal() : null,
      deletionSeconds: json['time_deleted'],
      transfers: json['transfer'] != null ? 
        (json['transfer'] as List).map((v) => Transfer.fromJson(v)).toList() : [],
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

class Transfer extends Message {
  final int id;
  int fromId;
  int toId;
  String text;
  String action;
  int chatId;
  final bool isRead;
  final DateTime dateTime;
  final MessageUser user;
  String updatedAt;

  Transfer(
      {this.id,
      this.fromId,
      this.toId,
      this.text,
      this.action,
      this.chatId,
      this.isRead,
      this.user,
      this.dateTime,
      this.updatedAt,}) : super(
        id: id,
        isRead: isRead,
        dateTime: dateTime,
        user: user,
      );

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      id: json['id'],
      fromId: json['from_id'],
      toId: json['to_id'],
      text: json['text'],
      action: json['action'],
      chatId: json['chat_id'],
      isRead: json['is_read'] == 1,
      dateTime: DateTime.parse(json['created_at']).toLocal(),
      updatedAt: json['updated_at'],
      user: json['from_contact'] != null ? 
        MessageUserModel.fromJson(json['from_contact']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from_id'] = this.fromId;
    data['to_id'] = this.toId;
    data['text'] = this.text;
    data['action'] = this.action;
    data['chat_id'] = this.chatId;
    data['is_read'] = this.isRead;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}