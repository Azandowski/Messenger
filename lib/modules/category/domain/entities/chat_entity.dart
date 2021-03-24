import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chats/data/model/chat_update_type.dart';
import '../../../chats/domain/entities/category.dart';
import 'chat_permissions.dart';

// ignore: must_be_immutable
class ChatEntity extends Equatable {
  
  final int chatId;
  final String title;
  final String imageUrl;
  final DateTime date;
  final ChatPermissions permissions;
  final Message lastMessage;
  final int unreadCount;
  final String description;
  final bool isPrivate;
  final bool isRead;
  final int adminID;
  CategoryEntity chatCategory;
  ChatUpdateType chatUpdateType;

  ChatEntity({
    this.chatCategory,
    @required this.title,
    this.imageUrl,
    @required this.chatId,
    @required this.date,
    this.permissions,
    this.unreadCount,
    this.description,
    this.lastMessage,
    this.isPrivate = false,
    this.isRead,
    this.chatUpdateType,
    this.adminID
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
    description,
    isPrivate,
    isRead,
    chatUpdateType,
    adminID
  ];

  ChatEntity clone({
    ChatPermissions permissions,
    int unreadCount,
    Message lastMessage
  }) {
    return ChatEntity(
      chatId: this.chatId,
      title: this.title,
      chatCategory: this.chatCategory,
      imageUrl: this.imageUrl,
      date: this.date,
      permissions: permissions ?? ChatPermissions(
        isSoundOn: this.permissions.isSoundOn,
        isMediaSendOn: this.permissions.isMediaSendOn,
        isForwardOn: this.permissions.isForwardOn
      ),
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      description: this.description,
      isPrivate: this.isPrivate,
      isRead: this.isRead,
      chatUpdateType: this.chatUpdateType,
      adminID: this.adminID
    );
  }

  Map toJson () {
    return {
      'id': chatId,
      'name': title,
      'avatar': imageUrl,
      'category_chat': chatCategory == null ? null : {
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
      'description': description,
      'is_private': isPrivate ? 1 : 0,
      'admin_id': adminID
    };
  }
}

