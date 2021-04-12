import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/maps/data/models/place_response.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

void main() {
  test('should return expected PlaceResponse from given json', () {
    final actual =
        PlaceResponse.fromJson(jsonDecode(fixture('place_response.json')));
    expect(actual, equals(tPlaceResponse));
  });
}
