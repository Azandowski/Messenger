import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

void main() {
  // final tContactModel = ContactModel(
  //   id: 1,
  //   name: "name",
  //   patronym: "patronym",
  //   surname: "surname",
  //   avatar: "avatar",
  //   lastVisit: DateTime.parse("2021-03-15 17:08:04.860545"),
  // );
  test('should build valid ContactModel from json', () {
    final result =
        ContactModel.fromJson(jsonDecode(fixture('contact_model.json')));
    expect(result, tContactModelLocal);
  });

  test('should return valid json from ContactModel', () {
    final result = tContactModel.toJson();
    final expected = {
      "id": 1,
      "name": "name",
      "surname": "surname",
      "patronym": "patronym",
      "avatar": "avatar",
      "last_visit": DateTime.parse("2021-03-15 17:08:04.860545"),
    };

    expect(result, expected);
  });
}
