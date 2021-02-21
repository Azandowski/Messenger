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
  AuthenticationRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthenticationRepository();
    usecase = CreateCode(mockAuthRepository);
  });

  test('should get code when there is a code', () async {
    final phone = '+77055946560';
    final CodeEntity codeEntity =
        CodeEntity(id: 12, phone: phone, attempts: 0);
    //arrange
    when(mockAuthRepository
            .createCode(PhoneParams(phoneNumber: '+77055946560')))
        .thenAnswer((_) async => Right(codeEntity));
    //act
    final result = await usecase(PhoneParams(phoneNumber: '+77055946560'));
    //verify
    expect(result, Right(codeEntity));
    verify(mockAuthRepository
        .createCode(PhoneParams(phoneNumber: '+77055946560')));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
