
import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../category/domain/entities/chat_entity.dart';
import '../entities/chat_search_response.dart';
import '../usecase/params.dart';

abstract class ChatsRepository {  
  Future<Either<Failure, PaginatedResultViaLastItem<ChatEntity>>> getUserChats(
    GetChatsParams params
  );

  Future<Either<Failure, PaginatedResultViaLastItem<ChatEntity>>> getCategoryChats (
    GetCategoryChatsParams params
  );

  Future<File> getLocalWallpaper ();

  Stream<ChatEntity> chats;

  Future<void> saveNewChatLocally (ChatEntity model);

  Future<void> removeAllChats ();

  Future<Either<Failure, ChatMessageResponse>> searchChats ({
    Uri nextPageURL,
    String queryText,
    int chatID
  });
}
