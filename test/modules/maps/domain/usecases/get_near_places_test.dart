import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/maps/domain/entities/place.dart';
import 'package:messenger_mobile/modules/maps/domain/repositories/map_repository.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/get_near_places.dart';
import 'package:mockito/mockito.dart';
import 'package:latlong/latlong.dart';

class MockMapRepository extends Mock implements MapRepository {}

void main() {
  MockMapRepository mockMapRepository;
  GetNearbyPlaces usecase;

  setUp(() {
    mockMapRepository = MockMapRepository();
    usecase = GetNearbyPlaces(repository: mockMapRepository);
  });

  test('shuld call repository.getNearbyPlaces once and return List<Place>',
      () async {
    final LatLng params = LatLng(0.0, 0.0);
    final List<Place> places = [
      Place(title: 'title', position: params, street: 'street')
    ];

    final Right<Failure, List<Place>> result = Right(places);

    when(mockMapRepository.getNearbyPlaces(params))
        .thenAnswer((_) async => result);

    final actual = await usecase(params);

    expect(actual, equals(result));
    verify(mockMapRepository.getNearbyPlaces(params));
    verifyNoMoreInteractions(mockMapRepository);
  });
}
