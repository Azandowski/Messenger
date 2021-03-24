import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/services/network/config.dart';
import 'package:messenger_mobile/modules/chats/data/model/chat_update_type.dart';

import '../../../chat/data/models/message_model.dart';
import '../../../chats/data/model/category_model.dart';
import '../../../chats/domain/entities/category.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/chat_permissions.dart';
import 'chat_permission_model.dart';

// ignore: must_be_immutable
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
  final bool isPrivate;
  final bool isRead;
  final int adminID;
  ChatUpdateType chatUpdateType;

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
    this.isPrivate,
    this.isRead,
    this.chatUpdateType,
    this.adminID
  }) : super(
    chatId: chatId,
    chatCategory: chatCategory,
    title: title,
    imageUrl: imageUrl,
    date: date,
    permissions: permissions,
    lastMessage: lastMessage,
    unreadCount: unreadCount,
    description: description,
    isPrivate: isPrivate,
    isRead: isRead,
    chatUpdateType: chatUpdateType,
    adminID: adminID
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
      description: json['description'],
      isPrivate: json['is_private'] == 1 ,
      isRead: json['is_read'] == 1,
      adminID: json['admin_id']
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
      'is_read': isRead ? 1 : 0,
      'admin_id': adminID
    };
  }
}
