import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/reply_more.dart';
import 'package:mockito/mockito.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  ReplyMore replyMore;
  MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
    replyMore = ReplyMore(repository: mockChatRepository);
  });

  test('should call ChatRepository and return Either<Failure, bool>', () async {
    when(mockChatRepository.replyMore(any))
        .thenAnswer((_) async => Right(true));
    final tParams = ReplyMoreParams(chatIds: [1, 2], messageIds: [1, 2]);

    final result = await replyMore(tParams);

    expect(result, equals(Right(true)));
    verify(mockChatRepository.replyMore(tParams));
    verifyNoMoreInteractions(mockChatRepository);
  });
}
