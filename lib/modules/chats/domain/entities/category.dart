import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String avatar;
  final int totalChats;
  final int noReadCount;
  final int appChatID;

  CategoryEntity({
    @required this.id, 
    @required this.name, 
    @required this.avatar, 
    @required this.totalChats,
    @required this.noReadCount,
    @required this.appChatID
  });

  CategoryEntity clone() {
    return CategoryEntity(
      id: this.id,
      name: this.name,
      avatar: this.avatar,
      totalChats: this.totalChats,
      noReadCount: this.noReadCount,
      appChatID: this.appChatID
    );
  }

  bool get isSystemGroup {
    return appChatID == 1;
  }

  @override
  List<Object> get props => [
    id, name, avatar, totalChats, noReadCount, appChatID
  ];
} 