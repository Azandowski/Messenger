import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../category/domain/entities/chat_entity.dart';
import '../repositories/chats_repository.dart';
import 'params.dart';

class GetCategoryChats extends UseCase<PaginatedResultViaLastItem<ChatEntity>, GetCategoryChatsParams> {
  final ChatsRepository repository;
  
  GetCategoryChats(this.repository);

  @override
  Future<Either<Failure, PaginatedResultViaLastItem<ChatEntity>>> call(params) async {
    return await repository.getCategoryChats(params);
  }
}