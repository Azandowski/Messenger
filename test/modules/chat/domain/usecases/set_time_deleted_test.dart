import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/set_time_deleted.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  SetTimeDeleted setTimeDeleted;
  MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
    setTimeDeleted = SetTimeDeleted(repository: mockChatRepository);
  });

  test('should call ChatRepository and return Either<Failure, ChatPermissions>',
      () async {
    when(mockChatRepository.setTimeDeleted(
      id: anyNamed('id'),
      isOn: anyNamed('isOn'),
    )).thenAnswer((_) async => Right(tChatPermissions));
    final tParams = SetTimeDeletedParams(id: 1, isOn: true);

    final result = await setTimeDeleted(tParams);

    expect(result, equals(Right(tChatPermissions)));
    verify(
        mockChatRepository.setTimeDeleted(id: tParams.id, isOn: tParams.isOn));
    verifyNoMoreInteractions(mockChatRepository);
  });
}
