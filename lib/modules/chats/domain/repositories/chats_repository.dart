
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/params.dart';

abstract class ChatsRepository {  
  Future<Either<Failure, PaginatedResult<ChatEntity>>> getUserChats(
    GetChatsParams params
  );

  Future<Either<Failure, List<ChatEntity>>> getCategoryChats (
    GetCategoryChatsParams params
  );

  List<ChatEntity> currentChats;

  StreamController<List<ChatEntity>> chatsController;
}
