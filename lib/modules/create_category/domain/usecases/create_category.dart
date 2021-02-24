import 'package:messenger_mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:messenger_mobile/modules/create_category/domain/repositories/create_category_repository.dart';
import 'package:messenger_mobile/modules/create_category/domain/usecases/params.dart';

class CreateCategoryUseCase extends UseCase<List<CategoryEntity>, CreateCategoryParams>  {
  final CreateCategoryRepository repository;

  CreateCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(CreateCategoryParams params) async {
    return await repository.createCategory(params);
  }
}