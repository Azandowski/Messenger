import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
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
    profileDataSourceImpl = ProfileDataSourceImpl(client: httpClient);
  });

  // MARK: - Local Props

  final token = '1853|z0H7WZomuJ9MhLZ2yZI0VkZuD7f1SYzNh38BhpxT';
  final user = UserModel(name: 'Yerkebulan', phoneNumber: '+77470726323');

  test('Should load Profile', () async {
    when(httpClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
      .thenAnswer(
        (_) async => http.Response(json.encode(user.toJson()), 200));

    final result = await profileDataSourceImpl.getCurrentUser('token');

    expect(result, equals(user));
  });

  test('Shoule return Failure when status is wrong', () async {
    when(httpClient.post(any,
            headers: anyNamed('headers'), body: anyNamed('body')))
        .thenAnswer((_) async {
      print("called");
      return http.Response('ERROR OCCURED', 404);
    });

    final call = profileDataSourceImpl.getCurrentUser;

    expect(() => call(token), throwsA(isA<ServerFailure>()));
  });
}
