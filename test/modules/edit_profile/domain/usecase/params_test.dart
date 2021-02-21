import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/profile_params.dart';

void main () { 
  EditUserParams userParams = EditUserParams(
    token: 'token',
    surname: 'Surname',
    patronym: 'Patronym',
    name: 'Name',
    phoneNumber: '+7'
  );

  final Map<String, String> jsonBody = {
    'surname': 'Surname',
    'patronym': 'Patronym',
    'name': 'Name',
    'phone': '+7'
  };

  test('Correctly created object from params', () async { 

    final result = userParams.jsonBody;
    expect(result, equals(jsonBody));
  });
}