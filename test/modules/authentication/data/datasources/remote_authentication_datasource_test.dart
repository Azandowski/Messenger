import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/services/network/NetworkingService.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/authentication/data/datasources/remote_authentication_datasource.dart';
import 'package:messenger_mobile/modules/authentication/data/models/code_response.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  AuthenticationRemoteDataSourceImpl remoteDataSource;
  MockHttpClient httpClient;
  setUp(() async {
    httpClient = MockHttpClient();
    sl.registerLazySingleton(() => NetworkingService(httpClient: httpClient));
    remoteDataSource = AuthenticationRemoteDataSourceImpl();
  });
  final phone = '+77055946560';
  final CodeModel codeEntity =
      CodeModel(id: 12, phone: phone, code: '1122', attempts: 0);

  test('should get code entity if successs', () async {
    //arrange
    when(httpClient.post(any, headers: {}, body: {'phone': phone})).thenAnswer(
        (_) async => http.Response(json.encode(codeEntity.toJson()), 200));
    //act
    CodeModel result = await remoteDataSource.createCode(phone);
    //verify
    // verify(httpClient.post('https://aio-test.kulenkov-group.kz/api/createCode?',
    //     headers: {}, body: {'phone': phone}, encoding: null));
    verify(remoteDataSource.createCode(phone));
    expect(result, equals(codeEntity));
  });
}
