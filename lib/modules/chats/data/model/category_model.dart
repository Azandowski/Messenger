import 'package:flutter/foundation.dart';

import '../../domain/entities/category.dart';

class CategoryModel extends CategoryEntity {
  final int id;
  final String name;
  final String avatar;
  final int totalChats;
  final int noReadCount;

  CategoryModel(
      {@required this.id,
      @required this.name,
      @required this.avatar,
      @required this.totalChats,
      @required this.noReadCount})
      : super(
            id: id,
            name: name,
            avatar: avatar,
            totalChats: totalChats,
            noReadCount: noReadCount);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        id: json['id'],
        name: json['name'],
        avatar: json['avatar'] == '/' ? null : json['full_link'],
        totalChats: json['total_chats'],
        noReadCount: json['no_read_message']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'full_link': avatar,
      'total_chats': totalChats,
      'no_read_message': noReadCount
    };
  }

  @override
  String toString() {
    return "CategoryModel [id:$id name:$name avatar:$avatar totalChats:$totalChats noReadCount:$noReadCount]";
  }
}
