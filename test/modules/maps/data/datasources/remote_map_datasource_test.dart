import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/maps/data/datasources/remote_map_datasource.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient;
  RemoteMapDataSourceImpl remoteMapDataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteMapDataSource = RemoteMapDataSourceImpl(client: mockHttpClient);
  });

  group('getNearbyPlaces', () {
    test('should return PlaceResponse when status code is 2**', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(fixture('place_response.json'), 200));

      final actual = await remoteMapDataSource.getNearbyPlaces(tLatLng);

      expect(actual, equals(tPlaceResponse));
    });

    test('should throw ServerFailure when status code is NOT 2**', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('message', 400));

      expect(remoteMapDataSource.getNearbyPlaces(tLatLng),
          throwsA(isA<ServerFailure>()));
    });
  });

  group('searchPlaces', () {
    test('should return PlaceResponse when status code is 2**', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(fixture('place_response.json'), 200));

      final actual = await remoteMapDataSource.searchPlaces('query', tLatLng);

      expect(actual, equals(tPlaceResponse));
    });

    test('should throw ServerFailure when status code is NOT 2**', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('message', 400));

      expect(
        remoteMapDataSource.searchPlaces('query', tLatLng),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
