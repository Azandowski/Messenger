import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/category/domain/repositories/category_repository.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/delete_category.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:mockito/mockito.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  MockCategoryRepository mockCategoryRepository;
  DeleteCategory usecase;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    usecase = DeleteCategory(repository: mockCategoryRepository);
  });

  final tId = 1;
  final tCategories = [
    CategoryEntity(id: 1, name: "name", avatar: "avatar", totalChats: 1)
  ];

  test('shoud call repository one time and return List<CategoryEntity>',
      () async {
    when(mockCategoryRepository.deleteCategory(any)).thenAnswer(
      (_) async => Right(tCategories),
    );

    final result = await usecase(tId);

    expect(result, Right(tCategories));
    verify(mockCategoryRepository.deleteCategory(tId));
  });
}
