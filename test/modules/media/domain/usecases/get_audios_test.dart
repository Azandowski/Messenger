import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/media/domain/repositories/media_repository.dart';
import 'package:messenger_mobile/modules/media/domain/usecases/get_audios.dart';
import 'package:mockito/mockito.dart';

class MockMediaRepository extends Mock implements MediaRepository {}

void main() {
  MockMediaRepository mockMediaRepository;
  GetAudios getAudios;

  setUp(() {
    mockMediaRepository = MockMediaRepository();
    getAudios = GetAudios(mockMediaRepository);
  });

  test(
    'should call repository.getAudio() once and return List<File>',
    () async {
      final file = File('');
      final Right<Failure, List<File>> expected = Right([file]);
      when(mockMediaRepository.getAudio()).thenAnswer((_) async => expected);

      final actual = await getAudios(NoParams());

      expect(actual, equals(expected));
      verify(mockMediaRepository.getAudio());
      verifyNoMoreInteractions(mockMediaRepository);
    },
  );
}
