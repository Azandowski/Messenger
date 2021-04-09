import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/set_wallpaper.dart';
import 'package:mockito/mockito.dart';

class MockChatsRepository extends Mock implements ChatsRepository {}

void main() {
  MockChatsRepository mockChatsRepository;
  SetWallpaper usecase;

  setUp(() {
    mockChatsRepository = MockChatsRepository();
    usecase = SetWallpaper(mockChatsRepository);
  });

  test(
    'should call repository.setLocalWallpaper and return NoParams',
    () async {
      when(mockChatsRepository.setLocalWallpaper(any))
          .thenAnswer((_) async => Future.value());

      final file = File('');
      final actual = await usecase(file);
      expect(actual, Right(NoParams()));
      verify(mockChatsRepository.setLocalWallpaper(file));
      verifyNoMoreInteractions(mockChatsRepository);
    },
  );
}
