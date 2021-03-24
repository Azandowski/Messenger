import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/add_members.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  AddMembers addMembers;
  MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
    addMembers = AddMembers(repository: mockChatRepository);
  });

  test('should call ChatRepository and return Either<Failure, ChatDetailed>',
      () async {
    when(mockChatRepository.addMembers(any, any))
        .thenAnswer((_) async => Right(tChatDetailed));
    final params = AddMembersToChatParams(id: 1, members: [1]);

    final result = await addMembers(params);

    expect(result, equals(Right(tChatDetailed)));
    verify(mockChatRepository.addMembers(1, [1]));
    verifyNoMoreInteractions(mockChatRepository);
  });
}
