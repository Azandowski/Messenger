import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_actions.dart';

import '../../domain/entities/chat_actions.dart';
import '../../domain/entities/message.dart';
import 'message_user_model.dart';

class MessageModel extends Message {
  final int id;
  final bool isRead;
  final DateTime dateTime;
  final String text;
  final MessageUser user;
  final MessageUser toUser;
  final ChatActions chatActions;
  final int colorId;
  final int deletionSeconds;
  final DateTime willBeDeletedAt;
  List<Message> transfer;
  final MessageStatus messageStatus;
  final MessageChat chat;
  MessageHandleType messageHandleType;
  final int timeDeleted;

  MessageModel({
    this.id,
    this.isRead,
    this.transfer,
    this.dateTime,
    this.text,
    this.user,
    this.colorId,
    this.chatActions,
    this.deletionSeconds,
    this.willBeDeletedAt,
    this.messageStatus = MessageStatus.sent,
    this.toUser,
    this.chat,
    this.messageHandleType = MessageHandleType.newMessage,
    this.timeDeleted
  }) : super(
    id: id,
    isRead: isRead,
    colorId: colorId,
    text: text,
    dateTime: dateTime,
    transfer: transfer,
    user: user,
    chatActions: chatActions,
    willBeDeletedAt: willBeDeletedAt,
    deletionSeconds: deletionSeconds,
    messageStatus: messageStatus,
    toUser: toUser,
    chat: chat,
    messageHandleType: messageHandleType,
    timeDeleted: timeDeleted
  );

  factory MessageModel.fromJson(Map json) {
    return MessageModel(
      id: json['id'],
      colorId: json['color'] is Map ? json['color']['color'] : json['color'],
      user: json['from_contact'] != null ? 
        MessageUserModel.fromJson(json['from_contact']) : null,
      toUser: json['to_contact'] != null ?
        MessageUserModel.fromJson(json['to_contact']) : null,
      text: json['text'],
      isRead: json['is_read'] == 1,
      dateTime: DateTime.parse(json['created_at']).toLocal(),
      chatActions: json['action'] == null ? null : 
        ChatActions.values.firstWhere((e) => e.key == json['action'], orElse: () => null),
      willBeDeletedAt: json['deleted_at']  != null ? 
        DateTime.parse(json['deleted_at']).toLocal() : null,
      deletionSeconds: json['time_deleted'],
      transfer: json['transfer'] != null ? 
        (json['transfer'] as List).map((v) => Transfer.fromJson(v)).toList() : [],
      chat: json['chat'] == null ? null :
        MessageChatModel.fromJson(json['chat']),
      timeDeleted: json['time_deleted']
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
      'to_contact': toUser?.toJson()
    };
  }
}

// ignore: must_be_immutable
class Transfer extends Message {
  final int id;
  final ChatActions action;
  final bool isRead;
  final DateTime dateTime;
  final MessageUser user;
  int fromId;
  int toId;
  String text;
  int chatId;
  String updatedAt;

  Transfer({
    this.id,
    this.fromId,
    this.toId,
    this.text,
    this.action,
    this.chatId,
    this.isRead,
    this.user,
    this.dateTime,
    this.updatedAt,
  }) : super(
    id: id,
    isRead: isRead,
    dateTime: dateTime,
    user: user,
    text: text,
    chatActions: action
  );

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      id: json['id'],
      fromId: json['from_id'],
      toId: json['to_id'],
      text: json['text'],
      action: ChatActions.values.firstWhere((e) => e.key == json['action'], orElse: () => null),
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


class MessageChatModel extends MessageChat {
  final int id;
  final String name;

  MessageChatModel({
    @required this.id,
    @required this.name
  }) : super(id: id, name: name);


  factory MessageChatModel.fromJson(Map<String, dynamic> json) {
    return MessageChatModel(
      id: json['id'],
      name: json['name']
    );
  }

  Map toJson () { 
    return {
      'id': id,
      'name': name,
    };
  }
}