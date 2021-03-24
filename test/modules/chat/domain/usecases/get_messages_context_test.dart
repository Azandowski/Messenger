import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_messages_context.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  GetMessagesContext getMessagesContext;
  MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
    getMessagesContext = GetMessagesContext(repository: mockChatRepository);
  });

  test(
      'should call ChatRepository and return Either<Failure, ChatMessageResponse>',
      () async {
    when(mockChatRepository.getChatMessageContext(any, any))
        .thenAnswer((_) async => Right(tChatMessageResponse));
    final tParams = GetMessagesContextParams(chatID: 1, messageID: 2);

    final result = await getMessagesContext(tParams);

    expect(result, equals(Right(tChatMessageResponse)));
    verify(mockChatRepository.getChatMessageContext(
        tParams.chatID, tParams.messageID));
    verifyNoMoreInteractions(mockChatRepository);
  });
}
