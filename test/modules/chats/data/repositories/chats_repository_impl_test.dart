import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chats/data/datasource/chats_datasource.dart';
import 'package:messenger_mobile/modules/chats/data/datasource/local_chats_datasource.dart';
import 'package:messenger_mobile/modules/chats/data/repositories/chats_repository_impl.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/chat_search_response.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/params.dart';
import 'package:mockito/mockito.dart';

import '../../../../variables.dart';

class MockChatsDataSource extends Mock implements ChatsDataSource {}

class MockLocalChatsDataSource extends Mock implements LocalChatsDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockChatsDataSource mockChatsDataSource;
  MockLocalChatsDataSource mockLocalChatsDataSource;
  MockNetworkInfo mockNetworkInfo;
  ChatsRepositoryImpl chatsRepository;

  setUp(() {
    mockChatsDataSource = MockChatsDataSource();
    mockLocalChatsDataSource = MockLocalChatsDataSource();
    mockNetworkInfo = MockNetworkInfo();

    chatsRepository = ChatsRepositoryImpl(
      chatsDataSource: mockChatsDataSource,
      localChatsDataSource: mockLocalChatsDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getUserChats', () {
    setUp(() {
      when(mockLocalChatsDataSource.getCategoryChats(any))
          .thenAnswer((_) async => [tChatEntityModel]);
    });
    test(
        'should return PaginatedResultViaLastItem<ChatEntity> when fromCache is true',
        () async {
      final params =
          GetChatsParams(lastChatID: null, token: 'token', fromCache: true);

      final result = await chatsRepository.getUserChats(params);

      expect(
          result,
          equals(
            Right(PaginatedResultViaLastItem<ChatEntity>(
                data: [tChatEntityModel], hasReachMax: false)),
          ));
    });

    test('should check NetworkInfo when fromCache is false', () async {
      final params =
          GetChatsParams(lastChatID: null, token: 'token', fromCache: false);
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      await chatsRepository.getUserChats(params);

      verify(mockNetworkInfo.isConnected);
    });

    test(
        'should return PaginatedResultViaLastItem<ChatEntity> when fromCache is false and no network connection',
        () async {
      final params =
          GetChatsParams(lastChatID: null, token: 'token', fromCache: false);
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await chatsRepository.getUserChats(params);

      verify(mockNetworkInfo.isConnected);
      expect(
          result,
          equals(
            Right(PaginatedResultViaLastItem<ChatEntity>(
                data: [tChatEntityModel], hasReachMax: false)),
          ));
    });

    test(
        'should return PaginatedResultViaLastItem<ChatEntity> when fromCache is false and connected to network',
        () async {
      final params =
          GetChatsParams(lastChatID: null, token: 'token', fromCache: false);
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockChatsDataSource.getUserChats(token: anyNamed('token')))
          .thenAnswer((_) async => tPaginatedResultViaLastChatEntity);

      final result = await chatsRepository.getUserChats(params);

      expect(result, equals(Right(tPaginatedResultViaLastChatEntity)));
      verify(mockLocalChatsDataSource
              .setCategoryChats(tPaginatedResultViaLastChatEntity.data))
          .called(1);
    });

    test('should call localChatsDataSource.resetAll() when lastChatID is null',
        () async {
      final params =
          GetChatsParams(lastChatID: null, token: 'token', fromCache: false);
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockChatsDataSource.getUserChats(token: anyNamed('token')))
          .thenAnswer((_) async => tPaginatedResultViaLastChatEntity);

      await chatsRepository.getUserChats(params);

      verify(mockLocalChatsDataSource.resetAll()).called(1);
    });

    test(
        'should not call localChatsDataSource.resetAll() when lastChatID is not null',
        () {
      final params =
          GetChatsParams(lastChatID: null, token: 'token', fromCache: false);
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockChatsDataSource.getUserChats(token: anyNamed('token')))
          .thenAnswer((_) async => tPaginatedResultViaLastChatEntity);

      chatsRepository.getUserChats(params);

      verifyNever(mockLocalChatsDataSource.resetAll());
    });
  });

  group('getCategoryChats', () {
    setUp(() {
      when(mockLocalChatsDataSource.getCategoryChats(any))
          .thenAnswer((_) async => [tChatEntityModel]);
    });

    test(
      'should return PaginatedResultViaLastItem<ChatEntity> when lastChatID == null',
      () async {
        final params = GetCategoryChatsParams(token: 'token', categoryID: 1);

        final result = await chatsRepository.getCategoryChats(params);

        expect(
          result,
          equals(Right(PaginatedResultViaLastItem<ChatEntity>(
              data: [tChatEntityModel], hasReachMax: false))),
        );
      },
    );

    test(
      'should check network connection when lastChatID != null',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        final params = GetCategoryChatsParams(
            token: 'token', categoryID: 1, lastChatID: 1);

        await chatsRepository.getCategoryChats(params);

        verify(mockNetworkInfo.isConnected).called(1);
      },
    );

    test(
      'should return PaginatedResultViaLastItem<ChatEntity> when NOT connected to the network',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        final params = GetCategoryChatsParams(
            token: 'token', categoryID: 1, lastChatID: 1);

        final result = await chatsRepository.getCategoryChats(params);

        expect(
          result,
          equals(Right(PaginatedResultViaLastItem<ChatEntity>(
              data: [tChatEntityModel], hasReachMax: false))),
        );
      },
    );

    test(
      'should setCategoryChats and return PaginatedResultViaLastItem<ChatEntity> received from chatsDataSource when connected to the network',
      () async {
        final params = GetCategoryChatsParams(
            token: 'token', categoryID: 1, lastChatID: 1);
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockChatsDataSource.getCategoryChat(
          token: anyNamed('token'),
          categoryID: anyNamed('categoryID'),
          lastChatId: anyNamed('lastChatId'),
        )).thenAnswer((_) async => tPaginatedResultViaLastChatEntity);

        final result = await chatsRepository.getCategoryChats(params);

        expect(
          result,
          equals(Right(tPaginatedResultViaLastChatEntity)),
        );
        verify(mockLocalChatsDataSource
            .setCategoryChats(tPaginatedResultViaLastChatEntity.data));
      },
    );

    test(
      'should return Failure when one received from chatsDataSource',
      () async {
        final params = GetCategoryChatsParams(
            token: 'token', categoryID: 1, lastChatID: 1);
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockChatsDataSource.getCategoryChat(
          token: anyNamed('token'),
          categoryID: anyNamed('categoryID'),
          lastChatId: anyNamed('lastChatId'),
        )).thenThrow(ServerFailure(message: 'message'));

        final result = await chatsRepository.getCategoryChats(params);

        expect(
          result,
          equals(Left(ServerFailure(message: 'message'))),
        );
      },
    );
  });

  group('searchChats', () {
    test('should check network connection', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      await chatsRepository.searchChats();

      verify(mockNetworkInfo.isConnected).called(1);
    });

    test('should return ConnectionFailure when no connection', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final actual = await chatsRepository.searchChats();

      expect(actual, equals(Left(ConnectionFailure())));
    });

    test('should return ConnectionFailure when no connection', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final actual = await chatsRepository.searchChats();

      expect(actual, equals(Left(ConnectionFailure())));
    });

    test('should return Failure when one received from datasource', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockChatsDataSource.searchChats(
        nextPageURL: anyNamed('nextPageURL'),
        chatID: anyNamed('chatID'),
        queryText: anyNamed('queryText'),
      )).thenThrow(ServerFailure(message: 'message'));

      final actual = await chatsRepository.searchChats();

      expect(actual, equals(Left(ServerFailure(message: 'message'))));
    });

    test(
        'should return ServerFailure when any other Exception thrown from datasource',
        () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockChatsDataSource.searchChats(
        nextPageURL: anyNamed('nextPageURL'),
        chatID: anyNamed('chatID'),
        queryText: anyNamed('queryText'),
      )).thenThrow(Exception());

      final actual = await chatsRepository.searchChats();

      expect(actual, equals(Left(ServerFailure(message: null))));
    });

    test('should return ChatMessageResponse when OK', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockChatsDataSource.searchChats(
        nextPageURL: anyNamed('nextPageURL'),
        chatID: anyNamed('chatID'),
        queryText: anyNamed('queryText'),
      )).thenAnswer(
        (_) async => ChatMessageResponse(
          chats: [tChatEntityModel],
          messages: tPaginatedResultMessage,
        ),
      );

      final actual = await chatsRepository.searchChats();

      expect(
          actual,
          equals(
            Right(ChatMessageResponse(
              chats: [tChatEntityModel],
              messages: tPaginatedResultMessage,
            )),
          ));
    });
  });
}
