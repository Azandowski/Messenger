import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_messages.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_messages_context.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/send_message.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/set_time_deleted.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../../../variables.dart';

class MockChatsRepository extends Mock implements ChatsRepository {}

class MockChatRepository extends Mock implements ChatRepository {}

class MockSendMessage extends Mock implements SendMessage {}

class MockGetMessages extends Mock implements GetMessages {}

class MockGetMessagesContext extends Mock implements GetMessagesContext {}

class MockSetTimeDeleted extends Mock implements SetTimeDeleted {}

class MockAutoScrollController extends Mock implements AutoScrollController {}

void main() {
  MockChatsRepository mockChatsRepository;
  MockChatRepository mockChatRepository;
  MockSendMessage mockSendMessage;
  MockGetMessages mockGetMessages;
  MockGetMessagesContext mockGetMessagesContext;
  MockSetTimeDeleted mockSetTimeDeleted;
  MockAutoScrollController mockAutoScrollController;
  ChatBloc chatBloc;

  setUp(() {
    mockChatsRepository = MockChatsRepository();
    mockChatRepository = MockChatRepository();
    mockSendMessage = MockSendMessage();
    mockGetMessages = MockGetMessages();
    mockGetMessagesContext = MockGetMessagesContext();
    mockSetTimeDeleted = MockSetTimeDeleted();
    mockAutoScrollController = MockAutoScrollController();

    when(mockChatRepository.message).thenAnswer((_) {
      return Stream.fromIterable([tMessage]);
    });
    when(mockChatRepository.deleteIds).thenAnswer(
      (_) => Stream.fromIterable([
        [tMessage.id]
      ]),
    );

    final scrollCon = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, 20.0),
      axis: Axis.vertical,
    );

    when(mockAutoScrollController.position).thenReturn(scrollCon.position);

    chatBloc = ChatBloc(
      chatId: 1,
      chatRepository: mockChatRepository,
      chatsRepository: mockChatsRepository,
      sendMessage: mockSendMessage,
      getMessages: mockGetMessages,
      setTimeDeleted: mockSetTimeDeleted,
      getMessagesContext: mockGetMessagesContext,
      // scrollController: mockAutoScrollController,
    );
  });

  blocTest(
    'sould',
    build: () => chatBloc,
    act: (ChatBloc chatBloc) {
      when(mockChatsRepository.getLocalWallpaper())
          .thenAnswer((_) async => File('path'));

      when(mockChatRepository.message)
          .thenAnswer((_) => Stream.fromIterable([tMessage]));

      chatBloc.add(ChatScreenStarted());
    },
    expect: () => [isA<ChatInitial>()],
  );
}
