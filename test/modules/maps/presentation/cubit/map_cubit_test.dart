import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/maps/data/datasources/local_map_datasource.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/geocode_coordinate.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/get_current_position.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/get_near_places.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/search_places.dart';
import 'package:messenger_mobile/modules/maps/presentation/cubit/map_cubit.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockGetCurrentLocation extends Mock implements GetCurrentLocation {}

class MockGetNearbyPlaces extends Mock implements GetNearbyPlaces {}

class MockSearchPlaces extends Mock implements SearchPlaces {}

class MockGeocodeCoordinate extends Mock implements GeocodeCoordinate {}

void main() {
  MockGetCurrentLocation mockGetCurrentLocation;
  MockGetNearbyPlaces mockGetNearbyPlaces;
  MockSearchPlaces mockSearchPlaces;
  MockGeocodeCoordinate mockGeocodeCoordinate;
  MapCubit mapCubit;

  setUp(() {
    mockGetCurrentLocation = MockGetCurrentLocation();
    mockGetNearbyPlaces = MockGetNearbyPlaces();
    mockSearchPlaces = MockSearchPlaces();
    mockGeocodeCoordinate = MockGeocodeCoordinate();
    mapCubit = MapCubit(
      getCurrentLocation: mockGetCurrentLocation,
      getNearbyPlaces: mockGetNearbyPlaces,
      searchPlaces: mockSearchPlaces,
      geocodeCoordinate: mockGeocodeCoordinate,
    );
  });

  group('getCurrentUserPosition loadNearPlaces:false ', () {
    blocTest(
      'should emit [MapError] when failure received from usecase',
      build: () => mapCubit,
      act: (MapCubit mapCubit) {
        when(mockGetCurrentLocation(any)).thenAnswer((_) async =>
            Left(GeolocationFailure(LocationFailure.permissionDenied)));
        mapCubit.getCurrentUserPosition(loadNearPlaces: false);
      },
      expect: () => [
        MapError(locationFailure: LocationFailure.permissionDenied),
      ],
    );

    blocTest(
      'loadNearPlaces: false  >  should emit [MapInitial] when Position received from usecase',
      build: () => mapCubit,
      act: (MapCubit mapCubit) {
        when(mockGetCurrentLocation(any))
            .thenAnswer((_) async => Right(tPosition));
        mapCubit.getCurrentUserPosition(loadNearPlaces: false);
      },
      expect: () => [
        MapInitial(currentUserPosition: tPosition),
      ],
    );

    blocTest(
      'loadNearPlaces: true  >  should emit [MapInitial, MapLoading, MapError] when Position received from getCurrentLocation and getNearbyPlaces returned failure',
      build: () => mapCubit,
      act: (MapCubit mapCubit) {
        when(mockGetCurrentLocation(any))
            .thenAnswer((_) async => Right(tPosition));
        when(mockGetNearbyPlaces(any))
            .thenAnswer((_) async => Left(ServerFailure(message: 'message')));
        mapCubit.getCurrentUserPosition(loadNearPlaces: true);
      },
      expect: () => [
        MapInitial(currentUserPosition: tPosition),
        MapLoading(isPlacesLoading: true, currentUserPosition: tPosition),
        MapError(errorMessage: 'message', currentUserPosition: tPosition),
      ],
    );

    blocTest(
      'loadNearPlaces: true  >  should emit [MapInitial, MapLoading, MapInitial] when Position received from getCurrentLocation and getNearbyPlaces returned List<Place>',
      build: () => mapCubit,
      act: (MapCubit mapCubit) {
        when(mockGetCurrentLocation(any))
            .thenAnswer((_) async => Right(tPosition));
        when(mockGetNearbyPlaces(any)).thenAnswer((_) async => Right([tPlace]));
        mapCubit.getCurrentUserPosition(loadNearPlaces: true);
      },
      expect: () => [
        MapInitial(currentUserPosition: tPosition),
        MapLoading(isPlacesLoading: true, currentUserPosition: tPosition),
        MapInitial(currentUserPosition: tPosition, places: [tPlace]),
      ],
    );
  });

  group('getPlacesNear', () {
    blocTest(
      'should emit [MapLoading, MapError] getNearbyPlaces returned failure',
      build: () => mapCubit,
      act: (MapCubit mapCubit) {
        when(mockGetNearbyPlaces(any))
            .thenAnswer((_) async => Left(ServerFailure(message: 'message')));
        mapCubit.getPlacesNear(position: tLatLng);
      },
      expect: () => [
        MapLoading(isPlacesLoading: true),
        MapError(errorMessage: 'message'),
      ],
    );

    blocTest(
      'should emit [MapLoading, MapInitial] when getNearbyPlaces returned List<Place>',
      build: () => mapCubit,
      act: (MapCubit mapCubit) {
        when(mockGetNearbyPlaces(any)).thenAnswer((_) async => Right([tPlace]));
        mapCubit.getPlacesNear(position: tLatLng);
      },
      expect: () => [
        MapLoading(isPlacesLoading: true),
        MapInitial(places: [tPlace]),
      ],
    );
  });

  group('findPlaces', () {
    blocTest(
      'should emit [MapLoading, MapError] when searchPlaces returned failure',
      build: () => mapCubit,
      act: (MapCubit mapCubit) {
        when(mockSearchPlaces(any))
            .thenAnswer((_) async => Left(ServerFailure(message: 'message')));
        mapCubit.findPlaces('query');
      },
      expect: () => [
        MapLoading(isPlacesLoading: true),
        MapError(errorMessage: 'message'),
      ],
    );

    blocTest(
      'should emit [MapLoading, MapInitial] when searchPlaces returned List<Place>',
      build: () => mapCubit,
      act: (MapCubit mapCubit) {
        when(mockSearchPlaces(any)).thenAnswer((_) async => Right([tPlace]));
        mapCubit.findPlaces('query');
      },
      expect: () => [
        MapLoading(isPlacesLoading: true),
        MapInitial(places: [tPlace]),
      ],
    );
  });

  blocTest(
    'showLoading should emit [MapLoading]',
    build: () => mapCubit,
    act: (MapCubit mapCubit) {
      mapCubit.showLoading();
    },
    expect: () => [
      MapLoading(isPlacesLoading: true),
    ],
  );

  blocTest(
    'didSelectPlace should emit [MapInitial]',
    build: () => mapCubit,
    act: (MapCubit mapCubit) {
      mapCubit.didSelectPlace(tPlaceModel);
    },
    expect: () => [
      MapInitial(selectedPlace: tPlaceModel),
    ],
  );

  group('getMapPosition', () {
    blocTest(
      'should emit [MapLoading, MapInitial, MapError] when geocodeCoordinate returned failure',
      build: () => mapCubit,
      act: (MapCubit mapCubit) {
        when(mockGeocodeCoordinate(any))
            .thenAnswer((_) async => Left(ServerFailure(message: 'message')));
        mapCubit.getMapPosition(tLatLng);
      },
      expect: () => [
        MapLoading(isPlacesLoading: false, isProcessing: true),
        MapInitial(),
        MapError(errorMessage: 'message'),
      ],
    );

    blocTest(
      'should emit [MapLoading, MapInitial] when geocodeCoordinate returned List<Placemark>',
      build: () => mapCubit,
      act: (MapCubit mapCubit) {
        when(mockGeocodeCoordinate(any))
            .thenAnswer((_) async => Right([tPlacemark]));
        mapCubit.getMapPosition(tLatLng);
      },
      expect: () => [
        MapLoading(isPlacesLoading: false, isProcessing: true),
        MapInitial(),
      ],
    );
  });
  group('didSelectPosition', () {
    blocTest(
      'should emit [MapInitial] when position equals current position',
      build: () => mapCubit,
      act: (MapCubit mapCubit) {
        mapCubit
          ..setState(MapInitial(currentUserPosition: tPosition))
          ..didSelectPosition(tLatLng);
      },
      expect: () => [
        MapInitial(currentUserPosition: tPosition),
      ],
    );

    blocTest(
      'should emit [MapLoading, MapError] when position not equals to current position nor selected place\'s position + geocodeCoordinate return Failure',
      build: () => mapCubit,
      act: (MapCubit mapCubit) {
        when(mockGeocodeCoordinate(any)).thenAnswer(
          (_) async => Left(ServerFailure(message: 'message')),
        );
        mapCubit
          ..setState(MapInitial(
              currentUserPosition: tPosition2, selectedPlace: tPlace2))
          ..didSelectPosition(tLatLng);
      },
      expect: () => [
        // emits MapInitial because of setState
        MapInitial(currentUserPosition: tPosition2, selectedPlace: tPlace2),
        MapLoading(
          currentUserPosition: tPosition2,
          selectedPlace: tPlace2,
          isPlacesLoading: false,
          isProcessing: true,
        ),
        MapError(errorMessage: 'message', currentUserPosition: tPosition2),
      ],
    );

    blocTest(
      'should emit [MapLoading, MapError] when position not equals to current position nor selected place\'s position + geocodeCoordinate return empty list',
      build: () => mapCubit,
      act: (MapCubit mapCubit) {
        when(mockGeocodeCoordinate(any)).thenAnswer(
          (_) async => Right([]),
        );
        mapCubit
          ..setState(MapInitial(
              currentUserPosition: tPosition2, selectedPlace: tPlace2))
          ..didSelectPosition(tLatLng);
      },
      expect: () => [
        // emits MapInitial because of setState
        MapInitial(currentUserPosition: tPosition2, selectedPlace: tPlace2),
        MapLoading(
          currentUserPosition: tPosition2,
          selectedPlace: tPlace2,
          isPlacesLoading: false,
          isProcessing: true,
        ),
        MapError(
          errorMessage: 'Не удалось найти',
          currentUserPosition: tPosition2,
          selectedPlace: tPlace2,
        ),
      ],
    );

    blocTest(
      'should emit [MapLoading, MapLoading, MapInitial, MapInitial] when position not equals to current position nor selected place\'s position + geocodeCoordinate return List<Placemark>',
      build: () => mapCubit,
      act: (MapCubit mapCubit) {
        when(mockGeocodeCoordinate(any)).thenAnswer(
          (_) async => Right([tPlacemark]),
        );
        when(mockGetNearbyPlaces(any)).thenAnswer((_) async => Right([tPlace]));
        mapCubit
          ..setState(MapInitial(
              currentUserPosition: tPosition2, selectedPlace: tPlace2))
          ..didSelectPosition(tLatLng);
      },
      expect: () => [
        // emits MapInitial because of setState
        MapInitial(currentUserPosition: tPosition2, selectedPlace: tPlace2),
        MapLoading(
          currentUserPosition: tPosition2,
          selectedPlace: tPlace2,
          isPlacesLoading: false,
          isProcessing: true,
        ),
        MapLoading(
          currentUserPosition: tPosition2,
          selectedPlace: tPlace2,
          isPlacesLoading: true,
        ),
        isA<MapInitial>(),
        isA<MapInitial>(),
      ],
    );
  });
}
