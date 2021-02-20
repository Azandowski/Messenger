import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/core/services/network/NetworkingService.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/profile/data/datasources/profile_datasource.dart';
import 'package:messenger_mobile/modules/profile/data/models/user_model.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

main() { 
  TestWidgetsFlutterBinding.ensureInitialized();
  ProfileDataSourceImpl profileDataSourceImpl;
  MockHttpClient httpClient;

  setUp(() async { 
    httpClient = MockHttpClient();
    sl.registerLazySingleton(() => NetworkingService(httpClient: httpClient));
    profileDataSourceImpl = ProfileDataSourceImpl();
  });

  test('Should load Profile', () async { 
    final token = '1853|z0H7WZomuJ9MhLZ2yZI0VkZuD7f1SYzNh38BhpxT';
    final endpoint = Endpoints.getCurrentUser;
    final user = UserModel(
      name: 'Yerkebulan',
      phoneNumber: '+77470726323'
    );

    when(httpClient.post(
      endpoint.buildURL(),
      headers: endpoint.getHeaders(token: token),
      body: jsonEncode({
        'application_id': '1' 
      }),
    )).thenAnswer((_) async => http.Response(json.encode(user.toJson()), 200));
    
    final result = await profileDataSourceImpl.getCurrentUser(token);
    print(result.phoneNumber);
    print(user.phoneNumber);
    expect(result, equals(user));
  });
}