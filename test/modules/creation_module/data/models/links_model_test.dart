import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_response.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final links = Links(url: "url", label: "label", active: true);

  test('should return valid Links model from json', () {
    final actual = Links.fromJson(jsonDecode(fixture('links.json')));
    expect(actual, links);
  });

  test('toJson should return valid map from Links object', () {
    final actual = links.toJson();
    final expected = {
      'url': 'url',
      'label': 'label',
      'active': true,
    };
    expect(actual, expected);
  });
}
