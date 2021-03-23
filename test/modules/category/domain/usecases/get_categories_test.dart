import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/category/domain/repositories/category_repository.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/create_category.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/get_categories.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/usecases/params.dart';
import 'package:mockito/mockito.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  MockCategoryRepository mockCategoryRepository;
  GetCategories usecase;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    usecase = GetCategories(repository: mockCategoryRepository);
  });

  final tGetCategoriesParams = GetCategoriesParams(token: "token");
  final tCategories = [
    CategoryEntity(id: 1, name: "name", avatar: "avatar", totalChats: 1, noReadCount: 1,)
  ];

  test('should call repository once and return List<CategoryEntity>', () async {
    when(mockCategoryRepository.getCategories(tGetCategoriesParams)).thenAnswer(
      (_) async => Right(tCategories),
    );

    final result = await usecase(tGetCategoriesParams);

    expect(result, Right(tCategories));
    verify(mockCategoryRepository.getCategories(tGetCategoriesParams));
    verifyNoMoreInteractions(mockCategoryRepository);
  });
}
