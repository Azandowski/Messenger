import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../chats/domain/entities/category.dart';
import '../usecases/params.dart';

abstract class CreateCategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> createCategory(CreateCategoryParams createCategoryParams);
}