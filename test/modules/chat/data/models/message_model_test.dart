import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_model.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_actions.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

void main() {
  test(
    'should return expected MessageModel when according json passed',
    () {
      final actual =
          MessageModel.fromJson(jsonDecode(fixture('message_model.json')));

      expect(actual, equals(tMessageModel));
    },
  );

  test(
    'should return expected json when MessageModel passed',
    () {
      final expected = {
        'id': 1,
        'color': 1,
        'from_contact': tMessageUserModel.toJson(),
        'to_contact': tMessageUserModel2.toJson(),
        'text': 'text',
        'is_read': 0,
        'created_at': date1.toIso8601String(),
        'action': ChatActions.addUser.key,
        'map': null,
        'contact': [
          {
            'id': 1,
            'name': 'name',
            'surname': 'surname',
            'phone': '+77777777777',
            'avatar': null,
          },
          {
            'id': 2,
            'name': 'name2',
            'surname': 'surname2',
            'phone': '+77777777777',
            'avatar': null,
          },
        ],
        'type': 'file',
      };
      final actual = tMessageModel.toJson();

      expect(actual, equals(expected));
    },
  );
}
