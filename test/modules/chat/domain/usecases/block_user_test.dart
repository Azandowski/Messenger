import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/block_user.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:mockito/mockito.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  BlockUser blockUser;
  MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
    blockUser = BlockUser(repository: mockChatRepository);
  });

  test(
      'should call ChatRepository.blockUser when isBloc is true and return Either<Failure, bool>',
      () async {
    when(mockChatRepository.blockUser(any))
        .thenAnswer((_) async => Right(true));
    final params = BlockUserParams(isBloc: true, userID: 1);

    final result = await blockUser(params);

    expect(result, equals(Right(true)));
    verify(mockChatRepository.blockUser(params.userID));
    verifyNoMoreInteractions(mockChatRepository);
  });

  test(
      'should call ChatRepository.unblockUser when isBloc is false and return Either<Failure, bool>',
      () async {
    when(mockChatRepository.unblockUser(any))
        .thenAnswer((_) async => Right(true));
    final params = BlockUserParams(isBloc: false, userID: 1);

    final result = await blockUser(params);

    expect(result, equals(Right(true)));
    verify(mockChatRepository.unblockUser(params.userID));
    verifyNoMoreInteractions(mockChatRepository);
  });
}
