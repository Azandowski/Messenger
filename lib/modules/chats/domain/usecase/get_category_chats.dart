import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../category/domain/entities/chat_entity.dart';
import '../repositories/chats_repository.dart';
import 'params.dart';

class GetCategoryChats extends UseCase<List<ChatEntity>, GetCategoryChatsParams> {
  final ChatsRepository repository;
  
  GetCategoryChats(this.repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(params) async {
    return await repository.getCategoryChats(params);
  }
}