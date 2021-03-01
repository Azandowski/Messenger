import 'package:messenger_mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/params.dart';

class GetCategoryChats extends UseCase<List<ChatEntity>, GetCategoryChatsParams> {
  final ChatsRepository repository;
  
  GetCategoryChats(this.repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(params) async {
    return await repository.getCategoryChats(params);
  }
}