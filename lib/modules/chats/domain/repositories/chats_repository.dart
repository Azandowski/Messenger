import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/usecases/params.dart';

abstract class ChatsRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories(GetCategoriesParams getCategoryParams);
}
