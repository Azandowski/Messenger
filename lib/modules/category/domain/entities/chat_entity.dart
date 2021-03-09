import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../chat/data/models/message_model.dart';
import '../../../chats/domain/entities/category.dart';
import 'chat_permissions.dart';

class ChatEntity extends Equatable {
  final int chatId;
  final CategoryEntity chatCategory;
  final String title;
  final String imageUrl;
  final DateTime date;
  final ChatPermissions permissions;
  final MessageModel lastMessage;

  ChatEntity({
    @required this.chatCategory,
    @required this.title,
    @required this.imageUrl,
    @required this.chatId,
    @required this.date,
    @required this.permissions,
    this.lastMessage
  });

  @override
  List<Object> get props => [
    chatCategory, 
    title, 
    imageUrl, 
    chatId,
    lastMessage,
    permissions, 
    date
  ];

  ChatEntity clone() {
    return ChatEntity(
      chatId: this.chatId,
      title: this.title,
      chatCategory: this.chatCategory,
      imageUrl: this.imageUrl,
      date: this.date,
      permissions: ChatPermissions(
        isSoundOn: this.permissions.isSoundOn
      ),
      lastMessage: this.lastMessage
    );
  }
}
