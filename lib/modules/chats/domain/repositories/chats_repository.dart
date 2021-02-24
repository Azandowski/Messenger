import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/category.dart';
import '../entities/usecases/params.dart';

abstract class ChatsRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories(
      GetCategoriesParams getCategoryParams);
}
