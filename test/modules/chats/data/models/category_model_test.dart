
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chats/data/model/category_model.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';

void main () { 
  final CategoryModel categoryModel = CategoryModel(
    id: 11,
    name: 'SuperWork',
    avatar: '/avatars/image.png',
    totalChats: 1
  );

  final categoryModelJson = {
    'name': 'SuperWork',
    'total_chats': 1,
    'avatar': '/avatars/image.png',
    'id': 11
  };

  test('check superclass', () async {
    expect(categoryModel, isA<CategoryEntity>());
  });

  test('should return a valid model when the JSON number is an correct', () async { 
    final result = CategoryModel.fromJson(categoryModelJson);
    expect(categoryModel, equals(result));
  });

  test ('should return a valid json when converting to map', ()  async {
    final result = categoryModel.toJson();
    expect(result, equals(categoryModelJson));
  });
}
