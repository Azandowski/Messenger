import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/authentication/data/models/token_model.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/token_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final TokenModel tTokenModel = TokenModel(token: 'test');
  test('should be subclass of TokenEntity', () {
    expect(tTokenModel, isA<TokenEntity>());
  });

  test(
    'should return a valid model from JSON',
    () async {
      // arrange
      final json = jsonDecode(fixture('token_model.json'));
      // act
      final actual = TokenModel.fromJson(json);
      // assert
      expect(actual, tTokenModel);
    },
  );

  test(
    'should return valid json with proper data',
    () async {
      // arrange
      final Map<String, dynamic> json = {
        'access_token': 'test',
      };
      // act
      final actual = tTokenModel.toJson();
      // assert
      expect(actual, json);
    },
  );
}
