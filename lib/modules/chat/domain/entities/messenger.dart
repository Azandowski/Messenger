import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Message extends Equatable {
  final DateTime dateTime;
  final Message parent;
  final String audioLink;
  final List<String> photoURLs;
  final String text;
  final MessageUser user;

  Message({
    this.text,
    this.audioLink,
    this.dateTime,
    this.photoURLs,
    this.parent,
    this.user
  });

  @override
  List<Object> get props => [
    dateTime, 
    parent, 
    audioLink, 
    photoURLs, 
    text, 
    user
  ];
}

class MessageUser extends Equatable {
  final String name;
  final int id;

  MessageUser({
    @required this.id,
    this.name, 
  });

  @override
  List<Object> get props => [id, name];
}