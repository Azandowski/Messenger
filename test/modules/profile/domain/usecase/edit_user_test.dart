import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/modules/edit_profile/domain/repositories/edit_profile_repositories.dart';
import 'package:messenger_mobile/modules/profile/data/models/user_model.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/edit_user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/profile_params.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockEditProfileRepository extends Mock implements EditUserRepository {}

void main() {  
  EditUser useCase;
  MockEditProfileRepository repository;

  setUp(() {
    repository = MockEditProfileRepository();
    useCase = EditUser(repository);
  });

  final updatedUserModel = UserModel(
    name: 'name#2',
    surname: 'surname#2',
    patronym: 'surname#2',
    phoneNumber: '+77777777777'
  );

  test(
    'should get updated user from the repository',
    () async {
      // arrange
      when(repository.updateUser(any))
          .thenAnswer((_) async => Right(true));
      
      // act
      final result = await useCase(
        EditUserParams(
          token: '',
          name: updatedUserModel.name,
          surname: updatedUserModel.surname,
          patronym: updatedUserModel.patronym,
          phoneNumber: updatedUserModel.phoneNumber
        )
      );
      
      // assert
      
      expect(result, Right(true));
      verify(repository.updateUser(EditUserParams(
        token: '',
        name: updatedUserModel.name,
        surname: updatedUserModel.surname,
        patronym: updatedUserModel.patronym,
        phoneNumber: updatedUserModel.phoneNumber
      )));
    },
  );
}
