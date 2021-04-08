import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_entity_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

void main() {
  test('should be subtype of ChatEntity', () {
    expect(tChatEntityModel, isA<ChatEntity>());
  });

  test('should return valid ChatEntityModel from json', () {
    final res =
        ChatEntityModel.fromJson(jsonDecode(fixture("chat_entity_model.json")));

    expect(res, equals(tChatEntityModel));
  });
}
