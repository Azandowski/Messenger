import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/authentication/data/datasources/remote_authentication_datasource.dart';
import 'package:messenger_mobile/modules/authentication/data/models/code_response.dart';
import 'package:messenger_mobile/modules/authentication/data/models/token_response.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  AuthenticationRemoteDataSourceImpl remoteDataSource;
  MockHttpClient mockHttpClient;

  setUp(() async {
    mockHttpClient = MockHttpClient();
    remoteDataSource =
        AuthenticationRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('check create code', () {
    final phone = '+77055946560';
    final codeEntity =
        CodeModel(id: 12, phone: phone, code: '1122', attempts: 0);

    void setUpMockHttpClientFailure404() {
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(json.encode(codeEntity.toJson()), 200));
    }

    test('should get code entity if successs', () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      CodeModel result = await remoteDataSource.createCode(phone);
      //verify
      verify(remoteDataSource.createCode(phone));
    });
  });

  // final code = '1289';
  // final TokenModel tokenEntity = TokenModel(token: 'sometoken');

  // test('should return token when valid code is typed', () async {
  //   //arrange
  //   when(mockHttpClient.post(any)).thenAnswer((_) async {
  //     print('sdkasmdojkasmd');
  //     return http.Response(json.encode(tokenEntity.toJson()), 200);
  //   });
  //   //act
  //   final result = await remoteDataSource.sendCode(code, phone);
  //   //verify
  //   verify(remoteDataSource.sendCode(phone, phone));
  //   // expect(result, tokenEntity);
  // });
}
