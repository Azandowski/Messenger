import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/authentication/domain/repositories/authentication_repository.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/get_token.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  GetToken usecase;
  MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = GetToken(mockAuthenticationRepository);
  });

  final tParams = NoParams();
  final tToken = "test";

  test(
    'should return String token from AuthenticationRepository',
    () async {
      // arrange
      when(mockAuthenticationRepository.getToken())
          .thenAnswer((_) async => Right(tToken));
      // act
      final result = await usecase(tParams);
      // assert
      expect(result, Right(tToken));
      verify(mockAuthenticationRepository.getToken());
      verifyNoMoreInteractions(mockAuthenticationRepository);
    },
  );
}
