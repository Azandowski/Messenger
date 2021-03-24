import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/data/datasources/chat_datasource.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_messages.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  GetMessages getMessages;
  MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
    getMessages = GetMessages(repository: mockChatRepository);
  });

  test(
      'should call ChatRepository and return Either<Failure, ChatMessageResponse>',
      () async {
    when(mockChatRepository.getChatMessages(any, any))
        .thenAnswer((_) async => Right(tChatMessageResponse));
    final tParams =
        GetMessagesParams(direction: RequestDirection.top, lastMessageId: 1);

    final result = await getMessages(tParams);

    expect(result, equals(Right(tChatMessageResponse)));
    verify(mockChatRepository.getChatMessages(
        tParams.lastMessageId, tParams.direction));
    verifyNoMoreInteractions(mockChatRepository);
  });
}
