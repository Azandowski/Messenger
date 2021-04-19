import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chats/data/model/category_model.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

void main() {
  test('shoud be subclass of CategoryEntity', () {
    expect(tCategoryModel, isA<CategoryEntity>());
  });

  test('should return expected CategoryModel when accordin json was given',
      () async {
    final actual =
        CategoryModel.fromJson(jsonDecode(fixture('category_model.json'))[0]);
    expect(actual, equals(tCategoryModel));
  });

  test('should return expected json when according CategoryEntity given', () {
    final actual = tCategoryModel.toJson();
    final expected = jsonDecode(fixture('category_model.json'))[0];
    expect(actual, equals(expected));
  });
}
