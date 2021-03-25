import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

void main() {
  test(
    'should return expected Transfer model when according json passed',
    () {
      final actual = Transfer.fromJson(jsonDecode(fixture('transfer.json')));

      expect(actual, equals(tTransfer));
    },
  );

  test(
    'should return expected json when Transfer model passed',
    () {
      final Map<String, dynamic> expected = {
        'id': 1,
        'from_id': 1,
        'to_id': 1,
        'text': 'text',
        'action': 'Ad User',
        'chat_id': 1,
        'is_read': 1,
        'updated_at': '2021-03-15 17:08:04.860545',
      };
      final actual = tTransfer.toJson();

      expect(actual, equals(expected));
    },
  );
}
