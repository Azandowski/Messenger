import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/get_category_chats.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/get_chats.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/params.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockChatsRepository extends Mock implements ChatsRepository {}

void main() {
  MockChatsRepository mockChatsRepository;
  GetChats usecase;

  setUp(() {
    mockChatsRepository = MockChatsRepository();
    usecase = GetChats(mockChatsRepository);
  });

  final params = GetChatsParams(lastChatID: 1, token: 'token');

  test(
    'should call ChatsRepository.getUserChats once and return PaginatedResultViaLastItem<ChatEntity>',
    () async {
      when(mockChatsRepository.getUserChats(params)).thenAnswer(
        (_) async => Right(tPaginatedResultViaLastChatEntity),
      );

      final actual = await usecase(params);

      expect(actual, equals(Right(tPaginatedResultViaLastChatEntity)));
      verify(mockChatsRepository.getUserChats(params)).called(1);
    },
  );
}
