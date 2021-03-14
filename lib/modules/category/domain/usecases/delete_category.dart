import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../chats/domain/entities/category.dart';
import '../repositories/category_repository.dart';

class DeleteCategory implements UseCase<List<CategoryEntity>, int> {
  final CategoryRepository repository;

  DeleteCategory({@required this.repository});

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(int id) async {
    return await repository.deleteCategory(id);
  }
}
