import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_actions.dart';

class Message extends Equatable {
  final int id;
  final bool isRead;
  final DateTime dateTime;
  final String text;
  final MessageUser user;
  final ChatActions chatActions;
  
  Message({
    this.text,
    this.dateTime,
    this.user,
    this.id,
    this.isRead,
    this.chatActions
  });

  @override
  List<Object> get props => [
    dateTime, 
    text, 
    user,
    isRead,
    id, 
    chatActions
  ];

   Message copyWith({
     int id,
     bool isRead,
     DateTime dateTime,
     String text,
     MessageUser user,
     ChatActions chatActions,
  }) {
    return Message(
      id: id ?? this.id,
      isRead: isRead ?? this.isRead,
      text: text ?? this.text,
      dateTime: dateTime ?? this.dateTime,
      user: user ?? this.user,
      chatActions: chatActions ?? null,
    );
  }
}

class MessageUser extends Equatable {
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