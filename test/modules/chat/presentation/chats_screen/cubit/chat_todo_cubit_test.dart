import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/attachMessage.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/delete_message.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/disattachMessage.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/reply_more.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/cubit/chat_todo_cubit.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:mockito/mockito.dart';

import '../../../../../variables.dart';

class MockDeleteMessage extends Mock implements DeleteMessage {}

class MockAttachMessage extends Mock implements AttachMessage {}

class MockDisAttachMessage extends Mock implements DisAttachMessage {}

class MockReplyMore extends Mock implements ReplyMore {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  ChatTodoCubit chatTodoCubit;
  MockDeleteMessage mockDeleteMessage;
  MockAttachMessage mockAttachMessage;
  MockDisAttachMessage mockDisAttachMessage;
  MockReplyMore mockReplyMore;
  MockBuildContext mockBuildContext;

  setUp(() {
    mockDeleteMessage = MockDeleteMessage();
    mockAttachMessage = MockAttachMessage();
    mockDisAttachMessage = MockDisAttachMessage();
    mockReplyMore = MockReplyMore();
    mockBuildContext = MockBuildContext();

    chatTodoCubit = ChatTodoCubit(
      deleteMessageUseCase: mockDeleteMessage,
      disAttachMessageUseCase: mockDisAttachMessage,
      attachMessageUseCase: mockAttachMessage,
      replyMoreUseCase: mockReplyMore,
      context: mockBuildContext,
    );

    chatTodoCubit.setState(tMessageModel);
  });

  blocTest(
    'selectMessage: should emit ChatTodoSelection with new Message added to list',
    build: () => chatTodoCubit,
    act: (ChatTodoCubit chatTodoCubit) {
      chatTodoCubit.selectMessage(tMessageModel);
    },
    expect: () => [
      ChatTodoSelection(
        isDelete: false,
        selectedMessages: [
          tMessageModel.copyWith(),
          tMessageModel.copyWith(
            id: 5,
            colorId: 5,
          ),
          tMessageModel,
        ],
      ),
    ],
  );

  blocTest(
    'removeMessage: should emit ChatTodoSelection with new Message removed from list',
    build: () => chatTodoCubit,
    act: (ChatTodoCubit chatTodoCubit) {
      chatTodoCubit.removeMessage(tMessageModel);
    },
    expect: () => [
      ChatTodoSelection(
        isDelete: false,
        selectedMessages: [
          tMessageModel.copyWith(
            id: 5,
            colorId: 5,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'enableSelectionMode: should emit ChatTodoSelection with new params',
    build: () => chatTodoCubit,
    act: (ChatTodoCubit chatTodoCubit) {
      chatTodoCubit.enableSelectionMode(tMessage, true);
    },
    expect: () => [
      ChatTodoSelection(
        isDelete: true,
        selectedMessages: [tMessage],
      ),
    ],
  );

  blocTest(
    'disableSelectionMode: should emit ChatToDoDisabled',
    build: () => chatTodoCubit,
    act: (ChatTodoCubit chatTodoCubit) {
      chatTodoCubit.disableSelectionMode();
    },
    expect: () => [
      ChatToDoDisabled(),
    ],
  );

  blocTest(
    'deleteMessage: should emit [ChatToDoLoading, ChatToDoDisabled] when delettion is successful',
    build: () => chatTodoCubit,
    act: (ChatTodoCubit chatTodoCubit) {
      when(mockDeleteMessage(any)).thenAnswer((_) async => Right(true));
      chatTodoCubit.deleteMessage(chatID: 1, forMe: true);
    },
    expect: () => [
      ChatToDoLoading(
        selectedMessages: [
          tMessageModel,
          tMessageModel.copyWith(
            id: 5,
            colorId: 5,
          ),
        ],
        isDelete: true,
      ),
      ChatToDoDisabled(),
    ],
  );

  blocTest(
    'deleteMessage: should emit [ChatToDoLoading, ChatToDoError] when delettion is unsuccessful',
    build: () => chatTodoCubit,
    act: (ChatTodoCubit chatTodoCubit) {
      when(mockDeleteMessage(any))
          .thenAnswer((_) async => Left(ServerFailure(message: 'message')));
      chatTodoCubit.deleteMessage(chatID: 1, forMe: true);
    },
    expect: () => [
      ChatToDoLoading(
        selectedMessages: [
          tMessageModel,
          tMessageModel.copyWith(
            id: 5,
            colorId: 5,
          ),
        ],
        isDelete: true,
      ),
      ChatToDoError(errorMessage: 'message'),
    ],
  );

  // This is not testable
  // blocTest(
  //   'replyMessageToMore: should emit [ChatToDoLoading, ChatToDoDisabled] when reply is successful',
  //   build: () => chatTodoCubit,
  //   act: (ChatTodoCubit chatTodoCubit) {
  //     when(mockReplyMore(any)).thenAnswer((_) async => Right(true));
  //     chatTodoCubit.replyMessageToMore(chatIds: [tChatEntityModel]);
  //   },
  //   expect: () => [
  //     ChatToDoLoading(
  //       selectedMessages: [
  //         tMessageModel,
  //         tMessageModel.copyWith(
  //           id: 5,
  //           colorId: 5,
  //         ),
  //       ],
  //       isDelete: true,
  //     ),
  //     ChatToDoDisabled(),
  //   ],
  // );

  blocTest(
    'replyMessageToMore: should emit [ChatToDoLoading, ChatToDoError] when reply is successful',
    build: () => chatTodoCubit,
    act: (ChatTodoCubit chatTodoCubit) {
      when(mockReplyMore(any))
          .thenAnswer((_) async => Left(ServerFailure(message: 'message')));
      chatTodoCubit.replyMessageToMore(chatIds: [tChatEntityModel]);
    },
    expect: () => [
      ChatToDoLoading(
        selectedMessages: [
          tMessageModel,
          tMessageModel.copyWith(
            id: 5,
            colorId: 5,
          ),
        ],
        isDelete: false,
      ),
      ChatToDoError(errorMessage: 'message'),
    ],
  );

  test('attachMessage: should call attachMessage usecase', () {
    chatTodoCubit.attachMessage(tMessage);
    verify(mockAttachMessage(tMessage));
  });

  test('disAttachMessage: should call disAttachMessage usecase', () {
    chatTodoCubit.disattachMessage();
    verify(mockDisAttachMessage(NoParams()));
  });
}
