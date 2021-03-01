import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/category/domain/repositories/category_repository.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';

class TransferChats implements UseCase<NoParams, TransferChatsParams> {
  final CategoryRepository repository;

  TransferChats({
    @required this.repository
  });

  @override
  Future<Either<Failure, NoParams>> call(TransferChatsParams params) async {
    return await repository.transferChats(params.chatsIDs, params.newCategoryId);
  }
  
}