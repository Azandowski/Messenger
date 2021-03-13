import 'package:flutter/foundation.dart';

import '../../../chat/data/models/message_model.dart';
import '../../../chats/data/model/category_model.dart';
import '../../../chats/domain/entities/category.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/chat_permissions.dart';
import 'chat_permission_model.dart';

class ChatEntityModel extends ChatEntity {
  final int chatId;
  final CategoryEntity chatCategory;
  final String title;
  final String imageUrl;
  final DateTime date;
  final ChatPermissions permissions;
  final MessageModel lastMessage;
  final int unreadCount;
  final String description;

  ChatEntityModel({
    @required this.chatId, 
    @required this.chatCategory, 
    @required this.title, 
    @required this.imageUrl,
    @required this.date,
    @required this.permissions,
    @required this.description,
    this.lastMessage,
    this.unreadCount = 0,
  }) : super(
    chatId: chatId,
    chatCategory: chatCategory,
    title: title,
    imageUrl: imageUrl,
    date: date,
    permissions: permissions,
    lastMessage: lastMessage,
    unreadCount: unreadCount,
    description: description
  );

  factory ChatEntityModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ChatEntityModel(
      chatId: json['id'],
      title: json['name'],
      imageUrl: json['avatar'],
      chatCategory: json['category_chat'] != null ? CategoryModel.fromJson(json['category_chat']) : null,
      date: json['created_at'] != null ? 
        DateTime.parse(json['created_at']).toLocal() : null,
      permissions: json['settings'] != null ? 
        ChatPermissionModel.fromJson(json['settings']) : ChatPermissionModel(),
      lastMessage: json['last_message'] != null ? MessageModel.fromJson(json['last_message']) : null,
      unreadCount: json['no_read_message'] ?? 0,
      description: json['description']
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
      'description': description
    };
  }
}
