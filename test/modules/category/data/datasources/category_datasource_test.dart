import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/category/data/datasources/category_datasource.dart';
import 'package:messenger_mobile/modules/chats/data/model/category_model.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockMultiPartRequest extends Mock implements http.MultipartRequest {}

class MockAuthConfig extends Mock implements AuthConfig {}

//test
void main() {
  CategoryDataSourceImpl dataSource;
  MockHttpClient httpClient;
  MockMultiPartRequest multiPartRequest;
  MockAuthConfig authConfig;

  setUp(() {
    httpClient = MockHttpClient();
    multiPartRequest = MockMultiPartRequest();
    authConfig = MockAuthConfig();

    dataSource = CategoryDataSourceImpl(
      multipartRequest: multiPartRequest,
      client: httpClient,
      authConfig: authConfig,
    );
  });

  final tCategories = [
    CategoryModel(
      id: 1,
      name: "name",
      avatar: "avatar",
      totalChats: 1,
    )
  ];

  group('getCategories', () {
    test('should return List<CategoryModel> if status code is 2**', () async {
      when(httpClient.get(any, headers: anyNamed("headers"))).thenAnswer(
        (_) async => http.Response(fixture('category_model.json'), 200),
      );
      final result = await dataSource.getCategories('token');
      expect(result, equals(tCategories));
    });

    test('should throw ServerFailure if status code is no 2**', () async {
      when(httpClient.get(any, headers: anyNamed("headers"))).thenAnswer(
        (_) async => http.Response(fixture('category_model.json'), 400),
      );
      expect(dataSource.getCategories('token'), throwsA(isA<ServerFailure>()));
    });
  });

  group('deleteCatefory', () {
    test('should return List<CategoryModel> if status code is 2**', () async {
      when(httpClient.delete(any, headers: anyNamed("headers"))).thenAnswer(
        (_) async => http.Response(
          fixture('category_model.json'),
          200,
        ),
      );
      final result = await dataSource.deleteCatefory(1);
      expect(result, equals(tCategories));
    });

    test('should throw ServerFailure if status code is no 2**', () async {
      when(httpClient.delete(any, headers: anyNamed("headers"))).thenAnswer(
        (_) async => http.Response(
          fixture('category_model.json'),
          400,
        ),
      );
      expect(dataSource.deleteCatefory(1), throwsA(isA<ServerFailure>()));
    });
  });

  group('transferChats', () {
    test('should return List<CategoryModel> if status code is 2**', () async {
      when(httpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async =>
            http.Response(fixture('category_model_transfer_chats.json'), 200),
      );
      final result = await dataSource.transferChats([1], 1);
      expect(result, equals(tCategories));
    });

    test('should throw ServerFailure if status code is no 2**', () async {
      when(httpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async =>
            http.Response(fixture('category_model_transfer_chats.json'), 400),
      );
      expect(dataSource.transferChats([1], 1), throwsA(isA<ServerFailure>()));
    });
  });

  group('reorderCategories', () {
    test('should return List<CategoryModel> if status code is 2**', () async {
      when(httpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(
            fixture('category_model_reorder_categories.json'), 200),
      );
      final result = await dataSource.reorderCategories({});
      expect(result, equals(tCategories));
    });

    test('should throw ServerFailure if status code is no 2**', () async {
      when(httpClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response(
            fixture('category_model_reorder_categories.json'), 400),
      );
      expect(dataSource.reorderCategories({}), throwsA(isA<ServerFailure>()));
    });
  });
}
