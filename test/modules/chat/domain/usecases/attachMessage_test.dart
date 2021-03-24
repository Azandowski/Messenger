import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/attachMessage.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  AttachMessage attachMessage;
  MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
    attachMessage = AttachMessage(repository: mockChatRepository);
  });

  test('should call ChatRepository and return Either<Failure, bool>', () async {
    when(mockChatRepository.attachMessage(any))
        .thenAnswer((_) async => Right(true));

    final result = await attachMessage(tMessageModel);

    expect(result, equals(Right(true)));
    verify(mockChatRepository.attachMessage(tMessageModel));
    verifyNoMoreInteractions(mockChatRepository);
  });
}
