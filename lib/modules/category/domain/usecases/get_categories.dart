import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../chats/domain/entities/category.dart';
import '../../../chats/domain/entities/usecases/params.dart';
import '../repositories/category_repository.dart';

class GetCategories implements UseCase<List<CategoryEntity>, GetCategoriesParams> {
  final CategoryRepository repository;

  GetCategories({
    @required this.repository
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(
      GetCategoriesParams params) async {
    return await repository.getCategories(params);
  }
}
