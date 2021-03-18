import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_model.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_response.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final contacts = Contacts(
      currentPage: 1,
      firstPageUrl: "first_page_url",
      from: 1,
      lastPage: 1,
      lastPageUrl: "last_page_url",
      nextPageUrl: "next_page_url",
      path: "path",
      perPage: "per_page",
      prevPageUrl: "prev_page_url",
      to: 1,
      total: 1,
      data: [
        ContactModel.fromJson({
          "id": 1,
          "name": "name",
          "patronym": "patronym",
          "surname": "surname",
          "last_visit": "2021-03-15 17:08:04.860545",
          "avatar": "avatar"
        }),
      ],
      links: [
        Links.fromJson(
          {"url": "url", "label": "label", "active": true},
        ),
      ]);

  test('fromJson should return expected Contacts object when json passed', () {
    final actual = Contacts.fromJson(jsonDecode(fixture('contacts.json')));

    expect(actual, equals(contacts));
  });

  test('should return expected json when called toJson method', () {
    final actual = contacts.toJson();
    final expected = {
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
          "last_visit": DateTime.parse("2021-03-15 17:08:04.860545"),
          "avatar": "avatar"
        },
      ],
      "links": [
        {
          "url": "url",
          "label": "label",
          "active": true,
        },
      ],
    };

    expect(actual, equals(expected));
  });
}
