import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/maps/domain/repositories/map_repository.dart';
import 'package:messenger_mobile/modules/maps/domain/usecases/get_current_position.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockMapRepository extends Mock implements MapRepository {}

void main() {
  MockMapRepository mockMapRepository;
  GetCurrentLocation usecase;

  setUp(() {
    mockMapRepository = MockMapRepository();
    usecase = GetCurrentLocation(repository: mockMapRepository);
  });

  test('shuld call repository.getCurrentPosition once and return Position',
      () async {
    final Position position = Position(
      longitude: 0.0,
      latitude: 0.0,
      timestamp: date1,
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );

    final Right<GeolocationFailure, Position> result = Right(position);

    when(mockMapRepository.getCurrentPosition())
        .thenAnswer((_) async => result);

    final actual = await usecase(NoParams());

    expect(actual, equals(result));
    verify(mockMapRepository.getCurrentPosition());
    verifyNoMoreInteractions(mockMapRepository);
  });
}
