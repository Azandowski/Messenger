import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';

class CategoryModel extends CategoryEntity {
  final int id;
  final String name;
  final String avatar;
  final int totalChats;

  CategoryModel({
    @required this.id, 
    @required this.name, 
    @required this.avatar, 
    @required this.totalChats
  }) : super(
    id: id, 
    name: name, 
    avatar: avatar, 
    totalChats: totalChats
  );

  factory CategoryModel.fromJson(Map<String, dynamic> json) { 
    return CategoryModel();
  }

  Map<String, dynamic> toJson () {
    return {
    };
  }
}