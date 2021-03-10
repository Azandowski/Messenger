import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/code_entity.dart';
import 'package:messenger_mobile/modules/authentication/domain/repositories/authentication_repository.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/create_code.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  CreateCode usecase;
  MockAuthenticationRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthenticationRepository();
    usecase = CreateCode(mockAuthRepository);
  });

  test('should get CodeEntity from repository when given phone number',
      () async {
    final phone = '+77777777777';
    final CodeEntity codeEntity = CodeEntity(id: 12, phone: phone, attempts: 0);
    //arrange
    when(mockAuthRepository.createCode(PhoneParams(phoneNumber: phone)))
        .thenAnswer((_) async => Right(codeEntity));
    //act
    final result = await usecase(PhoneParams(phoneNumber: phone));
    //verify
    expect(result, Right(codeEntity));
    verify(mockAuthRepository.createCode(PhoneParams(phoneNumber: phone)));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
