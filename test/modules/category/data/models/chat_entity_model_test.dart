import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/services/network/config.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_entity_model.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_permission_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_model.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_user_model.dart';
import 'package:messenger_mobile/modules/chats/data/model/category_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  ChatEntityModel chatEntityModel;
  setUp(() {
    DateTime date = DateTime.parse('2021-03-15 17:08:04.860545');

    final category = CategoryModel(
      id: 1,
      name: "name",
      avatar: "avatar",
      totalChats: 1,
    );

    final permissions = ChatPermissionModel(
      isMediaSendOn: true,
      isSoundOn: true,
    );

    final messageUser = MessageUserModel(
      id: 1,
      name: "name",
      surname: "surname",
      avatarURL: ConfigExtension.buildURLHead() + "imageUrl",
      // phone: "+77777777777",
    );

    final messageModel = MessageModel(
      id: 1,
      isRead: true,
      text: "text",
      colorId: 1,
      chatActions: null,
      dateTime: date,
      user: messageUser,
    );

    chatEntityModel = ChatEntityModel(
      chatId: 1,
      title: "name",
      imageUrl: "imageUrl",
      description: "description",
      unreadCount: 1,
      date: date,
      chatCategory: category,
      permissions: permissions,
      lastMessage: messageModel,
    );
  });

  test('should be subtype of ChatEntity', () {
    expect(chatEntityModel, isA<ChatEntity>());
  });

  test('should return valid ChatEntityModel from json', () {
    final res =
        ChatEntityModel.fromJson(jsonDecode(fixture("chat_entity_model.json")));

    expect(res, equals(chatEntityModel));
  });
}
