import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/token_entity.dart';
import 'package:messenger_mobile/modules/authentication/domain/repositories/authentication_repository.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/login.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  Login usecase;
  MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = Login(mockAuthenticationRepository);
  });

  final tParams = LoginParams(code: "0000", phoneNumber: "+77777777777");
  final tTokenEntity = TokenEntity(token: "test");

  test(
    'should return LoginEntity from AuthenticationRepository when LoginParam given',
    () async {
      // arrange
      when(mockAuthenticationRepository.login(tParams))
          .thenAnswer((_) async => Right(tTokenEntity));
      // act
      final result = await usecase(tParams);
      // assert
      expect(result, Right(tTokenEntity));
      verify(mockAuthenticationRepository.login(tParams));
      verifyNoMoreInteractions(mockAuthenticationRepository);
    },
  );
}
