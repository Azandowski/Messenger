import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/modules/chats/data/model/category_model.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/usecases/get_categories.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/usecases/params.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';



class MockChatsRepository extends Mock implements ChatsRepository {}

void main() { 
  GetCategories useCase;
  MockChatsRepository repository;

  setUp(() {
    repository = MockChatsRepository();
    useCase = GetCategories(repository: repository);
  });

  final List<CategoryModel> categories = [
    CategoryModel(
      id: 1,
      totalChats: 1,
      name: 'Superwork',
      avatar: 'image.png'
    )
  ];

  test(
    'should get categories from the repository',
    () async {
      // arrange
      when(repository.getCategories(any))
        .thenAnswer((_) async => Right(categories));
      
      // act
      final result = await useCase(GetCategoriesParams(token: ''));
      
      // assert
      
      expect(result, Right(categories));
      // verify(repository.getCategories(GetCategoriesParams(token: '')));
    },
  );
}