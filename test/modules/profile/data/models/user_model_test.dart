import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/services/network/config.dart';
import 'package:messenger_mobile/modules/profile/data/models/user_model.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  Map<String, dynamic> tJson;
  UserModel tUserModel;
  setUp(() {
    tJson = jsonDecode(fixture('user_model.json'));
    tUserModel = UserModel(
      id: 1,
      name: "Name",
      surname: "Surname",
      patronym: "Patronym",
      phoneNumber: "+77777777777",
      profileImage: ConfigExtension.buildURLHead() + "avatar",
      isBlocked: false,
    );
  });

  test('Should be subclass of a User entity', () {
    expect(tUserModel, isA<User>());
  });

  test('Shoud return correct json from UserModel', () {
    final result = tUserModel.toJson();
    tJson["avatar"] = ConfigExtension.buildURLHead() + "avatar";

    expect(result, tJson);
  });

  test('Should return expected UserModel from json', () {
    final result = UserModel.fromJson(tJson);
    expect(result, tUserModel);
  });
}
