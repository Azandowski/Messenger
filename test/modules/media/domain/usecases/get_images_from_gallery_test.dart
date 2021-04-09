import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/media/domain/repositories/media_repository.dart';
import 'package:messenger_mobile/modules/media/domain/usecases/get_images_from_gallery.dart';
import 'package:mockito/mockito.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class MockMediaRepository extends Mock implements MediaRepository {}

void main() {
  MockMediaRepository mockMediaRepository;
  GetImagesFromGallery getImagesFromGallery;

  setUp(() {
    mockMediaRepository = MockMediaRepository();
    getImagesFromGallery = GetImagesFromGallery(mockMediaRepository);
  });

  test(
    'should call repository.getImagesFromGallery() once and return List<Asset>',
    () async {
      final assets = [Asset('id', 'name', 100, 100)];
      final Right<Failure, List<Asset>> expected = Right(assets);
      when(mockMediaRepository.getImagesFromGallery())
          .thenAnswer((_) async => expected);

      final actual = await getImagesFromGallery(NoParams());

      expect(actual, equals(expected));
      verify(mockMediaRepository.getImagesFromGallery());
      verifyNoMoreInteractions(mockMediaRepository);
    },
  );
}
