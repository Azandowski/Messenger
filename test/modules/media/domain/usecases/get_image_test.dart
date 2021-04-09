import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/media/domain/repositories/media_repository.dart';
import 'package:messenger_mobile/modules/media/domain/usecases/get_image.dart';
import 'package:mockito/mockito.dart';

class MockMediaRepository extends Mock implements MediaRepository {}

void main() {
  MockMediaRepository mockMediaRepository;
  GetImage getImage;

  setUp(() {
    mockMediaRepository = MockMediaRepository();
    getImage = GetImage(mockMediaRepository);
  });

  test(
    'should call repository.getImage() once and return File',
    () async {
      final file = File('');
      final Right<Failure, File> expected = Right(file);
      when(mockMediaRepository.getImage(any)).thenAnswer((_) async => expected);

      final actual = await getImage(ImageSource.camera);

      expect(actual, equals(expected));
      verify(mockMediaRepository.getImage(ImageSource.camera));
      verifyNoMoreInteractions(mockMediaRepository);
    },
  );
}
