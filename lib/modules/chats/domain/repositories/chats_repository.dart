
import 'dart:async';

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_entity_model.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/chat_search_response.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../category/domain/entities/chat_entity.dart';
import '../usecase/params.dart';

abstract class ChatsRepository {  
  Future<Either<Failure, PaginatedResultViaLastItem<ChatEntity>>> getUserChats(
    GetChatsParams params
  );

  Future<Either<Failure, PaginatedResultViaLastItem<ChatEntity>>> getCategoryChats (
    GetCategoryChatsParams params
  );

  Future<File> getLocalWallpaper ();

  Future<void> setLocalWallpaper(File file); 

  Stream<ChatEntity> chats;

  Future<void> saveNewChatLocally (ChatEntityModel model);

  Future<void> removeAllChats ();

  Future<Either<Failure, ChatMessageResponse>> searchChats ({
    int lastChatId,
    String queryText
  });
}
