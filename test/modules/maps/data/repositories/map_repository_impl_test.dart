import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/modules/maps/data/datasources/local_map_datasource.dart';
import 'package:messenger_mobile/modules/maps/data/datasources/remote_map_datasource.dart';
import 'package:messenger_mobile/modules/maps/data/models/place_response.dart';
import 'package:messenger_mobile/modules/maps/data/repositories/map_repository_impl.dart';
import 'package:messenger_mobile/modules/maps/domain/entities/place.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/params.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../variables.dart';

class MockLocalMapDataSource extends Mock implements LocalMapDatasource {}

class MockRemoteMapDataSource extends Mock implements RemoteMapDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockLocalMapDataSource mockLocalMapDataSource;
  MockRemoteMapDataSource mockRemoteMapDataSource;
  MockNetworkInfo mockNetworkInfo;
  MapRepositoryImpl mapRepository;

  setUp(() {
    mockLocalMapDataSource = MockLocalMapDataSource();
    mockRemoteMapDataSource = MockRemoteMapDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mapRepository = MapRepositoryImpl(
      datasource: mockLocalMapDataSource,
      remoteMapDataSource: mockRemoteMapDataSource,
      networkInfo: mockNetworkInfo,
      testMode: true,
    );
  });

  group('getCurrentPosition', () {
    test('should return Position when permission is granted', () async {
      when(mockLocalMapDataSource.checkPermission())
          .thenAnswer((_) async => PermissionStatus.granted);
      when(mockLocalMapDataSource.getCurrentPosition())
          .thenAnswer((_) async => tPosition);

      final actual = await mapRepository.getCurrentPosition();

      expect(actual, equals(Right(tPosition)));
    });

    test(
        'should request permission when permission is denied and return position when granded',
        () async {
      when(mockLocalMapDataSource.checkPermission())
          .thenAnswer((_) async => PermissionStatus.denied);
      when(mockLocalMapDataSource.requestPermission())
          .thenAnswer((_) async => PermissionStatus.granted);

      when(mockLocalMapDataSource.getCurrentPosition())
          .thenAnswer((_) async => tPosition);

      final actual = await mapRepository.getCurrentPosition();

      expect(actual, equals(Right(tPosition)));
    });

    test(
        'should request permission when permission is denied and return position when granded 2',
        () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      when(mockLocalMapDataSource.checkPermission())
          .thenAnswer((_) async => PermissionStatus.denied);
      when(mockLocalMapDataSource.requestPermission())
          .thenAnswer((_) async => PermissionStatus.limited);

      final actual = await mapRepository.getCurrentPosition();

      expect(actual,
          equals(Left(GeolocationFailure(LocationFailure.permissionDenied))));
    });
  });

  group('getNearbyPlaces', () {
    test(
        'should check network connection and return ConnectionFailure if no connection',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final actual = await mapRepository.getNearbyPlaces(tLatLng);

      expect(actual, equals(Left(ConnectionFailure())));
      verify(mockNetworkInfo.isConnected);
      verifyZeroInteractions(mockLocalMapDataSource);
      verifyZeroInteractions(mockRemoteMapDataSource);
    });

    test('should return ServerFailure if there is some error', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteMapDataSource.getNearbyPlaces(tLatLng))
          .thenThrow(ServerFailure(message: 'message'));

      final actual = await mapRepository.getNearbyPlaces(tLatLng);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return List<Place> when everything OK', () async {
      final tPlaceResponse = PlaceResponse(items: [tPlace]);
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteMapDataSource.getNearbyPlaces(tLatLng))
          .thenAnswer((_) async => tPlaceResponse);

      final actual = await mapRepository.getNearbyPlaces(tLatLng);

      expect(actual, equals(Right<Failure, List<Place>>(tPlaceResponse.items)));
    });
  });

  group('searchPlaces', () {
    final params =
        SearchPlacesParams(currentPosition: tLatLng, queryText: 'queryText');
    test(
        'should check network connection and return ConnectionFailure if no connection',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final actual = await mapRepository.searchPlaces(params);

      expect(actual, equals(Left(ConnectionFailure())));
      verify(mockNetworkInfo.isConnected);
      verifyZeroInteractions(mockLocalMapDataSource);
      verifyZeroInteractions(mockRemoteMapDataSource);
    });

    test('should return ServerFailure if there is some error', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteMapDataSource.searchPlaces(any, any))
          .thenThrow(ServerFailure(message: 'message'));

      final actual = await mapRepository.searchPlaces(params);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return List<Place> when everything OK', () async {
      final tPlaceResponse = PlaceResponse(items: [tPlace]);
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteMapDataSource.searchPlaces(any, any))
          .thenAnswer((_) async => tPlaceResponse);

      final actual = await mapRepository.searchPlaces(params);

      expect(actual, equals(Right<Failure, List<Place>>(tPlaceResponse.items)));
    });
  });

  group('getPlaceMarksFromCoordinate', () {
    test(
        'should check network connection and return ConnectionFailure if no connection',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final actual = await mapRepository.getPlaceMarksFromCoordinate(tLatLng);

      expect(actual, equals(Left(ConnectionFailure())));
      verify(mockNetworkInfo.isConnected);
      verifyZeroInteractions(mockRemoteMapDataSource);
      verifyZeroInteractions(mockLocalMapDataSource);
    });

    test('should return ServerFailure if there is some error', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalMapDataSource.geocodeCoordinate(any))
          .thenThrow(ServerFailure(message: 'message'));

      final actual = await mapRepository.getPlaceMarksFromCoordinate(tLatLng);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return List<Place> when everything OK', () async {
      final placemarks = [tPlacemark];
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalMapDataSource.geocodeCoordinate(any))
          .thenAnswer((_) async => placemarks);

      final actual = await mapRepository.getPlaceMarksFromCoordinate(tLatLng);

      expect(actual, equals(Right<Failure, List<Placemark>>(placemarks)));
    });
  });
}
