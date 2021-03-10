import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/authentication/domain/repositories/authentication_repository.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/logout.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  Logout usecase;
  MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = Logout(mockAuthenticationRepository);
  });

  final tParams = NoParams();

  test(
    'should get bool from AuthenticationRepository',
    () async {
      // arrange
      when(mockAuthenticationRepository.logout(tParams))
          .thenAnswer((_) async => Right(true));
      // act
      final result = await usecase(tParams);
      // assert
      expect(result, Right(true));
      verify(mockAuthenticationRepository.logout(tParams));
      verifyNoMoreInteractions(mockAuthenticationRepository);
    },
  );
}
