import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/maps/domain/entities/place.dart';
import 'package:messenger_mobile/modules/maps/domain/repositories/map_repository.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/get_near_places.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/search_places.dart';
import 'package:mockito/mockito.dart';
import 'package:latlong/latlong.dart';

class MockMapRepository extends Mock implements MapRepository {}

void main() {
  MockMapRepository mockMapRepository;
  SearchPlaces usecase;

  setUp(() {
    mockMapRepository = MockMapRepository();
    usecase = SearchPlaces(repository: mockMapRepository);
  });

  test('shuld call repository.searchPlaces once and return List<Place>',
      () async {
    final latlng = LatLng(0.0, 0.0);
    final params = SearchPlacesParams(
      currentPosition: latlng,
      queryText: 'queryText',
    );

    final List<Place> places = [
      Place(title: 'title', position: latlng, street: 'street')
    ];

    final Right<Failure, List<Place>> result = Right(places);

    when(mockMapRepository.searchPlaces(params))
        .thenAnswer((_) async => result);

    final actual = await usecase(params);

    expect(actual, equals(result));
    verify(mockMapRepository.searchPlaces(params));
    verifyNoMoreInteractions(mockMapRepository);
  });
}
