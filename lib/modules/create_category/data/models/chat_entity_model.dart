import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chats/data/model/category_model.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:messenger_mobile/modules/create_category/domain/entities/chat_entity.dart';

class ChatEntityModel extends ChatEntity {
  final int chatId;
  final List<CategoryEntity> chatCategories;
  final String title;
  final String imageUrl;

  ChatEntityModel({
    @required this.chatId, 
    @required this.chatCategories, 
    @required this.title, 
    @required this.imageUrl
  }) : super(
    chatId: chatId,
    chatCategories: chatCategories,
    title: title,
    imageUrl: imageUrl
  );

  factory ChatEntityModel.fromJson(
    Map<String, dynamic> json,
  ) {
    List jsonCategoriesArray = ((json['category_chat'] ?? []) as List);

    return ChatEntityModel(
      chatId: json['id'],
      title: json['name'],
      imageUrl: json['avatar'],
      chatCategories: jsonCategoriesArray.map((e) => CategoryModel.fromJson(e)).toList(),
    );
  }
}