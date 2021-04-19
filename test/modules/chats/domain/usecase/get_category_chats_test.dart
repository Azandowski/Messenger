import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/get_category_chats.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/params.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockChatsRepository extends Mock implements ChatsRepository {}

void main() {
  MockChatsRepository mockChatsRepository;
  GetCategoryChats usecase;

  setUp(() {
    mockChatsRepository = MockChatsRepository();
    usecase = GetCategoryChats(mockChatsRepository);
  });

  final params = GetCategoryChatsParams(token: 'token', categoryID: 1);

  test(
    'should call ChatsRepository.getCategoryChats once and return PaginatedResultViaLastItem<ChatEntity>',
    () async {
      when(mockChatsRepository.getCategoryChats(params)).thenAnswer(
        (_) async => Right(tPaginatedResultViaLastChatEntity),
      );

      final actual = await usecase(params);

      expect(actual, equals(Right(tPaginatedResultViaLastChatEntity)));
      verify(mockChatsRepository.getCategoryChats(params)).called(1);
    },
  );
}
