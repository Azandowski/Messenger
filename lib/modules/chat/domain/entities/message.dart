import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_actions.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';

enum MessageStatus {sending, sent,}

class Message extends Equatable {
  final int id;
  final bool isRead;
  final DateTime dateTime;
  final String text;
  final MessageUser user;
  final ChatActions chatActions;
  MessageStatus messageStatus;
  int identificator;
  final Color color;
  
  Message({
    this.text,
    this.identificator,
    this.dateTime,
    this.user,
    this.color,
    this.id,
    this.isRead,
    this.chatActions,
    this.messageStatus,
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
    color,
  ];

   Message copyWith({
     int id,
     bool isRead,
     DateTime dateTime,
     String text,
     MessageUser user,
     ChatActions chatActions,
     MessageStatus status,
     Color color,
     int identificator,
  }) {
    return Message(
      id: id ?? this.id,
      isRead: isRead ?? this.isRead,
      color: color ?? this.color,
      text: text ?? this.text,
      dateTime: dateTime ?? this.dateTime,
      user: user ?? this.user,
      chatActions: chatActions ?? null,
      messageStatus: messageStatus ?? this.messageStatus,
      identificator: identificator ?? this.identificator,
    );
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
}