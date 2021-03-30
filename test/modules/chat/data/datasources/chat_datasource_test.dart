import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/core/services/network/socket_service.dart';
import 'package:messenger_mobile/modules/chat/data/datasources/chat_datasource.dart';
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockHttpMultipartRequest extends Mock implements http.MultipartRequest {}

class MockSocketService extends Mock implements SocketService {}

class MockCattt extends Mock implements Cattt {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MockSocketService socketService;
  MockHttpClient httpClient;
  MockHttpMultipartRequest multipartRequest;
  ChatDataSourceImpl chatDataSource;
  MockCattt cattt;

  setUp(() {
    httpClient = MockHttpClient();
    multipartRequest = MockHttpMultipartRequest();
    socketService = MockSocketService();
    cattt = MockCattt();
    chatDataSource = ChatDataSourceImpl(
      id: 1,
      client: httpClient,
      socketService: socketService,
      multipartRequest: multipartRequest,
      cat: cattt,
    );
  });

  test('test', () {
    when(cattt.sound()).thenReturn("Purr");

    chatDataSource.leaveChat(1);
  });
}
