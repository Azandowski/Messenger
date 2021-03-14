import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/category/domain/repositories/category_repository.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/create_category.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:mockito/mockito.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  MockCategoryRepository mockCategoryRepository;
  CreateCategoryUseCase usecase;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    usecase = CreateCategoryUseCase(mockCategoryRepository);
  });

  final tCategories = [
    CategoryEntity(id: 1, name: "name", avatar: "avatar", totalChats: 1)
  ];
  final tCreateCategoryParams = CreateCategoryParams(
    token: "token",
    avatarFile: File("avatarFile"),
    name: "name",
    chatIds: [1],
    isCreate: true,
  );

  test('shoud call repository one time and return List<CategoryEntity>',
      () async {
    when(mockCategoryRepository.createCategory(any))
        .thenAnswer((_) async => Right(tCategories));

    final result = await usecase(tCreateCategoryParams);

    expect(result, Right(tCategories));
    verify(mockCategoryRepository.createCategory(tCreateCategoryParams));
    verifyNoMoreInteractions(mockCategoryRepository);
  });
}
