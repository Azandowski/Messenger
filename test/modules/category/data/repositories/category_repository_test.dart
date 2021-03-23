import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/modules/category/data/datasources/category_datasource.dart';
import 'package:messenger_mobile/modules/category/data/repositories/category_repository.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/usecases/params.dart';
import 'package:mockito/mockito.dart';

class MockCategoryDataSource extends Mock implements CategoryDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockCategoryDataSource dataSource;
  MockNetworkInfo networkInfo;
  CategoryRepositoryImpl repository;

  setUp(() {
    dataSource = MockCategoryDataSource();
    networkInfo = MockNetworkInfo();
    repository = CategoryRepositoryImpl(
      categoryDataSource: dataSource,
      networkInfo: networkInfo,
    );
  });

  final tCategoryEntityList = [
    CategoryEntity(
      id: 1,
      name: "name",
      avatar: "avatar",
      totalChats: 1,
      noReadCount: 1,
    ),
  ];

  group('createCategory', () {
    final tCreateCategoryParams = CreateCategoryParams(
      token: "token",
      avatarFile: File("avatarFile"),
      name: "name",
      chatIds: [1, 2, 3],
      isCreate: true,
    );

    test('should check connectivity', () {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      repository.createCategory(tCreateCategoryParams);
      verify(networkInfo.isConnected);
    });

    test('shoud return ConnectionFailure when no internet connection',
        () async {
      when(networkInfo.isConnected).thenAnswer((_) async => false);
      final result = await repository.createCategory(tCreateCategoryParams);
      expect(result, Left(ConnectionFailure()));
      verifyZeroInteractions(dataSource);
    });

    test('should return ServerFailure when one throwed in DataSource',
        () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(dataSource.createCategory(
        file: anyNamed("file"),
        name: anyNamed("name"),
        token: anyNamed("token"),
        chatIds: anyNamed("chatIds"),
        isCreate: anyNamed("isCreate"),
        categoryID: anyNamed("categoryID"),
      )).thenThrow(ServerFailure(message: "test"));

      final result = await repository.createCategory(tCreateCategoryParams);

      expect(result, equals(Left(ServerFailure(message: "test"))));
    });

    test('should return List<CategoryEntity> when everything is OK', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(dataSource.createCategory(
        file: anyNamed("file"),
        name: anyNamed("name"),
        token: anyNamed("token"),
        chatIds: anyNamed("chatIds"),
        isCreate: anyNamed("isCreate"),
        categoryID: anyNamed("categoryID"),
      )).thenAnswer((_) async => tCategoryEntityList);

      final result = await repository.createCategory(tCreateCategoryParams);

      expect(result, equals(Right(tCategoryEntityList)));
    });
  });

  group('getCategories', () {
    final tGetCategoriesParams = GetCategoriesParams(token: "token");

    test('should check connectivity', () {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      repository.getCategories(tGetCategoriesParams);
      verify(networkInfo.isConnected);
    });

    test('should return ConnectionFailure when no connection', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => false);
      final result = await repository.getCategories(tGetCategoriesParams);
      expect(result, Left(ConnectionFailure()));
    });

    test('should return ServerFailure when one thrown from repository',
        () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(dataSource.getCategories(any))
          .thenThrow(ServerFailure(message: 'test'));

      final result = await repository.getCategories(tGetCategoriesParams);

      expect(result, Left(ServerFailure(message: 'test')));
    });

    test('should return List<CategoryEntity> when everything is OK', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(dataSource.getCategories(any))
          .thenAnswer((_) async => tCategoryEntityList);

      final result = await repository.getCategories(tGetCategoriesParams);

      expect(result, Right(tCategoryEntityList));
    });
  });

  group('deleteCategory', () {
    test('should check connectivity', () {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      repository.deleteCategory(1);
      verify(networkInfo.isConnected);
    });

    test('should return ConnectionFailure when no connection', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => false);
      final result = await repository.deleteCategory(1);
      expect(result, Left(ConnectionFailure()));
    });

    test('should return ServerFailure when one thrown from repository',
        () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(dataSource.deleteCatefory(any))
          .thenThrow(ServerFailure(message: 'test'));

      final result = await repository.deleteCategory(1);

      expect(result, Left(ServerFailure(message: 'test')));
    });

    test('should return List<CategoryEntity> when everything is OK', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(dataSource.deleteCatefory(any))
          .thenAnswer((_) async => tCategoryEntityList);

      final result = await repository.deleteCategory(1);

      expect(result, Right(tCategoryEntityList));
    });
  });

  group('transferChats', () {
    test('should check connectivity', () {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      repository.transferChats([1], 1);
      verify(networkInfo.isConnected);
    });

    test('should return ConnectionFailure when no connection', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => false);
      final result = await repository.transferChats([1], 1);
      expect(result, Left(ConnectionFailure()));
    });

    test('should return ServerFailure when one thrown from repository',
        () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(dataSource.transferChats(any, any))
          .thenThrow(ServerFailure(message: 'test'));

      final result = await repository.transferChats([1], 1);

      expect(result, Left(ServerFailure(message: 'test')));
    });

    test('should return List<CategoryEntity> when everything is OK', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(dataSource.transferChats(any, any))
          .thenAnswer((_) async => tCategoryEntityList);

      final result = await repository.transferChats([1], 1);

      expect(result, Right(tCategoryEntityList));
    });
  });

  group('reorderCategories', () {
    final Map<String, int> tCategoryUpdates = {"key": 1};
    test('should check connectivity', () {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      repository.reorderCategories(tCategoryUpdates);
      verify(networkInfo.isConnected);
    });

    test('should return ConnectionFailure when no connection', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => false);
      final result = await repository.reorderCategories(tCategoryUpdates);
      expect(result, Left(ConnectionFailure()));
      verifyZeroInteractions(dataSource);
    });

    test('should return ServerFailure when one thrown from repository',
        () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(dataSource.reorderCategories(any))
          .thenThrow(ServerFailure(message: 'test'));

      final result = await repository.reorderCategories(tCategoryUpdates);

      expect(result, Left(ServerFailure(message: 'test')));
    });

    test('should return List<CategoryEntity> when everything is OK', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(dataSource.reorderCategories(any))
          .thenAnswer((_) async => tCategoryEntityList);

      final result = await repository.reorderCategories(tCategoryUpdates);

      expect(result, Right(tCategoryEntityList));
    });
  });
}
