import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/authentication/data/datasources/remote_authentication_datasource.dart';
import 'package:messenger_mobile/modules/authentication/data/models/code_response.dart';
import 'package:messenger_mobile/modules/authentication/data/models/token_model.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../category/data/datasources/category_datasource_test.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockHttpMultipartRequest extends Mock implements http.MultipartRequest {}

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  AuthenticationRemoteDataSourceImpl remoteDataSource;
  MockHttpClient httpClient;
  MockMultiPartRequest request;

  setUp(() async {
    httpClient = MockHttpClient();
    request = MockMultiPartRequest();
    remoteDataSource = AuthenticationRemoteDataSourceImpl(
      client: httpClient,
      request: request,
    );
  });

  // MARK: - Local Data

  final phone = '+77055946560';
  final CodeModel codeEntity =
      CodeModel(id: 12, phone: phone, code: '1122', attempts: 0);

  group('createCode', () {
    test('should get code entity if successs', () async {
      // arrange
      when(httpClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async =>
              http.Response(json.encode(codeEntity.toJson()), 200));

      // act
      final result = await remoteDataSource.createCode(phone);
      //verify
      expect(result, equals(codeEntity));
    });

    test('should throw error if status is 400', () async {
      // arrange
      when(httpClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async {
        return http.Response('error', 400);
      });

      //act
      final call = remoteDataSource.createCode;

      //verify
      expect(() => call(phone), throwsA(isA<ServerFailure>()));
    });
  });

  group('login', () {
    TokenModel tTokenModel = TokenModel(token: 'sometoken');
    final code = '1122';
    test('should get token entity if successs', () async {
      // arrange

      when(httpClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async =>
              http.Response(json.encode(tTokenModel.toJson()), 200));

      // act
      final result = await remoteDataSource.login(phone, code);

      //verify
      expect(result, equals(tTokenModel));
    });

    test('should throw error if status is 400', () async {
      // arrange

      when(httpClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('invalid number', 400));

      //act
      final call = remoteDataSource.login;

      //verify
      expect(() => call(phone, code), throwsA(isA<ServerFailure>()));
    });
  });
}
