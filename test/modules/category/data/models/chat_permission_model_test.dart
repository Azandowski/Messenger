import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_permission_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  ChatPermissionModel chatPermissionModel;
  setUp(() {
    chatPermissionModel = ChatPermissionModel(
      isMediaSendOn: true,
      isSoundOn: true,
    );
  });

  test('should be subtype of ChatPermissions entity', () {
    expect(chatPermissionModel, isA<ChatPermissions>());
  });

  test('shuld return ChatPermissionModel from json', () {
    final res = ChatPermissionModel.fromJson(
        jsonDecode(fixture('chat_permission_model.json')));
    expect(res, equals(chatPermissionModel));
  });
}
