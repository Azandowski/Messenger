import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_permission_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

void main() {
  test('should be subtype of ChatPermissions entity', () {
    expect(tChatPermissionModel, isA<ChatPermissions>());
  });

  test('shuld return ChatPermissionModel from json', () {
    final res = ChatPermissionModel.fromJson(
        jsonDecode(fixture('chat_permission_model.json')));
    expect(res, equals(tChatPermissionModel));
  });
}
