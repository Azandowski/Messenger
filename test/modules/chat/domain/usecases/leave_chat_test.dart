import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/leave_chat.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  LeaveChat leaveChat;
  MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
    leaveChat = LeaveChat(repository: mockChatRepository);
  });

  test('should call ChatRepository and return Either<Failure, NoParams>',
      () async {
    when(mockChatRepository.leaveChat(any))
        .thenAnswer((_) async => Right(tNoParams));

    final result = await leaveChat(1);

    expect(result, equals(Right(tNoParams)));
    verify(mockChatRepository.leaveChat(1));
    verifyNoMoreInteractions(mockChatRepository);
  });
}
