import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/media/domain/repositories/media_repository.dart';
import 'package:messenger_mobile/modules/media/domain/usecases/get_video.dart';
import 'package:mockito/mockito.dart';

class MockMediaRepository extends Mock implements MediaRepository {}

void main() {
  MockMediaRepository mockMediaRepository;
  GetVideo getVideo;

  setUp(() {
    mockMediaRepository = MockMediaRepository();
    getVideo = GetVideo(mockMediaRepository);
  });

  test(
    'should call repository.getVideo() once and return File',
    () async {
      final file = File('');
      final Right<Failure, File> expected = Right(file);
      when(mockMediaRepository.getVideo()).thenAnswer((_) async => expected);

      final actual = await getVideo(NoParams());

      expect(actual, equals(expected));
      verify(mockMediaRepository.getVideo());
      verifyNoMoreInteractions(mockMediaRepository);
    },
  );
}
