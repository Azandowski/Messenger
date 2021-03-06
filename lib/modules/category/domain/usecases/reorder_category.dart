import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/category/domain/repositories/category_repository.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import '../../../../core/usecases/usecase.dart';


class ReorderCategories implements UseCase<List<CategoryEntity>, Map<String, int>> {
  final CategoryRepository repository;

  ReorderCategories({
    @required this.repository
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(Map<String, int> params) async {
    return await repository.reorderCategories(params);
  }
}
