import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/category/domain/repositories/category_repository.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/transfer_chat.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:mockito/mockito.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  MockCategoryRepository mockCategoryRepository;
  TransferChats usecase;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    usecase = TransferChats(repository: mockCategoryRepository);
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
  final tParams = TransferChatsParams(newCategoryId: 1, chatsIDs: [1, 2, 3]);

  test('should call repo once and return List<CategoryEntity>', () async {
    when(mockCategoryRepository.transferChats(any, any)).thenAnswer(
      (_) async => Right(tCategories),
    );

    final result = await usecase(tParams);

    expect(result, Right(tCategories));
    verify(mockCategoryRepository.transferChats([1, 2, 3], 1));
    verifyNoMoreInteractions(mockCategoryRepository);
  });
}
