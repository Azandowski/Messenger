import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/usecases/params.dart';

import '../../../../core/error/failures.dart';
import '../../../chats/domain/entities/category.dart';

abstract class CreateCategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> createCategory(CreateCategoryParams createCategoryParams);
  StreamController<List<CategoryEntity>> categoryListController;
   Future<Either<Failure, List<CategoryEntity>>> getCategories(
      GetCategoriesParams getCategoryParams);
}