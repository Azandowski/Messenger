import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String avatar;
  final int totalChats;

  CategoryEntity({
    @required this.id, 
    @required this.name, 
    @required this.avatar, 
    @required this.totalChats
  });

  CategoryEntity clone() {
    return CategoryEntity(
      id: this.id,
      name: this.name,
      avatar: this.avatar,
      totalChats: this.totalChats
    );
  }

  @override
  List<Object> get props => [
    id, name, avatar, totalChats
  ];
} 