import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/authentication/domain/repositories/authentication_repository.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/save_token.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  SaveToken usecase;
  MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = SaveToken(mockAuthenticationRepository);
  });

  final tToken = 'test';

  test(
    'should call saveToken and ge token from AuthenticationRepository',
    () async {
      // arrange
      when(mockAuthenticationRepository.saveToken(tToken))
          .thenAnswer((_) async => Right(tToken));
      // act
      final result = await usecase(tToken);
      // assert
      expect(result, Right(tToken));
      verify(mockAuthenticationRepository.saveToken(tToken));
      verifyNoMoreInteractions(mockAuthenticationRepository);
    },
  );
}
