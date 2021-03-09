import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Message extends Equatable {
  final int id;
  final bool isRead;
  final DateTime dateTime;
  final String text;
  final MessageUser user;

  Message({
    this.text,
    this.dateTime,
    this.user,
    this.id,
    this.isRead
  });

  @override
  List<Object> get props => [
    dateTime, 
    text, 
    user,
    isRead,
    id
  ];

   Message copyWith({
     int id,
     bool isRead,
     DateTime dateTime,
     String text,
     MessageUser user,
  }) {
    return Message(
      id: id ?? this.id,
      isRead: isRead ?? this.isRead,
      text: text ?? this.text,
      dateTime: dateTime ?? this.dateTime,
      user: user ?? this.user
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