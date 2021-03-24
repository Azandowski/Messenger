import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/send_message.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  SendMessage sendMessage;
  MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
    sendMessage = SendMessage(repository: mockChatRepository);
  });

  test('should call ChatRepository and return Either<Failure, Message>',
      () async {
    when(mockChatRepository.sendMessage(any))
        .thenAnswer((_) async => Right(tMessageModel));
    final tParams = SendMessageParams(identificator: 1, chatID: 1);

    final result = await sendMessage(tParams);

    expect(result, equals(Right(tMessageModel)));
    verify(mockChatRepository.sendMessage(tParams));
    verifyNoMoreInteractions(mockChatRepository);
  });
}
