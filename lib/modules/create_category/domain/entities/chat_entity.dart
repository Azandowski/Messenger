import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChatEntity extends Equatable {
  final int chatId;
  final List<String> chatCategories;
  final String title;
  final String imageUrl;
  final bool selected;
  
  ChatEntity({
    @required this.chatCategories,
    @required this.title,
    @required this.imageUrl,
    @required this.chatId,
    this.selected = false
  });

  @override
  List<Object> get props => [chatCategories, title, imageUrl, chatId, selected];

  ChatEntity copyWith({bool selected}) {
    return ChatEntity(
      selected: selected ?? this.selected,
      chatId: this.chatId,
      title: this.title,
      chatCategories: this.chatCategories,
      imageUrl: this.imageUrl,
    );
  }
}
