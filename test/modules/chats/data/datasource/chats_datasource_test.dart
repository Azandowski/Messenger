import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/socket_service.dart';
import 'package:messenger_mobile/modules/chats/data/datasource/chats_datasource.dart';
import 'package:messenger_mobile/modules/chats/data/model/chat_search_response_model.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSocketService extends Mock implements SocketService {}

class MockAuthConfig extends Mock implements AuthConfig {}

main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  ChatsDataSourceImpl chatsDataSource;
  MockHttpClient httpClient;
  MockSocketService socketService;
  MockAuthConfig authConfig;

  setUp(() async {
    httpClient = MockHttpClient();
    socketService = MockSocketService();
    authConfig = MockAuthConfig();

    chatsDataSource = ChatsDataSourceImpl(
      client: httpClient,
      socketService: socketService,
      authConfig: authConfig,
    );
  });

  group('getUserChats', () {
    test('should throw a Server failure when response is NOT successful',
        () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('message', 400));

      expect(chatsDataSource.getUserChats(token: 'token'),
          throwsA(ServerFailure(message: 'message')));
    });

    test(
        'should return PaginatedResultViaLastItem<ChatEntity> when response is successful',
        () async {
      when(httpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(
              fixture('paginated_result_via_last_item_chat_entity.json'), 200));

      final actual = await chatsDataSource.getUserChats(token: 'token');

      expect(actual, equals(tPaginatedResultViaLastChatEntity));
    });
  });

  group('searchChats', () {
    test('should throw a Server failure when response is NOT successful',
        () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('message', 400));

      expect(chatsDataSource.searchChats(queryText: 'query'),
          throwsA(ServerFailure(message: 'message')));
    });

    test('should return ChatMessageResponse when response is successful',
        () async {
      when(httpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async =>
              http.Response(fixture('chat_search_response_model.json'), 200));

      final actual = await chatsDataSource.searchChats(queryText: 'query');

      expect(actual, isA<ChatSearchResponseModel>());
    });
  });

  group('getCategoryChat', () {
    test('should throw a Server failure when response is NOT successful',
        () async {
      when(httpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('message', 400));

      expect(
          chatsDataSource.getCategoryChat(
              categoryID: 1, token: 'token', lastChatId: 1),
          throwsA(ServerFailure(message: 'message')));
    });

    test(
        'should return PaginatedResultViaLastItem<ChatEntity> when response is successful',
        () async {
      when(httpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(
              fixture('paginated_result_via_last_item_chat_entity.json'), 200));

      final actual = await chatsDataSource.getCategoryChat(
          categoryID: 1, token: 'token', lastChatId: 1);

      expect(actual, equals(tPaginatedResultViaLastChatEntity));
    });
  });
}
