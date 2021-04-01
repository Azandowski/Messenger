import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_messages.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_messages_context.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/send_message.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/set_time_deleted.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../../../variables.dart';

class MockChatsRepository extends Mock implements ChatsRepository {}

class MockChatRepository extends Mock implements ChatRepository {}

class MockSendMessage extends Mock implements SendMessage {}

class MockGetMessages extends Mock implements GetMessages {}

class MockGetMessagesContext extends Mock implements GetMessagesContext {}

class MockSetTimeDeleted extends Mock implements SetTimeDeleted {}

void main() {
  MockChatsRepository mockChatsRepository;
  MockChatRepository mockChatRepository;
  MockSendMessage mockSendMessage;
  MockGetMessages mockGetMessages;
  MockGetMessagesContext mockGetMessagesContext;
  MockSetTimeDeleted mockSetTimeDeleted;
  ChatBloc chatBloc;

  setUp(() {
    mockChatsRepository = MockChatsRepository();
    mockChatRepository = MockChatRepository();
    mockSendMessage = MockSendMessage();
    mockGetMessages = MockGetMessages();
    mockGetMessagesContext = MockGetMessagesContext();
    mockSetTimeDeleted = MockSetTimeDeleted();
    chatBloc = ChatBloc(
      chatId: 1,
      chatRepository: mockChatRepository,
      chatsRepository: mockChatsRepository,
      sendMessage: mockSendMessage,
      getMessages: mockGetMessages,
      setTimeDeleted: mockSetTimeDeleted,
      getMessagesContext: mockGetMessagesContext,
    );
  });

  blocTest(
    'sould',
    build: () => chatBloc,
    act: (ChatBloc chatBloc) {
      when(mockSendMessage(any)).thenAnswer((_) async => Right(tMessage));

      when(mockChatRepository.message)
          .thenReturn(Stream<Message>.fromIterable([tMessageModel]));
      chatBloc.add(ChatScreenStarted());
    },
    expect: () => [],
  );
}
