import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';
import 'package:messenger_mobile/modules/chat/data/datasources/chat_datasource.dart';
import 'package:messenger_mobile/modules/chat/data/models/chat_message_response.dart';
import 'package:messenger_mobile/modules/chat/data/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/page/chat_detail_screen.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockChatDataSource extends Mock implements ChatDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  ChatRepositoryImpl chatRepository;
  MockNetworkInfo mockNetworkInfo;
  MockChatDataSource mockChatDataSource;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockChatDataSource = MockChatDataSource();
    chatRepository = ChatRepositoryImpl(
      chatDataSource: mockChatDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getChatDetails', () {
    test('should check network connection', () {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));

      chatRepository.getChatDetails(1, ProfileMode.user);

      verify(mockNetworkInfo.isConnected);
    });

    test('should return Left(ConnectionFailure()) when no internet connection',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final actual = await chatRepository.getChatDetails(1, ProfileMode.user);

      expect(actual, equals(Left(ConnectionFailure())));
      verifyZeroInteractions(mockChatDataSource);
    });

    test(
        'should return Left(ServerFailure()) when ServerFailure thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.getChatDetails(any, any))
          .thenThrow(ServerFailure(message: 'message'));

      final actual = await chatRepository.getChatDetails(1, ProfileMode.user);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Left(ServerFailure()) when any error thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.getChatDetails(any, any)).thenThrow(Exception());

      final actual = await chatRepository.getChatDetails(1, ProfileMode.user);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return Right(ChatDetailed) when everything is OK', () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.getChatDetails(any, any))
          .thenAnswer((_) async => tChatDetailedModel);

      final actual = await chatRepository.getChatDetails(1, ProfileMode.user);

      expect(actual, equals(Right(tChatDetailedModel)));
    });
  });

  group('getChatMembers', () {
    test('should check network connection', () {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));

      chatRepository.getChatMembers(1, Pagination());

      verify(mockNetworkInfo.isConnected);
    });

    test('should return Left(ConnectionFailure()) when no internet connection',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final actual = await chatRepository.getChatMembers(1, Pagination());

      expect(actual, equals(Left(ConnectionFailure())));
      verifyZeroInteractions(mockChatDataSource);
    });

    test(
        'should return Left(ServerFailure()) when ServerFailure thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.getChatMembers(any, any))
          .thenThrow(ServerFailure(message: 'message'));

      final actual = await chatRepository.getChatMembers(1, Pagination());

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Left(ServerFailure()) when any error thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.getChatMembers(any, any)).thenThrow(Exception());

      final actual = await chatRepository.getChatMembers(1, Pagination());

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Right(PaginatedResult<ContactEntity>) when everything is OK',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.getChatMembers(any, any))
          .thenAnswer((_) async => tPaginatedResultContactEntity);

      final actual = await chatRepository.getChatMembers(1, Pagination());

      expect(actual, equals(Right(tPaginatedResultContactEntity)));
    });
  });

  group('sendMessage', () {
    final params = SendMessageParams(identificator: 1, chatID: 1);

    // test('should check network connection', () {
    //   when(mockNetworkInfo.isConnected).thenAnswer((_) async => Future.value(true));

    //   chatRepository.sendMessage(params);

    //   verify(mockNetworkInfo.isConnected);
    // });

    // test('should return Left(ConnectionFailure()) when no internet connection',
    //     () async {
    //   when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

    //   final actual = await chatRepository.sendMessage(params);

    //   expect(actual, equals(Left(ConnectionFailure())));
    //   verifyZeroInteractions(mockChatDataSource);
    // });

    test(
        'should return Left(ServerFailure()) when ServerFailure thrown from datasource',
        () async {
      when(mockChatDataSource.sendMessage(any))
          .thenThrow(ServerFailure(message: 'message'));

      final actual = await chatRepository.sendMessage(params);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Left(ServerFailure()) when SocketException thrown from datasource',
        () async {
      when(mockChatDataSource.sendMessage(any))
          .thenThrow(SocketException('message'));

      final actual = await chatRepository.sendMessage(params);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Left(ServerFailure()) when any other Exception thrown from datasource',
        () async {
      when(mockChatDataSource.sendMessage(any)).thenThrow(Exception());

      final actual = await chatRepository.sendMessage(params);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return Right(Message) when everything is OK', () async {
      when(mockChatDataSource.sendMessage(any))
          .thenAnswer((_) async => tMessageModel);

      final actual = await chatRepository.sendMessage(params);

      expect(actual, equals(Right(tMessageModel)));
    });
  });

  group('addMembers', () {
    test('should check network connection', () {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));

      chatRepository.addMembers(1, [1]);

      verify(mockNetworkInfo.isConnected);
    });

    test('should return Left(ConnectionFailure()) when no internet connection',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final actual = await chatRepository.addMembers(1, [1]);

      expect(actual, equals(Left(ConnectionFailure())));
      verifyZeroInteractions(mockChatDataSource);
    });

    test(
        'should return Left(ServerFailure()) when ServerFailure thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.addMembers(any, any))
          .thenThrow(ServerFailure(message: 'message'));

      final actual = await chatRepository.addMembers(1, [1]);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return Right(ChatDetailed) when everything is OK', () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.addMembers(any, any))
          .thenAnswer((_) async => tChatDetailedModel);

      final actual = await chatRepository.addMembers(1, [1]);

      expect(actual, equals(Right(tChatDetailedModel)));
    });
  });

  group('kickMember', () {
    test('should check network connection', () {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));

      chatRepository.kickMember(1, 1);

      verify(mockNetworkInfo.isConnected);
    });

    test('should return Left(ConnectionFailure()) when no internet connection',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final actual = await chatRepository.kickMember(1, 1);

      expect(actual, equals(Left(ConnectionFailure())));
      verifyZeroInteractions(mockChatDataSource);
    });

    test(
        'should return Left(ServerFailure()) when ServerFailure thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.kickMember(any, any))
          .thenThrow(ServerFailure(message: 'message'));

      final actual = await chatRepository.kickMember(1, 1);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Left(ServerFailure()) when any error thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.kickMember(any, any)).thenThrow(Exception());

      final actual = await chatRepository.kickMember(1, 1);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return Right(ChatDetailed) when everything is OK', () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.kickMember(any, any))
          .thenAnswer((_) async => tChatDetailed);

      final actual = await chatRepository.kickMember(1, 1);

      expect(actual, equals(Right(tChatDetailed)));
    });
  });

  group('leaveChat', () {
    test('should check network connection', () {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));

      chatRepository.leaveChat(1);

      verify(mockNetworkInfo.isConnected);
    });

    test('should return Left(ConnectionFailure()) when no internet connection',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final actual = await chatRepository.leaveChat(1);

      expect(actual, equals(Left(ConnectionFailure())));
      verifyZeroInteractions(mockChatDataSource);
    });

    test(
        'should return Left(ServerFailure()) when ServerFailure thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.leaveChat(any))
          .thenThrow(ServerFailure(message: 'message'));

      final actual = await chatRepository.leaveChat(1);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Left(ServerFailure()) when any error thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.leaveChat(any)).thenThrow(Exception());

      final actual = await chatRepository.leaveChat(1);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return Right(NoParams()) when everything is OK', () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.leaveChat(any))
          .thenAnswer((_) async => Future.value());

      final actual = await chatRepository.leaveChat(1);

      expect(actual, equals(Right(NoParams())));
    });
  });

  group('updateChatSettings', () {
    test('should check network connection', () {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));

      chatRepository.updateChatSettings(
          id: 1, permissions: tChatPermissionModel);

      verify(mockNetworkInfo.isConnected);
    });

    test('should return Left(ConnectionFailure()) when no internet connection',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final actual = await chatRepository.updateChatSettings(
          id: 1, permissions: tChatPermissionModel);

      expect(actual, equals(Left(ConnectionFailure())));
      verifyZeroInteractions(mockChatDataSource);
    });

    test(
        'should return Left(ServerFailure()) when ServerFailure thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.updateChatSettings(
              id: anyNamed('id'), chatUpdates: anyNamed('chatUpdates')))
          .thenThrow(ServerFailure(message: 'message'));

      final actual = await chatRepository.updateChatSettings(
          id: 1, permissions: tChatPermissionModel);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Left(ServerFailure()) when any error thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.updateChatSettings(
              id: anyNamed('id'), chatUpdates: anyNamed('chatUpdates')))
          .thenThrow(Exception());

      final actual = await chatRepository.updateChatSettings(
          id: 1, permissions: tChatPermissionModel);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return Right(ChatPermissions) when everything is OK',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.updateChatSettings(
              id: anyNamed('id'), chatUpdates: anyNamed('chatUpdates')))
          .thenAnswer((_) async => tChatPermissionModel);

      final actual = await chatRepository.updateChatSettings(
          id: 1, permissions: tChatPermissionModel);

      expect(actual, equals(Right(tChatPermissionModel)));
    });
  });

  group('getChatMessages', () {
    test('should check network connection', () {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));

      chatRepository.getChatMessages(1, RequestDirection.top);

      verify(mockNetworkInfo.isConnected);
    });

    test('should return Left(ConnectionFailure()) when no internet connection',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final actual =
          await chatRepository.getChatMessages(1, RequestDirection.top);

      expect(actual, equals(Left(ConnectionFailure())));
      verifyZeroInteractions(mockChatDataSource);
    });

    test(
        'should return Left(ServerFailure()) when ServerFailure thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.getChatMessages(any, any))
          .thenThrow(ServerFailure(message: 'message'));

      final actual =
          await chatRepository.getChatMessages(1, RequestDirection.top);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Left(ServerFailure()) when any error thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.getChatMessages(any, any)).thenThrow(Exception());

      final actual =
          await chatRepository.getChatMessages(1, RequestDirection.top);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return Right(ChatMessagesResponse) when everything is OK',
        () async {
      final tChatMessagesResponse = ChatMessageResponse(
          result: tPaginatedResultViaLastItemMessage,
          topMessage: tMessageModel);
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.getChatMessages(any, any)).thenAnswer(
        (_) async => tChatMessagesResponse,
      );

      final actual =
          await chatRepository.getChatMessages(1, RequestDirection.top);

      expect(actual, equals(Right(tChatMessagesResponse)));
    });
  });

  group('setTimeDeleted', () {
    test('should check network connection', () {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));

      chatRepository.setTimeDeleted(id: 1, isOn: true);

      verify(mockNetworkInfo.isConnected);
    });

    test('should return Left(ConnectionFailure()) when no internet connection',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final actual = await chatRepository.setTimeDeleted(id: 1, isOn: true);

      expect(actual, equals(Left(ConnectionFailure())));
      verifyZeroInteractions(mockChatDataSource);
    });

    test(
        'should return Left(ServerFailure()) when ServerFailure thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.updateChatSettings(
        id: anyNamed('id'),
        chatUpdates: anyNamed('chatUpdates'),
      )).thenThrow(ServerFailure(message: 'message'));

      final actual = await chatRepository.setTimeDeleted(id: 1, isOn: true);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Left(ServerFailure()) when any error thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.updateChatSettings(
        id: anyNamed('id'),
        chatUpdates: anyNamed('chatUpdates'),
      )).thenThrow(Exception());

      final actual = await chatRepository.setTimeDeleted(id: 1, isOn: true);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return Right(ChatPermissions) when everything is OK',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.updateChatSettings(
        id: anyNamed('id'),
        chatUpdates: anyNamed('chatUpdates'),
      )).thenAnswer(
        (_) async => tChatPermissionModel,
      );

      final actual = await chatRepository.setTimeDeleted(id: 1, isOn: true);

      expect(actual, equals(Right(tChatPermissionModel)));
    });
  });

  group('setTimeDeleted', () {
    test('should check network connection', () {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));

      chatRepository.setTimeDeleted(id: 1, isOn: true);

      verify(mockNetworkInfo.isConnected);
    });

    test('should return Left(ConnectionFailure()) when no internet connection',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final actual = await chatRepository.setTimeDeleted(id: 1, isOn: true);

      expect(actual, equals(Left(ConnectionFailure())));
      verifyZeroInteractions(mockChatDataSource);
    });

    test(
        'should return Left(ServerFailure()) when ServerFailure thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.updateChatSettings(
        id: anyNamed('id'),
        chatUpdates: anyNamed('chatUpdates'),
      )).thenThrow(ServerFailure(message: 'message'));

      final actual = await chatRepository.setTimeDeleted(id: 1, isOn: true);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Left(ServerFailure()) when any error thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.updateChatSettings(
        id: anyNamed('id'),
        chatUpdates: anyNamed('chatUpdates'),
      )).thenThrow(Exception());

      final actual = await chatRepository.setTimeDeleted(id: 1, isOn: true);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return Right(ChatPermissions) when everything is OK',
        () async {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
      when(mockChatDataSource.updateChatSettings(
        id: anyNamed('id'),
        chatUpdates: anyNamed('chatUpdates'),
      )).thenAnswer(
        (_) async => tChatPermissionModel,
      );

      final actual = await chatRepository.setTimeDeleted(id: 1, isOn: true);

      expect(actual, equals(Right(tChatPermissionModel)));
    });
  });

  group('deleteMessage', () {
    final params = DeleteMessageParams(chatID: 1, forMe: 1, ids: '1');
    test(
        'should return Left(ServerFailure()) when ServerFailure thrown from datasource',
        () async {
      when(mockChatDataSource.deleteMessage(any))
          .thenThrow(ServerFailure(message: 'message'));

      final actual = await chatRepository.deleteMessage(params);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Left(ServerFailure()) when any error thrown from datasource',
        () async {
      when(mockChatDataSource.deleteMessage(any)).thenThrow(Exception());

      final actual = await chatRepository.deleteMessage(params);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return Right(bool) when everything is OK', () async {
      when(mockChatDataSource.deleteMessage(any)).thenAnswer(
        (_) async => Future.value(true),
      );

      final actual = await chatRepository.deleteMessage(params);

      expect(actual, equals(Right(true)));
    });
  });

  group('attachMessage', () {
    setUp(() {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
    });
    test(
        'should return Left(ServerFailure()) when ServerFailure thrown from datasource',
        () async {
      when(mockChatDataSource.attachMessage(any))
          .thenThrow(ServerFailure(message: 'message'));

      final actual = await chatRepository.attachMessage(tMessageModel);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Left(ServerFailure()) when any error thrown from datasource',
        () async {
      when(mockChatDataSource.attachMessage(any)).thenThrow(Exception());

      final actual = await chatRepository.attachMessage(tMessageModel);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return Right(bool) when everything is OK', () async {
      when(mockChatDataSource.attachMessage(any))
          .thenAnswer((_) async => Future.value(true));

      final actual = await chatRepository.attachMessage(tMessageModel);

      expect(actual, equals(Right(true)));
    });
  });

  group('disAttachMessage', () {
    setUp(() {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
    });
    test(
        'should return Left(ServerFailure()) when ServerFailure thrown from datasource',
        () async {
      when(mockChatDataSource.disAttachMessage(any))
          .thenThrow(ServerFailure(message: 'message'));

      final actual = await chatRepository.disAttachMessage(NoParams());

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Left(ServerFailure()) when any error thrown from datasource',
        () async {
      when(mockChatDataSource.disAttachMessage(any)).thenThrow(Exception());

      final actual = await chatRepository.disAttachMessage(NoParams());

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return Right(bool) when everything is OK', () async {
      when(mockChatDataSource.disAttachMessage(any))
          .thenAnswer((_) async => Future.value(true));

      final actual = await chatRepository.disAttachMessage(NoParams());

      expect(actual, equals(Right(true)));
    });
  });

  group('replyMore', () {
    final params = ReplyMoreParams(chatIds: [1], messageIds: [1]);
    setUp(() {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
    });
    test(
        'should return Left(ServerFailure()) when ServerFailure thrown from datasource',
        () async {
      when(mockChatDataSource.replyMore(any))
          .thenThrow(ServerFailure(message: 'message'));

      final actual = await chatRepository.replyMore(params);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Left(ServerFailure()) when any error thrown from datasource',
        () async {
      when(mockChatDataSource.replyMore(any)).thenThrow(Exception());

      final actual = await chatRepository.replyMore(params);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return Right(bool) when everything is OK', () async {
      when(mockChatDataSource.replyMore(any))
          .thenAnswer((_) async => Future.value(true));

      final actual = await chatRepository.replyMore(params);

      expect(actual, equals(Right(true)));
    });
  });

  group('blockUser', () {
    setUp(() {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
    });
    test(
        'should return Left(ServerFailure()) when ServerFailure thrown from datasource',
        () async {
      when(mockChatDataSource.blockUser(any))
          .thenThrow(ServerFailure(message: 'message'));

      final actual = await chatRepository.blockUser(1);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Left(ServerFailure()) when any error thrown from datasource',
        () async {
      when(mockChatDataSource.blockUser(any)).thenThrow(Exception());

      final actual = await chatRepository.blockUser(1);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return Right(bool) when everything is OK', () async {
      when(mockChatDataSource.blockUser(any))
          .thenAnswer((_) async => Future.value(true));

      final actual = await chatRepository.blockUser(1);

      expect(actual, equals(Right(true)));
    });
  });

  group('unBlockUser', () {
    setUp(() {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
    });
    test(
        'should return Left(ServerFailure()) when ServerFailure thrown from datasource',
        () async {
      when(mockChatDataSource.unblockUser(any))
          .thenThrow(ServerFailure(message: 'message'));

      final actual = await chatRepository.unblockUser(1);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Left(ServerFailure()) when any error thrown from datasource',
        () async {
      when(mockChatDataSource.unblockUser(any)).thenThrow(Exception());

      final actual = await chatRepository.unblockUser(1);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return Right(bool) when everything is OK', () async {
      when(mockChatDataSource.unblockUser(any))
          .thenAnswer((_) async => Future.value(true));

      final actual = await chatRepository.unblockUser(1);

      expect(actual, equals(Right(true)));
    });
  });

  group('setSocialMedia', () {
    setUp(() {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => Future.value(true));
    });
    test(
        'should return Left(ServerFailure()) when ServerFailure thrown from datasource',
        () async {
      when(mockChatDataSource.updateChatSettings(
        id: anyNamed('id'),
        chatUpdates: anyNamed('chatUpdates'),
      )).thenThrow(ServerFailure(message: 'message'));

      final actual =
          await chatRepository.setSocialMedia(id: 1, socialMedia: tSocialMedia);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return Left(ServerFailure()) when any error thrown from datasource',
        () async {
      when(mockChatDataSource.updateChatSettings(
        id: anyNamed('id'),
        chatUpdates: anyNamed('chatUpdates'),
      )).thenThrow(Exception());

      final actual =
          await chatRepository.setSocialMedia(id: 1, socialMedia: tSocialMedia);

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test('should return Right(bool) when everything is OK', () async {
      when(mockChatDataSource.updateChatSettings(
        id: anyNamed('id'),
        chatUpdates: anyNamed('chatUpdates'),
      )).thenAnswer((_) async => Future.value(tChatPermissionModel));

      final actual =
          await chatRepository.setSocialMedia(id: 1, socialMedia: tSocialMedia);

      expect(actual, equals(Right(tChatPermissionModel)));
    });
  });
}
