import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/code_entity.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/token_entity.dart';
import 'package:messenger_mobile/modules/authentication/domain/repositories/authentication_repository.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/create_code.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/send_code.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  SendCode usecase;
  AuthenticationRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthenticationRepository();
    usecase = SendCode(mockAuthRepository);
  });

  test('should get code when there is a code', () async {
    final code = '1289';
    final TokenEntity tokenEntity = TokenEntity(token: 'sometoken');
    //arrange
    when(mockAuthRepository.sendCode(code))
        .thenAnswer((_) async => Right(tokenEntity));
    //act
    final result = await usecase(code);
    //verify
    expect(result, Right(tokenEntity));
    verify(mockAuthRepository.sendCode(code));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
