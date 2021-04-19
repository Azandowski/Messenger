import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/params.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/search_chats.dart';
import 'package:mockito/mockito.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/chat_search_response.dart';

import '../../../../variables.dart';

class MockChatsRepository extends Mock implements ChatsRepository {}

void main() {
  MockChatsRepository mockChatsRepository;
  SearchChats usecase;

  setUp(() {
    mockChatsRepository = MockChatsRepository();
    usecase = SearchChats(mockChatsRepository);
  });

  final params = SearchChatParams(
      nextPageURL: Uri(query: 'nextPageURL'), queryText: 'queryText');

  test(
    'should call ChatsRepository.getUserChats once and return ChatMessageResponse',
    () async {
      // when(mockChatsRepository.searchChats(
      //   nextPageURL: params.nextPageURL,
      //   queryText: params.queryText,
      // )).thenAnswer(
      //   (_) async => Right(tChatMessageResponse),
      // );

      final actual = await usecase(params);

      expect(actual, equals(Right(tPaginatedResultViaLastChatEntity)));
      verify(mockChatsRepository.searchChats(
        nextPageURL: params.nextPageURL,
        queryText: params.queryText,
      )).called(1);
    },
  );
}
