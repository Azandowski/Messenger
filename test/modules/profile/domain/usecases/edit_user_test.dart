import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/edit_profile/domain/repositories/edit_profile_repositories.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/edit_user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/profile_params.dart';
import 'package:mockito/mockito.dart';

class MockEditUserRepository extends Mock implements EditUserRepository {}

void main() {
  MockEditUserRepository repository;
  EditUser usecase;

  setUp(() {
    repository = MockEditUserRepository();
    usecase = EditUser(repository);
  });

  EditUserParams tParams = EditUserParams(token: 'test');

  test(
    'should call updateUser and return bool',
    () async {
      // arrange
      when(repository.updateUser(tParams)).thenAnswer((_) async => Right(true));
      // act
      final result = await usecase(tParams);
      // assert
      expect(result, Right(true));
      verify(repository.updateUser(tParams));
      verifyNoMoreInteractions(repository);
    },
  );
}
