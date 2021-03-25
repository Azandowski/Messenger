import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/services/network/config.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_user_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

void main() {
  test(
    'should return expected MessageUserModel when according json passed',
    () {
      final actual = MessageUserModel.fromJson(
          jsonDecode(fixture('message_user_model.json')));

      expect(actual, equals(tMessageUserModel));
    },
  );

  test(
    'should return expected json when MessageUserModel passed',
    () {
      final Map<String, dynamic> expected = {
        'id': 1,
        'name': 'name',
        'surname': 'surname',
        'avatar': ConfigExtension.buildURLHead() + 'avatarURL',
        'phone': '+77777777777',
      };
      final actual = tMessageUserModel.toJson();

      expect(actual, equals(expected));
    },
  );
}
