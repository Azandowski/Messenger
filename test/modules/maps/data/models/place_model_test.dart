import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/maps/data/models/place_model.dart';
import 'package:messenger_mobile/modules/maps/domain/entities/place.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

void main() {
  test('should be subclass of a Place entitty', () {
    expect(tPlaceModel, isA<Place>());
  });

  test('should return expected PlaceModel from given json', () {
    final actual = PlaceModel.fromJson(jsonDecode(fixture('place_model.json')));
    expect(actual, equals(tPlaceModel));
  });
}
