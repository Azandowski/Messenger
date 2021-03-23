import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/category/domain/repositories/category_repository.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/reorder_category.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:mockito/mockito.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  MockCategoryRepository mockCategoryRepository;
  ReorderCategories usecase;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    usecase = ReorderCategories(repository: mockCategoryRepository);
  });

  final tCategories = [
    CategoryEntity(
      id: 1,
      name: "name",
      avatar: "avatar",
      totalChats: 1,
      noReadCount: 1,
    )
  ];
  final Map<String, int> tParams = {"test": 1};

  test('should call repositoey once and return List<CategoryEntity>', () async {
    when(mockCategoryRepository.reorderCategories(any)).thenAnswer(
      (_) async => Right(tCategories),
    );

    final result = await usecase(tParams);

    expect(result, Right(tCategories));
    verify(mockCategoryRepository.reorderCategories(tParams));
    verifyNoMoreInteractions(mockCategoryRepository);
  });
}
