import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';

class ChatEntity extends Equatable {
  final int chatId;
  final CategoryEntity chatCategory;
  final String title;
  final String imageUrl;
  
  ChatEntity({
    @required this.chatCategory,
    @required this.title,
    @required this.imageUrl,
    @required this.chatId,
  });

  @override
  List<Object> get props => [
    chatCategory, 
    title, 
    imageUrl, 
    chatId
  ];

  ChatEntity clone() {
    return ChatEntity(
      chatId: this.chatId,
      title: this.title,
      chatCategory: this.chatCategory,
      imageUrl: this.imageUrl,
    );
  }
}
