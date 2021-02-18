import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/authentication/data/datasources/remote_authentication_datasource.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/code_entity.dart';
import 'package:messenger_mobile/modules/authentication/domain/repositories/authentication_repository.dart';
import 'package:mockito/mockito.dart';

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  AuthenticationRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    remoteDataSource = AuthenticationRemoteDataSourceImpl();
  });

  test('should get code entity if successs', () async {
    //arrange
    final phone = '+77055946560';
    final CodeEntity codeEntity =
        CodeEntity(id: 12, phone: phone, code: '1122', attempts: 0);
    when(remoteDataSource.createCode(any))
        .thenAnswer((_) async => codeEntity);
    //act
    final result = await remoteDataSource.createCode(phone);
    //verify
    verify(remoteDataSource.createCode(phone));
    // expect(result, Right(codeEntity));
  });
}
