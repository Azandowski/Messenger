import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/media/data/datasources/local_media_datasource.dart';
import 'package:mockito/mockito.dart';

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  MockImagePicker mockImagePicker;
  MediaLocalDataSourceImpl localDataSource;

  setUp(() {
    mockImagePicker = MockImagePicker();
    localDataSource = MediaLocalDataSourceImpl(
      imagePicker: mockImagePicker,
    );
  });

  test('getImage should return File with path of selected image', () async {
    final pickedFile = PickedFile('path');

    when(mockImagePicker.getImage(
      source: anyNamed('source'),
      imageQuality: anyNamed('imageQuality'),
    )).thenAnswer((_) async => pickedFile);

    final actual = await localDataSource.getImage(ImageSource.camera);

    expect(actual, isA<File>());
    expect(actual.path, equals('path'));
  });
}
