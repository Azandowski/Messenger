import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../chats/domain/entities/category.dart';
import '../repositories/create_category_repository.dart';
import 'params.dart';

class CreateCategoryUseCase extends UseCase<List<CategoryEntity>, CreateCategoryParams>  {
  final CreateCategoryRepository repository;

  CreateCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(CreateCategoryParams params) async {
    return await repository.createCategory(params);
  }
}