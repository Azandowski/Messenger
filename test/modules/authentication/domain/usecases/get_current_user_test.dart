import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/authentication/domain/repositories/authentication_repository.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/get_current_user.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  GetCurrentUser usecase;
  MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = GetCurrentUser(mockAuthenticationRepository);
  });

  final tToken = 'randomstring';
  final tUser = User(
    name: "Name",
    surname: "Surname",
    patronym: "Patronym",
    phoneNumber: "+77777777777",
    profileImage: "path/to/image",
  );

  test(
    'should return User from AuthenticationRepository when token given',
    () async {
      // arrange
      when(mockAuthenticationRepository.getCurrentUser(tToken))
          .thenAnswer((_) async => Right(tUser));
      // act
      final result = await usecase(tToken);
      // assert
      expect(result, Right(tUser));
      verify(mockAuthenticationRepository.getCurrentUser(tToken));
      verifyNoMoreInteractions(mockAuthenticationRepository);
    },
  );
}
