import 'package:dartz/dartz_streaming.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:laravel_echo/laravel_echo.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/socket_service.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chat/data/datasources/chat_datasource.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/chat/presentation/chat_details/page/chat_detail_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockHttpMultipartRequest extends Mock implements http.MultipartRequest {}

class MockSocketService extends Mock implements SocketService {}

class MockIOSocket extends Mock implements IO.Socket {}

class MockAuthConfig extends Mock implements AuthConfig {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ChatDataSourceImpl chatDataSource;

  MockSocketService mockSocketService;
  MockHttpClient mockClient;
  MockHttpMultipartRequest mockMultipartRequest;
  MockIOSocket mockSocket;
  MockAuthConfig mockAuthConfig;

  setUp(() {
    mockSocket = MockIOSocket();
    final echo = new Echo({
      'broadcaster': 'socket.io',
      'client': mockSocket,
    });

    mockClient = MockHttpClient();
    mockMultipartRequest = MockHttpMultipartRequest();
    mockSocketService = MockSocketService();
    mockAuthConfig = MockAuthConfig();

    when(mockSocketService.echo).thenReturn(echo);

    chatDataSource = ChatDataSourceImpl(
      id: 1,
      client: mockClient,
      socketService: mockSocketService,
      multipartRequest: mockMultipartRequest,
      authConfig: mockAuthConfig,
    );
  });

