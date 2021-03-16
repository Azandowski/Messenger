import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'chat_actions.dart';

enum MessageStatus {sending, sent,}

enum MessageHandleType {newMessage, setTopMessage, unSetTopMessage}

class Message extends Equatable {
  final int id;
  final bool isRead;
  final DateTime dateTime;
  final String text;
  final MessageUser user;
  final MessageUser toUser;
  final ChatActions chatActions;
  MessageStatus messageStatus;
  List<Message> transfer;
  int identificator;
  final int colorId;
  final int deletionSeconds;
  final DateTime willBeDeletedAt;
  final MessageChat chat;
  final MessageHandleType messageHandleType;
  
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
    this.toUser,
    this.chat,
    this.messageHandleType = MessageHandleType.newMessage,
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
    toUser,
    chat,
    messageHandleType
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
     DateTime willBeDeletedAt,
     MessageUser toUser,
     MessageChat chat
  }) {
    return Message(
      id: id ?? this.id,
      isRead: isRead ?? this.isRead,
      colorId: colorId ?? this.colorId,
      text: text ?? this.text,
      dateTime: dateTime ?? this.dateTime,
      user: user ?? this.user,
      chatActions: chatActions ?? this.chatActions,
      messageStatus: status ?? this.messageStatus,
      identificator: identificator ?? this.identificator,
      transfer: transfer ?? this.transfer,
      toUser: toUser ?? this.toUser,
      chat: chat ?? this.chat
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
      'to_contact': toUser?.toJson(),
      'chat': chat?.toJson()
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


class MessageChat extends Equatable {
  final int id;
  final String name;

  MessageChat({
    @required this.id,
    @required this.name
  });

  Map toJson () { 
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object> get props => [id, name];
}