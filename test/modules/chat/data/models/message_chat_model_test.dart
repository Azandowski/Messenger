import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

void main() {
  test(
    'should return expected MessageChatModel when according json passed',
    () {
      final actual = MessageChatModel.fromJson(
          jsonDecode(fixture('message_chat_model.json')));

      expect(actual, equals(tMessageChatModel));
    },
  );

  test(
    'should return expected json when MessageChatModel passed',
    () {
      final Map<String, dynamic> expected = {
        'id': 1,
        'name': 'name',
      };
      final actual = tMessageChatModel.toJson();

      expect(actual, equals(expected));
    },
  );
}
