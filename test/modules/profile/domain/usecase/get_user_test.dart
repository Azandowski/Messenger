import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/modules/profile/domain/repositories/profile_respository.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/get_user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/profile_params.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';


class MockProfileRepository extends Mock implements ProfileRepository {}

void main() { 
  GetUser useCase;
  MockProfileRepository repository;

  setUp(() {
    repository = MockProfileRepository();
    useCase = GetUser(repository);
  });

  final user = User(
    name: 'Yerkebulan',
    phoneNumber: '+77470726323'
  );

  test(
    'should get user from the repository',
    () async {
      // arrange
      when(repository.getUser(any))
          .thenAnswer((_) async => Right(user));
      
      // act
      final result = await useCase(GetUserParams(token: '+++++'));
      
      // assert
      
      expect(result, Right(user));
      verify(repository.getUser(GetUserParams(token: '+++++')));
    },
  );
}