import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/kick_member.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  KickMembers kickMembers;
  MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
    kickMembers = KickMembers(repository: mockChatRepository);
  });

  test('should call ChatRepository and return Either<Failure, ChatDetailed>',
      () async {
    when(mockChatRepository.kickMember(any, any))
        .thenAnswer((_) async => Right(tChatDetailed));
    final tParams = KickMemberParams(id: 1, userID: 1);

    final result = await kickMembers(tParams);

    expect(result, equals(Right(tChatDetailed)));
    verify(mockChatRepository.kickMember(tParams.id, tParams.userID));
    verifyNoMoreInteractions(mockChatRepository);
  });
}
