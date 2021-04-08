import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/data/models/file_media_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

void main() {
  test('should return expected FileMediaModel when according json was passed',
      () {
    final actual =
        FileMediaModel.fromJson(jsonDecode(fixture('file_media_model.json')));
    expect(actual, equals(tFileMediaModel));
  });

  test('should return expected json when FileMediaModel passed', () {
    final expected = {
      "id": 1,
      'file': 'url',
      'type': 'audio',
      'user_id': 1,
    };
    final actual = tFileMediaModel.toJson();
    expect(actual, equals(expected));
  });
}
