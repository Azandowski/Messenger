import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/update_chat_settings.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  UpdateChatSettings updateChatSettings;
  MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
    updateChatSettings = UpdateChatSettings(repository: mockChatRepository);
  });

  test('should call ChatRepository and return Either<Failure, ChatPermissions>',
      () async {
    when(mockChatRepository.updateChatSettings(
      id: anyNamed('id'),
      permissions: anyNamed('permissions'),
    )).thenAnswer((_) async => Right(tChatPermissions));
    final tParams =
        UpdateChatSettingsParams(id: 1, permissionModel: tChatPermissionModel);

    final result = await updateChatSettings(tParams);

    expect(result, equals(Right(tChatPermissions)));
    verify(mockChatRepository.updateChatSettings(
      id: tParams.id,
      permissions: tParams.permissionModel,
    ));
    verifyNoMoreInteractions(mockChatRepository);
  });
}
