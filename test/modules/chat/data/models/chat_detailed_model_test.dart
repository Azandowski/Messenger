import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/data/models/chat_detailed_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

void main() {
  test(
    'should return expected ChatDetailedModel when according json passed',
    () {
      final actual = ChatDetailedModel.fromJson(
          jsonDecode(fixture('chat_detailed_model.json')));

      expect(actual, equals(tChatDetailedModelLocalMembers));
    },
  );
}