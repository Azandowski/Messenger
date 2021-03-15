import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../chats/domain/entities/category.dart';
import '../../../chats/domain/entities/usecases/params.dart';
import '../usecases/params.dart';

abstract class CategoryRepository {
  StreamController<List<CategoryEntity>> categoryListController;

  Future<Either<Failure, List<CategoryEntity>>> createCategory(
    CreateCategoryParams createCategoryParams
  );
  
  Future<Either<Failure, List<CategoryEntity>>> getCategories(
    GetCategoriesParams getCategoryParams
  );

  Future<Either<Failure, List<CategoryEntity>>> deleteCategory(int id);

  Future<Either<Failure, List<CategoryEntity>>> transferChats(List<int> chatsIDs, int categoryID);

  Future<Either<Failure, List<CategoryEntity>>> reorderCategories (Map<String, int> categoryUpdates);
}