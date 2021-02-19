import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/services/network/NetworkingService.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/authentication/data/datasources/remote_authentication_datasource.dart';
import 'package:messenger_mobile/modules/authentication/domain/entities/code_entity.dart';
import 'package:messenger_mobile/modules/authentication/domain/repositories/authentication_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:messenger_mobile/locator.dart' as serviceLocator;
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  AuthenticationRemoteDataSourceImpl remoteDataSource;

  

  setUp(() async {
    sl.registerLazySingleton(() => NetworkingService(
      httpClient: MockHttpClient()
    ));
    remoteDataSource = AuthenticationRemoteDataSourceImpl();
  });

  test('should get code entity if successs', () async {
    //arrange
    final phone = '+77055946560';
    final CodeEntity codeEntity =
        CodeEntity(id: 12, phone: phone, code: '1122', attempts: 0);
    when(remoteDataSource.createCode(phone))
        .thenAnswer((_) async => codeEntity);
    //act
    final result = await remoteDataSource.createCode(phone);
    //verify
    verify(remoteDataSource.createCode(phone));
    print("Response:");
    print(remoteDataSource.createCode(phone));
    // expect(result, Right(codeEntity));
  });
}
