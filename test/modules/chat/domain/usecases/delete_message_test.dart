import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/attachMessage.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/delete_message.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  DeleteMessage deleteMessage;
  MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
    deleteMessage = DeleteMessage(repository: mockChatRepository);
  });

  test('should call ChatRepository and return Either<Failure, bool>', () async {
    when(mockChatRepository.deleteMessage(any))
        .thenAnswer((_) async => Right(true));
    final tParams = DeleteMessageParams(ids: '1', forMe: 1, chatID: 2);

    final result = await deleteMessage(tParams);

    expect(result, equals(Right(true)));
    verify(mockChatRepository.deleteMessage(tParams));
    verifyNoMoreInteractions(mockChatRepository);
  });
}
