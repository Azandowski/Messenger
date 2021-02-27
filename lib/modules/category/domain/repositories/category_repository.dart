import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/usecases/params.dart';

import '../../../../core/error/failures.dart';
import '../../../chats/domain/entities/category.dart';
import '../usecases/params.dart';

abstract class CategoryRepository {
  
  Future<Either<Failure, List<CategoryEntity>>> createCategory(CreateCategoryParams createCategoryParams);
  
  StreamController<List<CategoryEntity>> categoryListController;
  
  Future<Either<Failure, List<CategoryEntity>>> getCategories(
    GetCategoriesParams getCategoryParams
  );

  Future<Either<Failure, CategoryEntity>> deleteCategory(int id);
}