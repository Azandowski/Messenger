import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/category/domain/repositories/category_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../chats/domain/entities/category.dart';

class DeleteCategory implements UseCase<CategoryEntity, int> {
  final CategoryRepository repository;

  DeleteCategory({
    @required this.repository
  });

  @override
  Future<Either<Failure,CategoryEntity>> call(
      int id) async {
    return await repository.deleteCategory(id);
  }
}