  group('getChatDetails', () {
    test('should return ChatDetailedModel when response is successfull',
        () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixture('chat_detailed_model.json'), 200),
      );
      final actual = await chatDataSource.getChatDetails(1, ProfileMode.user);
      expect(actual, equals(tChatDetailedModel));
    });

    test('should throw ServerFailure when response is unsuccessful', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixture('error_response.json'), 400),
      );

      expect(
        chatDataSource.getChatDetails(1, ProfileMode.user),
        throwsA(ServerFailure(message: 'message')),
      );
    });
  });

  group('getChatMembers', () {
    test(
        'should return PaginatedResult<ContactEntity> when response is successfull',
        () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async =>
            http.Response(fixture('paginated_result_contact_model.json'), 200),
      );
      final actual = await chatDataSource.getChatMembers(1, tPagination);
      expect(actual, equals(tPaginatedResultContactModel));
    });

    test('should throw ServerFailure when response is unsuccessful', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixture('error_response.json'), 400),
      );

      expect(
        chatDataSource.getChatMembers(1, tPagination),
        throwsA(ServerFailure(message: 'message')),
      );
    });
  });

  group('addMembers', () {
    test('should return ChatDetailedModel when response is successfull',
        () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(fixture('chat_detailed_model.json'), 200),
      );
      final actual = await chatDataSource.addMembers(1, [1]);
      expect(actual, equals(tChatDetailedModel));
    });

    test('should throw ServerFailure when response is unsuccessful', () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(fixture('error_response.json'), 400),
      );

      expect(
        chatDataSource.addMembers(1, [1]),
        throwsA(ServerFailure(message: 'message')),
      );
    });
  });

  group('kickMember', () {
    test('should return ChatDetailedModel when response is successfull',
        () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(fixture('chat_detailed_model.json'), 200),
      );
      final actual = await chatDataSource.kickMember(1, 1);
      expect(actual, equals(tChatDetailedModel));
    });

    test('should throw ServerFailure when response is unsuccessful', () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(fixture('error_response.json'), 400),
      );

      expect(
        chatDataSource.kickMember(1, 1),
        throwsA(ServerFailure(message: 'message')),
      );
    });
  });

  group('leaveChat', () {
    test('should throw ServerFailure when response is unsuccessful', () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async => http.Response(fixture('error_response.json'), 400),
      );

      expect(
        chatDataSource.leaveChat(1),
        throwsA(ServerFailure(message: 'message')),
      );
    });
  });

  group('updateChatSettings', () {
    test('should return ChatPermissionModel when response is successfull',
        () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(fixture('chat_permission_model.json'), 200),
      );
      final actual =
          await chatDataSource.updateChatSettings(chatUpdates: {}, id: 1);
      expect(actual, equals(tChatPermissionModel));
    });

    test('should throw ServerFailure when response is unsuccessful', () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(fixture('error_response.json'), 400),
      );

      expect(
        chatDataSource.updateChatSettings(chatUpdates: {}, id: 1),
        throwsA(ServerFailure(message: 'message')),
      );
    });
  });

  group('getChatMessages', () {
    test('should return ChatMessageResponse when response is successfull',
        () async {
      when(mockClient.get(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async => http.Response(fixture('chat_message_response.json'), 200),
      );
      final actual =
          await chatDataSource.getChatMessages(1, RequestDirection.top);

      expect(actual, equals(tChatMessageResponseModel));
    });

    test('should throw ServerFailure when response is unsuccessful', () async {
      when(mockClient.get(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async => http.Response(fixture('error_response.json'), 400),
      );

      expect(
        chatDataSource.getChatMessages(1, RequestDirection.top),
        throwsA(ServerFailure(message: 'message')),
      );
    });
  });

  group('getChatMessageContext', () {
    test('should return ChatMessageResponse when response is successfull',
        () async {
      when(mockClient.get(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async => http.Response(fixture('chat_message_response.json'), 200),
      );
      final actual = await chatDataSource.getChatMessageContext(1, 1);

      expect(actual, equals(tChatMessageResponseModel));
    });

    test('should throw ServerFailure when response is unsuccessful', () async {
      when(mockClient.get(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async => http.Response(fixture('error_response.json'), 400),
      );

      expect(
        chatDataSource.getChatMessageContext(1, 1),
        throwsA(ServerFailure(message: 'message')),
      );
    });
  });

  group('deleteMessage', () {
    final params = DeleteMessageParams(ids: '1', forMe: 1, chatID: 1);

    test('should return true when response is successfull', () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response('', 200),
      );
      final actual = await chatDataSource.deleteMessage(params);
      expect(actual, equals(true));
    });

    test('should throw ServerFailure when response is unsuccessful', () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(fixture('error_response.json'), 400),
      );

      expect(
        chatDataSource.deleteMessage(params),
        throwsA(ServerFailure(message: 'message')),
      );
    });
  });

  group('attachMessage', () {
    test('should return true when response is successfull', () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response('', 200),
      );
      final actual = await chatDataSource.attachMessage(tMessage);
      expect(actual, equals(true));
    });

    test('should throw ServerFailure when response is unsuccessful', () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(fixture('error_response.json'), 400),
      );

      expect(
        chatDataSource.attachMessage(tMessage),
        throwsA(ServerFailure(message: 'message')),
      );
    });
  });

  group('disAttachMessage', () {
    test('should return true when response is successfull', () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response('', 200),
      );
      final actual = await chatDataSource.disAttachMessage(NoParams());
      expect(actual, equals(true));
    });

    test('should throw ServerFailure when response is unsuccessful', () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(fixture('error_response.json'), 400),
      );

      expect(
        chatDataSource.disAttachMessage(NoParams()),
        throwsA(ServerFailure(message: 'message')),
      );
    });
  });

  group('replyMore', () {
    final params = ReplyMoreParams(chatIds: [1], messageIds: [1]);
    test('should return true when response is successfull', () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response('', 200),
      );
      final actual = await chatDataSource.replyMore(params);
      expect(actual, equals(true));
    });

    test('should throw ServerFailure when response is unsuccessful', () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(fixture('error_response.json'), 400),
      );

      expect(
        chatDataSource.replyMore(params),
        throwsA(ServerFailure(message: 'message')),
      );
    });
  });

  group('blockUser', () {
    test('should return true when response is successfull', () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response('', 200),
      );
      final actual = await chatDataSource.blockUser(1);
      expect(actual, equals(true));
    });

    test('should throw ServerFailure when response is unsuccessful', () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(fixture('error_response.json'), 400),
      );

      expect(
        chatDataSource.blockUser(1),
        throwsA(ServerFailure(message: 'message')),
      );
    });
  });

  group('unblockUser', () {
    test('should return true when response is successfull', () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response('', 200),
      );
      final actual = await chatDataSource.unblockUser(1);
      expect(actual, equals(true));
    });

    test('should throw ServerFailure when response is unsuccessful', () async {
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(fixture('error_response.json'), 400),
      );

      expect(
        chatDataSource.unblockUser(1),
        throwsA(ServerFailure(message: 'message')),
      );
    });
  });

  group('sendMessage', () {
    final params =
        SendMessageParams(identificator: 1, chatID: 1, forwardIds: [1]);

    test('should return true when response is successfull', () async {
      final actual = await chatDataSource.sendMessage(params);
    });
  });
}
