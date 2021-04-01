import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/chats/data/datasource/chats_datasource.dart';
import 'package:messenger_mobile/modules/chats/data/model/category_model.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MockHttpClient extends Mock implements http.Client {}

main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  ChatsDataSourceImpl chatsDataSourceImpl;
  MockHttpClient httpClient;

  setUp(() async {
    httpClient = MockHttpClient();
    chatsDataSourceImpl = ChatsDataSourceImpl(client: httpClient);
  });

  final List<CategoryModel> categories = [
    CategoryModel(id: 1, totalChats: 1, name: 'Superwork', avatar: 'image.png')
  ];

  group('Loading Categories for the chat', () {
    test('should successfully load categories', () async {
      when(httpClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async {
        var jsonArray = categories.map((e) => e.toJson()).toList();
        return http.Response(json.encode(jsonArray), 200);
      });

      // final result = await chatsDataSourceImpl.getCategories('token');

      //  expect(result, equals(categories));
    });

    test('should send error', () async {
      when(httpClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('error is here', 400));

      // final call = chatsDataSourceImpl.getCategories;
      // expect(() => call('token'), throwsA(isA<ServerFailure>()));
    });
  });
}
