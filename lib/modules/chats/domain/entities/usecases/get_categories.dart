import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/usecases/params.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';

class GetCategories implements UseCase<List<CategoryEntity>, GetCategoriesParams> {
  final ChatsRepository repository;

  GetCategories({
    @required this.repository
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(GetCategoriesParams params) async {
    return await repository.getCategories(params);
  }
}