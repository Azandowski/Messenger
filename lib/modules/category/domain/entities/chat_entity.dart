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
  final int unreadCount;
  final String description;

  ChatEntity({
    @required this.chatCategory,
    @required this.title,
    @required this.imageUrl,
    @required this.chatId,
    @required this.date,
    @required this.permissions,
    @required this.unreadCount,
    @required this.description,
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
    date,
    unreadCount,
    description
  ];

  ChatEntity clone({
    ChatPermissions permissions,
    int unreadCount
  }) {
    return ChatEntity(
      chatId: this.chatId,
      title: this.title,
      chatCategory: this.chatCategory,
      imageUrl: this.imageUrl,
      date: this.date,
      permissions: permissions ?? ChatPermissions(
        isSoundOn: this.permissions.isSoundOn,
        isMediaSendOn: this.permissions.isMediaSendOn
      ),
      lastMessage: this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      description: description
    );
  }

  Map toJson () {
    return {
      'id': chatId,
      'name': title,
      'avatar': imageUrl,
      'chatCategory': chatCategory == null ? null : {
        'id': chatCategory.id,
        'name': chatCategory.name,
        'avatar': chatCategory.avatar,
        'full_link': chatCategory.avatar,
        'total_chats': chatCategory.totalChats,
      },
      'created_at': date == null ? null : date.toIso8601String(),
      'settings': {
        'sound': permissions.isSoundOn ? 1 : 0,
        'admin_media_send': permissions.isSoundOn ? 1 : 0
      },
      'last_message': lastMessage?.toJson(),
      'no_read_message': unreadCount,
      'description': description
    };
  }
}

