import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/media/data/datasources/local_media_datasource.dart';
import 'package:messenger_mobile/modules/media/data/repositories/media_repository_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class MockMediaLocalDataSource extends Mock implements MediaLocalDataSource {}

void main() {
  MockMediaLocalDataSource mockMediaLocalDataSource;
  MediaRepositoryImpl mediaRepository;

  setUp(() {
    mockMediaLocalDataSource = MockMediaLocalDataSource();
    mediaRepository =
        MediaRepositoryImpl(mediaLocalDataSource: mockMediaLocalDataSource);
  });

  group('getImage', () {
    test('should return Right(image) when OK', () async {
      final image = File('');
      when(mockMediaLocalDataSource.getImage(any))
          .thenAnswer((_) async => image);

      final actual = await mediaRepository.getImage(ImageSource.camera);

      expect(actual, Right(image));
    });

    test(
        'should return Left(StorageFailure()) when one thrown from localDataSource',
        () async {
      when(mockMediaLocalDataSource.getImage(any)).thenThrow(StorageFailure());

      final actual = await mediaRepository.getImage(ImageSource.camera);

      expect(actual, Left(StorageFailure()));
    });
  });

  group('getImagesFromGallery', () {
    test('should return Right(List<Asset>) when OK', () async {
      final assets = [Asset('id', 'name', 100, 100)];
      when(mockMediaLocalDataSource.getImagesFromGallery())
          .thenAnswer((_) async => assets);

      final actual = await mediaRepository.getImagesFromGallery();

      expect(actual, Right(assets));
    });

    test(
        'should return Left(StorageFailure()) when one thrown from localDataSource',
        () async {
      when(mockMediaLocalDataSource.getImagesFromGallery())
          .thenThrow(StorageFailure());

      final actual = await mediaRepository.getImagesFromGallery();

      expect(actual, Left(StorageFailure()));
    });
  });

  group('getAudio', () {
    test('should return Right(List<File>) when OK', () async {
      final files = [File('')];
      when(mockMediaLocalDataSource.getAudio()).thenAnswer((_) async => files);

      final actual = await mediaRepository.getAudio();

      expect(actual, Right(files));
    });

    test(
        'should return Left(StorageFailure()) when one thrown from localDataSource',
        () async {
      when(mockMediaLocalDataSource.getAudio()).thenThrow(StorageFailure());

      final actual = await mediaRepository.getAudio();

      expect(actual, Left(StorageFailure()));
    });
  });

  group('getVideo', () {
    test('should return Right(File) when OK', () async {
      final file = File('');
      when(mockMediaLocalDataSource.getVideo()).thenAnswer((_) async => file);

      final actual = await mediaRepository.getVideo();

      expect(actual, Right(file));
    });

    test(
        'should return Left(StorageFailure()) when one thrown from localDataSource',
        () async {
      when(mockMediaLocalDataSource.getVideo()).thenThrow(StorageFailure());

      final actual = await mediaRepository.getVideo();

      expect(actual, Left(StorageFailure()));
    });
  });
}
