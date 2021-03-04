import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_permission_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_model.dart';
import 'package:messenger_mobile/modules/chats/data/model/category_model.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';

class ChatEntityModel extends ChatEntity {
  final int chatId;
  final CategoryEntity chatCategory;
  final String title;
  final String imageUrl;
  final DateTime date;
  final ChatPermissions permissions;
  final MessageModel lastMessage;

  ChatEntityModel({
    @required this.chatId, 
    @required this.chatCategory, 
    @required this.title, 
    @required this.imageUrl,
    @required this.date,
    @required this.permissions,
    this.lastMessage
  }) : super(
    chatId: chatId,
    chatCategory: chatCategory,
    title: title,
    imageUrl: imageUrl,
    date: date,
    permissions: permissions,
    lastMessage: lastMessage
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
      lastMessage: json['last_message'] != null ? MessageModel.fromJson(json['last_message']) : null
    );
  }
}