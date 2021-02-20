import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
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
    remoteDataSource = AuthenticationRemoteDataSourceImpl(client: httpClient);
  });

  // MARK: - Local Data

  final phone = '+77055946560';
  final CodeModel codeEntity = CodeModel(id: 12, phone: phone, code: '1122', attempts: 0);
  final endpoint = Endpoints.createCode;

  test('should get code entity if successs', () async {
    // arrange
    
    when(httpClient.post(
      endpoint.buildURL(),
      headers: anyNamed('headers'),
      body: ''
    )).thenAnswer((_) async => http.Response(json.encode(codeEntity.toJson()), 200));
    
    // act
    final result = await remoteDataSource.createCode(phone);
  
    expect(result, equals(codeEntity));
  });

  test('should throw error if status is 400', () async {
    // arrange
    
    when(httpClient.post(
      endpoint.buildURL(),
      body: '',
      headers: endpoint.getHeaders(),
    )).thenAnswer((_) async => http.Response('mal sotri', 400));
    
    //act
    final call = remoteDataSource.createCode;
    
    //verify
    expect(() => call(phone), throwsA(isA<ServerFailure>()));
  });
}
