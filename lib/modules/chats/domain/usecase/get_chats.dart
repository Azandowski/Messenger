import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../category/domain/entities/chat_entity.dart';
import '../repositories/chats_repository.dart';
import 'params.dart';

class GetChats extends UseCase<PaginatedResult<ChatEntity>, GetChatsParams> {
  final ChatsRepository repository;

  GetChats(this.repository);

  @override
  Future<Either<Failure, PaginatedResult<ChatEntity>>> call(GetChatsParams params) async {
    return repository.getUserChats(params);
  }
}