import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/services/network/config.dart';

import '../../domain/entities/category.dart';

class CategoryModel extends CategoryEntity {
  final int id;
  final String name;
  final String avatar;
  final int totalChats;
  final int noReadCount;
  final int appChatID;

  CategoryModel(
      {@required this.id,
      @required this.name,
      @required this.avatar,
      @required this.totalChats,
      @required this.noReadCount,
      @required this.appChatID})
      : super(
            id: id,
            name: name,
            avatar: avatar,
            totalChats: totalChats,
            noReadCount: noReadCount,
            appChatID: appChatID);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'] == '/'
          ? null
          : json['full_link'] ??
              (json['avatar'] != null
                  ? ConfigExtension.buildURLHead() + json['avatar']
                  : null),
      totalChats: json['total_chats'],
      noReadCount: json['no_read_message'],
      appChatID: json['app_chat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'full_link': avatar,
      'total_chats': totalChats,
      'no_read_message': noReadCount,
      'app_chat': appChatID
    };
  }

  @override
  String toString() {
    return "CategoryModel [id:$id name:$name avatar:$avatar totalChats:$totalChats noReadCount:$noReadCount]";
  }
}
