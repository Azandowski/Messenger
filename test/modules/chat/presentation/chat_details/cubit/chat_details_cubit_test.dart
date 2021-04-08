import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_permission_model.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/add_members.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/block_user.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_chat_details.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/kick_member.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/leave_chat.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/set_social_media.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/update_chat_settings.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/cubit/chat_details_cubit.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/page/chat_detail_screen.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/widgets/chat_setting_item.dart';
import 'package:mockito/mockito.dart';

import '../../../../../variables.dart';

class MockGetChatDetails extends Mock implements GetChatDetails {}

class MockAddMembers extends Mock implements AddMembers {}

class MockLeaveChat extends Mock implements LeaveChat {}

class MockUpdateChatSettings extends Mock implements UpdateChatSettings {}

class MockKickMembers extends Mock implements KickMembers {}

class MockBlockUser extends Mock implements BlockUser {}

class MockSetSocialMedia extends Mock implements SetSocialMedia {}

void main() {
  MockGetChatDetails mockGetChatDetails;
  MockAddMembers mockAddMembers;
  MockLeaveChat mockLeaveChat;
  MockUpdateChatSettings mockUpdateChatSettings;
  MockKickMembers mockKickMembers;
  MockBlockUser mockBlockUser;
  MockSetSocialMedia mockSetSocialMedia;
  ChatDetailsCubit chatDetailsCubit;

  setUp(() {
    mockGetChatDetails = MockGetChatDetails();
    mockAddMembers = MockAddMembers();
    mockLeaveChat = MockLeaveChat();
    mockUpdateChatSettings = MockUpdateChatSettings();
    mockKickMembers = MockKickMembers();
    mockBlockUser = MockBlockUser();
    mockSetSocialMedia = MockSetSocialMedia();
    chatDetailsCubit = ChatDetailsCubit(
      getChatDetails: mockGetChatDetails,
      addMembers: mockAddMembers,
      leaveChat: mockLeaveChat,
      updateChatSettings: mockUpdateChatSettings,
      kickMembers: mockKickMembers,
      blockUser: mockBlockUser,
      setSocialMedia: mockSetSocialMedia,
    );
  });

  void setState() {
    chatDetailsCubit
        .setState(ChatDetailsLoaded(chatDetailed: tChatDetailedModel));
  }

  group('loadDetails', () {
    blocTest(
      'should emit [ChatDetailsLoaded] when data received from usecase',
      build: () => chatDetailsCubit,
      act: (ChatDetailsCubit chatDetailsCubit) {
        when(mockGetChatDetails(any))
            .thenAnswer((_) async => Right(tChatDetailedModel));
        chatDetailsCubit.loadDetails(1, ProfileMode.user);
      },
      expect: () => [
        ChatDetailsLoaded(chatDetailed: tChatDetailedModel),
      ],
    );
    blocTest(
      'should emit [ChatDetailsError] when failure received from usecase',
      build: () => chatDetailsCubit,
      act: (ChatDetailsCubit chatDetailsCubit) {
        when(mockGetChatDetails(any))
            .thenAnswer((_) async => Left(ServerFailure(message: 'message')));
        chatDetailsCubit.loadDetails(1, ProfileMode.user);
      },
      expect: () => [
        ChatDetailsError(message: 'message', chatDetailed: null),
      ],
    );
  });

  group('doLeaveChat', () {
    blocTest(
      'should emit [ChatDetailsProccessing, ChatDetailsLeave] when data received from usecase',
      build: () => chatDetailsCubit,
      act: (ChatDetailsCubit chatDetailsCubit) {
        when(mockLeaveChat(any)).thenAnswer((_) async => Right(NoParams()));
        chatDetailsCubit.doLeaveChat(1);
      },
      expect: () => [
        ChatDetailsProccessing(chatDetailed: null),
        ChatDetailsLeave(chatDetailed: null),
      ],
    );
    blocTest(
      'should emit [ChatDetailsProccessing, ChatDetailsError] when failure received from usecase',
      build: () => chatDetailsCubit,
      act: (ChatDetailsCubit chatDetailsCubit) {
        when(mockLeaveChat(any))
            .thenAnswer((_) async => Left(ServerFailure(message: 'message')));
        chatDetailsCubit.doLeaveChat(1);
      },
      expect: () => [
        ChatDetailsProccessing(chatDetailed: null),
        ChatDetailsError(message: 'message', chatDetailed: null),
      ],
    );
  });

  group('kickMember', () {
    blocTest(
      'should emit [ChatDetailsProccessing, ChatDetailsLoaded] when data received from usecase',
      build: () => chatDetailsCubit,
      act: (ChatDetailsCubit chatDetailsCubit) {
        when(mockKickMembers(any))
            .thenAnswer((_) async => Right(tChatDetailedModel));
        chatDetailsCubit.kickMember(1, 1);
      },
      expect: () => [
        ChatDetailsProccessing(chatDetailed: null),
        ChatDetailsLoaded(chatDetailed: tChatDetailedModel),
      ],
    );
    blocTest(
      'should emit [ChatDetailsProccessing, ChatDetailsError] when failure received from usecase',
      build: () => chatDetailsCubit,
      act: (ChatDetailsCubit chatDetailsCubit) {
        when(mockKickMembers(any))
            .thenAnswer((_) async => Left(ServerFailure(message: 'message')));
        chatDetailsCubit.kickMember(1, 1);
      },
      expect: () => [
        ChatDetailsProccessing(chatDetailed: null),
        ChatDetailsError(message: 'message', chatDetailed: null),
      ],
    );
  });

  group('addMembersToChat', () {
    blocTest(
      'should emit [ChatDetailsProccessing, ChatDetailsLoaded] when data received from usecase',
      build: () => chatDetailsCubit,
      act: (ChatDetailsCubit chatDetailsCubit) {
        when(mockAddMembers(any))
            .thenAnswer((_) async => Right(tChatDetailedModel));
        chatDetailsCubit.addMembersToChat(1, [tContactModel, tContactModel2]);
      },
      expect: () => [
        ChatDetailsProccessing(chatDetailed: null),
        ChatDetailsLoaded(chatDetailed: tChatDetailedModel),
      ],
    );
    blocTest(
      'should emit [ChatDetailsProccessing, ChatDetailsError] when failure received from usecase',
      build: () => chatDetailsCubit,
      act: (ChatDetailsCubit chatDetailsCubit) {
        when(mockAddMembers(any))
            .thenAnswer((_) async => Left(ServerFailure(message: 'message')));
        chatDetailsCubit.addMembersToChat(1, [tContactModel, tContactModel2]);
      },
      expect: () => [
        ChatDetailsProccessing(chatDetailed: null),
        ChatDetailsError(message: 'message', chatDetailed: null),
      ],
    );
  });

  group('toggleChatSetting', () {
    setUp(() {
      setState();
    });

    blocTest(
      'noSound: should emit [ChatDetailsLoaded] when settings changed',
      build: () => chatDetailsCubit,
      act: (ChatDetailsCubit chatDetailsCubit) {
        chatDetailsCubit.toggleChatSetting(
          settings: ChatSettings.noSound,
          newValue: false,
          id: 1,
          callback: (_) {},
        );
      },
      expect: () => [
        ChatDetailsLoaded(
          chatDetailed: tChatDetailedModel.copyWith(
            settings: tChatDetailedModel.settings.copyWith(isSoundOn: true),
          ),
        ),
      ],
    );

    blocTest(
      'noMedia: should emit [ChatDetailsLoaded] when settings changed',
      build: () => chatDetailsCubit,
      act: (ChatDetailsCubit chatDetailsCubit) {
        chatDetailsCubit.toggleChatSetting(
          settings: ChatSettings.noMedia,
          newValue: false,
          id: 1,
          callback: (_) {},
        );
      },
      expect: () => [
        ChatDetailsLoaded(
          chatDetailed: tChatDetailedModel.copyWith(
            settings: tChatDetailedModel.settings.copyWith(isMediaSendOn: true),
          ),
        ),
      ],
    );

    blocTest(
      'adminSendMessage: should emit [ChatDetailsLoaded] when settings changed',
      build: () => chatDetailsCubit,
      act: (ChatDetailsCubit chatDetailsCubit) {
        chatDetailsCubit.toggleChatSetting(
          settings: ChatSettings.adminSendMessage,
          newValue: false,
          id: 1,
          callback: (_) {},
        );
      },
      expect: () => [
        ChatDetailsLoaded(
          chatDetailed: tChatDetailedModel.copyWith(
            settings:
                tChatDetailedModel.settings.copyWith(adminMessageSend: false),
          ),
        ),
      ],
    );

    blocTest(
      'forwardMessages: should emit [ChatDetailsLoaded] when settings changed',
      build: () => chatDetailsCubit,
      act: (ChatDetailsCubit chatDetailsCubit) {
        chatDetailsCubit.toggleChatSetting(
          settings: ChatSettings.forwardMessages,
          newValue: false,
          id: 1,
          callback: (_) {},
        );
      },
      expect: () => [
        ChatDetailsLoaded(
          chatDetailed: tChatDetailedModel.copyWith(
            settings: tChatDetailedModel.settings.copyWith(isForwardOn: false),
          ),
        ),
      ],
    );
  });

  group('onFinish', () {
    setUp(() {
      setState();
    });

    test('should call usecase white ChatPermissionModel', () {
      final ChatPermissionModel newChatPermissionModel = ChatPermissionModel(
        adminMessageSend: false,
        isForwardOn: false,
        isMediaSendOn: true,
        isSoundOn: false,
      );

      when(mockUpdateChatSettings(any))
          .thenAnswer((_) async => Right(newChatPermissionModel));
      chatDetailsCubit.onFinish(id: 1, callback: (res) => res);
      verify(mockUpdateChatSettings(any));
    });

    blocTest(
      'should emit [ChatDetailsError] when failure received from usecase',
      build: () => chatDetailsCubit,
      act: (ChatDetailsCubit chatDetailsCubit) {
        when(mockUpdateChatSettings(any))
            .thenAnswer((_) async => Left(ServerFailure(message: 'message')));
        chatDetailsCubit.onFinish(id: 1, callback: (_) {});
      },
      expect: () => [
        ChatDetailsError(message: 'message', chatDetailed: tChatDetailedModel),
      ],
    );
  });

  group('blockUnblockUser', () {
    setUp(() {
      setState();
    });
    blocTest(
      'should emit [ChatDetailsProccessing, ChatDetailsLoaded] when data received from usecase',
      build: () => chatDetailsCubit,
      act: (ChatDetailsCubit chatDetailsCubit) {
        when(mockBlockUser(any)).thenAnswer((_) async => Right(true));
        chatDetailsCubit.blockUnblockUser(userID: 1, isBlock: true);
      },
      expect: () => [
        ChatDetailsProccessing(chatDetailed: tChatDetailedModel),
        ChatDetailsLoaded(
          chatDetailed: tChatDetailedModel.copyWith(
            user: tChatDetailedModel.user.copyWith(isBlocked: true),
          ),
        ),
      ],
    );

    blocTest(
      'should emit [ChatDetailsProccessing, ChatDetailsError] when failure received from usecase',
      build: () => chatDetailsCubit,
      act: (ChatDetailsCubit chatDetailsCubit) {
        when(mockBlockUser(any))
            .thenAnswer((_) async => Left(ServerFailure(message: 'message')));
        chatDetailsCubit.blockUnblockUser(userID: 1, isBlock: true);
      },
      expect: () => [
        ChatDetailsProccessing(chatDetailed: tChatDetailedModel),
        ChatDetailsError(message: 'message', chatDetailed: tChatDetailedModel),
      ],
    );
  });

  group('setNewSocialMedia', () {
    setUp(() {
      setState();
    });
    blocTest(
      'should emit [ChatDetailsProccessing, ChatDetailsLoaded] when data received from usecase',
      build: () => chatDetailsCubit,
      act: (ChatDetailsCubit chatDetailsCubit) {
        when(mockSetSocialMedia(any))
            .thenAnswer((_) async => Right(tChatPermissions));
        chatDetailsCubit.setNewSocialMedia(id: 1, newSocialMedia: tSocialMedia);
      },
      expect: () => [
        ChatDetailsProccessing(chatDetailed: tChatDetailedModel),
        ChatDetailsLoaded(
          chatDetailed: tChatDetailedModel.copyWith(socialMedia: tSocialMedia),
        ),
      ],
    );

    blocTest(
      'should emit [ChatDetailsProccessing, ChatDetailsError] when failure received from usecase',
      build: () => chatDetailsCubit,
      act: (ChatDetailsCubit chatDetailsCubit) {
        when(mockSetSocialMedia(any))
            .thenAnswer((_) async => Left(ServerFailure(message: 'message')));
        chatDetailsCubit.setNewSocialMedia(id: 1, newSocialMedia: tSocialMedia);
      },
      expect: () => [
        ChatDetailsProccessing(chatDetailed: tChatDetailedModel),
        ChatDetailsError(message: 'message', chatDetailed: tChatDetailedModel),
      ],
    );
  });

  blocTest(
    'showError: should emit [ChatDetailsError]',
    build: () => chatDetailsCubit,
    act: (ChatDetailsCubit chatDetailsCubit) {
      chatDetailsCubit.showError('message');
    },
    expect: () => [
      ChatDetailsError(message: 'message', chatDetailed: null),
    ],
  );
}
