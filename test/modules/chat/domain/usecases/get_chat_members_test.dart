import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_chat_members.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  GetChatMembers getChatMembers;
  MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
    getChatMembers = GetChatMembers(repository: mockChatRepository);
  });

  test(
      'should call ChatRepository and return Either<Failure, PaginatedResult<ContactEntity>>',
      () async {
    when(mockChatRepository.getChatMembers(any, any))
        .thenAnswer((_) async => Right(tPaginatedResultContactEntity));
    final tParams = GetChatMembersParams(id: 1, pagination: tPagination);

    final result = await getChatMembers(tParams);

    expect(result, equals(Right(tPaginatedResultContactEntity)));
    verify(mockChatRepository.getChatMembers(tParams.id, tParams.pagination));
    verifyNoMoreInteractions(mockChatRepository);
  });
}
