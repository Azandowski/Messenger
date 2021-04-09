import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/profile/data/models/user_model.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

void main() {
  final userModelJson = jsonDecode(fixture('user_model.json'));
  final userModelFullAvatarJson =
      jsonDecode(fixture('user_model_full_avatar.json'));
  test('Should be subclass of a User entity', () {
    expect(tUserModel, isA<User>());
  });

  test('Shoud return correct json from UserModel', () {
    final result = tUserModel.toJson();

    expect(result, userModelFullAvatarJson);
  });

  test('Should return expected UserModel from json when avatar url is not full',
      () {
    final result = UserModel.fromJson(userModelJson);
    expect(result, tUserModel);
  });

  test(
      'Should return expected UserModel from json when avatar url is full (with ://)',
      () {
    final result = UserModel.fromJson(userModelFullAvatarJson);
    expect(result, tUserModel);
  });
}
