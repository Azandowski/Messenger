import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/disattachMessage.dart';
import 'package:mockito/mockito.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  DisAttachMessage disAttachMessage;
  MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
    disAttachMessage = DisAttachMessage(repository: mockChatRepository);
  });

  test('should call ChatRepository and return Either<Failure, bool>', () async {
    when(mockChatRepository.disAttachMessage(any))
        .thenAnswer((_) async => Right(true));

    final result = await disAttachMessage(NoParams());

    expect(result, equals(Right(true)));
    verify(mockChatRepository.disAttachMessage(NoParams()));
    verifyNoMoreInteractions(mockChatRepository);
  });
}
