import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_chat_details.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/page/chat_detail_screen.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  GetChatDetails getChatDetails;
  MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
    getChatDetails = GetChatDetails(repository: mockChatRepository);
  });

  test('should call ChatRepository and return Either<Failure, ChatDetailed>',
      () async {
    when(mockChatRepository.getChatDetails(any, any))
        .thenAnswer((_) async => Right(tChatDetailed));
    final tParams = GetChatDetailsParams(mode: ProfileMode.user, id: 1);

    final result = await getChatDetails(tParams);

    expect(result, equals(Right(tChatDetailed)));
    verify(mockChatRepository.getChatDetails(tParams.id, tParams.mode));
    verifyNoMoreInteractions(mockChatRepository);
  });
}
