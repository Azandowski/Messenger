import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../repositories/chats_repository.dart';
import '../category.dart';
import 'params.dart';

class GetCategories
    implements UseCase<List<CategoryEntity>, GetCategoriesParams> {
  final ChatsRepository repository;

  GetCategories({@required this.repository});

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(
      GetCategoriesParams params) async {
    return await repository.getCategories(params);
  }
}
