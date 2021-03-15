import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'chat_actions.dart';

enum MessageStatus {sending, sent,}

class Message extends Equatable {
  final int id;
  final bool isRead;
  final DateTime dateTime;
  final String text;
  final MessageUser user;
  final ChatActions chatActions;
  MessageStatus messageStatus;
  List<Message> transfer;
  int identificator;
  final int colorId;
  final int deletionSeconds;
  final DateTime willBeDeletedAt;
  
  Message({
    this.text,
    this.identificator,
    this.dateTime,
    this.user,
    this.colorId,
    this.id,
    this.isRead,
    this.chatActions,
    this.willBeDeletedAt,
    this.deletionSeconds,
    this.messageStatus = MessageStatus.sent,
    this.transfer,
  });

  @override
  List<Object> get props => [
    dateTime, 
    text, 
    user,
    isRead,
    id, 
    chatActions,
    messageStatus,
    identificator,
    colorId,
    willBeDeletedAt,
    deletionSeconds,
    transfer,
  ];

   Message copyWith({
     int id,
     bool isRead,
     DateTime dateTime,
     String text,
     MessageUser user,
     ChatActions chatActions,
     MessageStatus status,
     List<Message> transfer,
     int colorId,
     int identificator,
     int deletionSeconds,
     DateTime willBeDeletedAt
  }) {
    return Message(
      id: id ?? this.id,
      isRead: isRead ?? this.isRead,
      colorId: colorId ?? this.colorId,
      text: text ?? this.text,
      dateTime: dateTime ?? this.dateTime,
      user: user ?? this.user,
      chatActions: chatActions ?? null,
      messageStatus: status ?? this.messageStatus,
      identificator: identificator ?? this.identificator,
      transfer: transfer ?? this.transfer,
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

class MessageUser extends Equatable{
  final String name;
  final int id;
  final String avatarURL;
  final String phone;
  final String surname;

  MessageUser({
    @required this.id,
    this.name, 
    this.avatarURL,
    this.surname,
    this.phone
  });

  @override
  List<Object> get props => [id, name, surname, phone, avatarURL];

  Map toJson () {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'avatarURL': avatarURL
    };
  }
}