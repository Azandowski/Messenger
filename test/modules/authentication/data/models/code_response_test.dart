import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/authentication/data/models/code_response.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/code_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tCodeModel =
      CodeModel(id: 1, phone: '+77777777777', code: '0000', attempts: 0);
  test(
    'should be a subclass of CodeEntity',
    () async {
      // assert
      expect(tCodeModel, isA<CodeEntity>());
    },
  );

  test(
    'should return a valid CodeModel from json',
    () async {
      // arrange
      final Map<String, dynamic> json = jsonDecode(fixture('code_model.json'));
      // act
      final result = CodeModel.fromJson(json);
      // assert
      expect(result, tCodeModel);
    },
  );

  test(
    'should return a JSON map containing proper data',
    () async {
      // arrange
      final expectedMap = {
        'id': 1,
        'phone': '+77777777777',
        'code': '0000',
        'attempts': 0,
      };
      // act
      final actual = tCodeModel.toJson();
      // assert
      expect(actual, expectedMap);
    },
  );
}
