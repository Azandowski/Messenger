import 'package:messenger_mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/params.dart';

class GetChats extends UseCase<PaginatedResult<ChatEntity>, GetChatsParams> {
  final ChatsRepository repository;

  GetChats(this.repository);

  @override
  Future<Either<Failure, PaginatedResult<ChatEntity>>> call(GetChatsParams params) async {
    return repository.getUserChats(params);
  }
}