import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:messenger_mobile/modules/create_category/domain/usecases/params.dart';

abstract class CreateCategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> createCategory(CreateCategoryParams createCategoryParams);
}