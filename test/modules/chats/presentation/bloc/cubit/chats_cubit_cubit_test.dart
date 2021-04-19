import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chats/data/repositories/chats_repository_impl.dart';
import 'package:messenger_mobile/modules/chats/presentation/bloc/cubit/chats_cubit_cubit.dart';
import 'package:mockito/mockito.dart';

class MockChatsRepository extends Mock implements ChatsRepositoryImpl {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MockChatsRepository mockChatsRepository;
  ChatsCubit chatsCubit;

  setUp(() {
    mockChatsRepository = MockChatsRepository();
    when(mockChatsRepository.getLocalWallpaper())
        .thenAnswer((_) async => File('path'));
    chatsCubit = ChatsCubit(mockChatsRepository);
  });

  blocTest(
    'tabUpdate should emit ChatsCubitStateNormal with given current index',
    build: () => chatsCubit,
    act: (ChatsCubit chatsCubit) {
      chatsCubit.tabUpdate(2);
    },
    expect: () => [
      ChatsCubitStateNormal(
        currentTabIndex: 2,
      )
    ],
  );

  blocTest(
    'didSelectChat should emit ChatsCubitSelectedOne with given selectedChatIndex',
    build: () => chatsCubit,
    act: (ChatsCubit chatsCubit) {
      chatsCubit.didSelectChat(1);
    },
    expect: () => [
      ChatsCubitSelectedOne(
        currentTabIndex: 0,
        selectedChatIndex: 1,
      )
    ],
  );

  blocTest(
    'didCancelChatSelection should emit ChatsCubitSelectedOne with given selectedChatIndex, then ChatsCubitStateNormal without selectedChatIndex',
    build: () => chatsCubit,
    act: (ChatsCubit chatsCubit) {
      chatsCubit.didSelectChat(1);
      chatsCubit.didCancelChatSelection();
    },
    expect: () => [
      ChatsCubitSelectedOne(
        currentTabIndex: 0,
        selectedChatIndex: 1,
      ),
      ChatsCubitStateNormal(
        currentTabIndex: 0,
      )
    ],
  );
}
