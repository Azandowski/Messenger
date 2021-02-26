import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chats/data/model/category_model.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';

class ChatEntityModel extends ChatEntity {
  final int chatId;
  final CategoryEntity chatCategory;
  final String title;
  final String imageUrl;

  ChatEntityModel({
    @required this.chatId, 
    @required this.chatCategory, 
    @required this.title, 
    @required this.imageUrl
  }) : super(
    chatId: chatId,
    chatCategory: chatCategory,
    title: title,
    imageUrl: imageUrl
  );

  factory ChatEntityModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ChatEntityModel(
      chatId: json['id'],
      title: json['name'],
      imageUrl: json['avatar'],
      chatCategory: json['category_chat'] != null ? CategoryModel.fromJson(json['category_chat']) : null
    );
  }
}