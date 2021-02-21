import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/services/network/config.dart';
import 'package:messenger_mobile/modules/profile/data/models/user_model.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';

void main () {
  final userModel = UserModel(
    name: 'Yerkebulan',
    surname: 'Surname',
    patronym: 'Patronym',
    phoneNumber: '+77470726323',
    profileImage: ConfigExtension.buildURLHead() + 'image.png'
  );

  test('check superclass', () async {
    expect(userModel, isA<User>());
  });

  group('fromJson', () { 
    test('should return a valid model when the JSON number is an integer', () async { 
      final Map<String, dynamic> jsonMap = {
        'name': 'Yerkebulan',
        'surname': 'Surname',
        'patronym': 'Patronym',
        'phone': '+77470726323',
        'avatar': 'image.png'
      };

      final result = UserModel.fromJson(jsonMap);
      expect(userModel, equals(result));
    });
  });

  test ('should return a valid json when converting to map', ()  async {
    final Map<String, dynamic> expectedJSON = {
      'name': 'Yerkebulan',
      'phone': '+77470726323',
      'avatar':  ConfigExtension.buildURLHead() +  'image.png',
      'surname': 'Surname',
      'patronym': 'Patronym',
    };

    final result = userModel.toJson();

    expect(result, equals(expectedJSON));
  });
 
}