import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/services/network/NetworkingService.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/authentication/data/datasources/remote_authentication_datasource.dart';
import 'package:messenger_mobile/modules/authentication/data/models/code_response.dart';
import 'package:messenger_mobile/modules/authentication/data/models/token_response.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

class MockNetworingService extends Mock implements NetworkingService {}

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  AuthenticationRemoteDataSourceImpl remoteDataSource;
  MockHttpClient httpClient;
  MockNetworingService networingService;
  setUp(() async {
    httpClient = MockHttpClient();
    networingService = MockNetworingService();
    remoteDataSource =
        AuthenticationRemoteDataSourceImpl(networkingService: networingService);
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
    verify(remoteDataSource.createCode(phone));
    expect(result, equals(codeEntity));
  });

  final code = '1289';
  final TokenModel tokenEntity = TokenModel(token: 'sometoken');

  test('should return token when valid code is typed', () async {
    //arrange
    when(http.post(any)).thenAnswer(
        (_) async => http.Response(json.encode(tokenEntity.toJson()), 200));
    //act
    final result = remoteDataSource.sendCode(code, phone);
    //verify
    verify(remoteDataSource.sendCode(phone, phone));
    expect(result, tokenEntity);
  });
}
