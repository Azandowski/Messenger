import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/maps/domain/repositories/map_repository.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/geocode_coordinate.dart';
import 'package:mockito/mockito.dart';
import 'package:latlong/latlong.dart';

class MockMapRepository extends Mock implements MapRepository {}

void main() {
  MockMapRepository mockMapRepository;
  GeocodeCoordinate usecase;

  setUp(() {
    mockMapRepository = MockMapRepository();
    usecase = GeocodeCoordinate(repository: mockMapRepository);
  });

  test(
      'shuld call repository.getPlaceMarksFromCoordinate once and return List<Placemark>',
      () async {
    final placeMark = Placemark(name: 'name', street: 'street');
    final LatLng params = LatLng(0.0, 0.0);
    final result = Right<Failure, List<Placemark>>([placeMark]);
    when(mockMapRepository.getPlaceMarksFromCoordinate(any))
        .thenAnswer((_) async => result);

    final actual = await usecase(params);

    expect(actual, equals(result));
    verify(mockMapRepository.getPlaceMarksFromCoordinate(params));
    verifyNoMoreInteractions(mockMapRepository);
  });
}
