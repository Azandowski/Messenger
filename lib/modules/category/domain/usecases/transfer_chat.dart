import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../chats/domain/entities/category.dart';
import '../repositories/category_repository.dart';
import 'params.dart';

class TransferChats implements UseCase<List<CategoryEntity>, TransferChatsParams> {
  final CategoryRepository repository;

  TransferChats({
    @required this.repository
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(TransferChatsParams params) async {
    return await repository.transferChats(params.chatsIDs, params.newCategoryId);
  }
}
