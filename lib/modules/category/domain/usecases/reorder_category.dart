import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../chats/domain/entities/category.dart';
import '../repositories/category_repository.dart';

class ReorderCategories
    implements UseCase<List<CategoryEntity>, Map<String, int>> {
  final CategoryRepository repository;

  ReorderCategories({@required this.repository});

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(
      Map<String, int> params) async {
    return await repository.reorderCategories(params);
  }
}
