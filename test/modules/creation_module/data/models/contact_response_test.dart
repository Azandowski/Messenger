import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_response.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final contactResponse = ContactResponse(
    contacts: Contacts.fromJson(jsonDecode(fixture('contacts.json'))),
  );

  test('should return ContactResponse from valid JSON', () {
    final actual = ContactResponse.fromJson(
      jsonDecode(fixture('contact_response.json')),
    );

    expect(actual, equals(contactResponse));
  });

  test('should return expected json from ContactResponse', () {
    final actual = contactResponse.toJson();
    final date = DateTime.parse("2021-03-15 17:08:04.860545");
    final expected = {
      "contacts": {
        "current_page": 1,
        "first_page_url": "first_page_url",
        "from": 1,
        "last_page": 1,
        "last_page_url": "last_page_url",
        "next_page_url": "next_page_url",
        "path": "path",
        "per_page": "per_page",
        "prev_page_url": "prev_page_url",
        "to": 1,
        "total": 1,
        "data": [
          {
            "id": 1,
            "name": "name",
            "patronym": "patronym",
            "surname": "surname",
            "last_visit": date.toLocal().add(date.timeZoneOffset),
            "avatar": "avatar"
          }
        ],
        "links": [
          {"url": "url", "label": "label", "active": true}
        ]
      },
    };

    expect(actual, equals(expected));
  });
}
