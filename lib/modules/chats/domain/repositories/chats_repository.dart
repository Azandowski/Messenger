
import 'dart:async';

import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../category/domain/entities/chat_entity.dart';
import '../usecase/params.dart';

abstract class ChatsRepository {  
  Future<Either<Failure, PaginatedResultViaLastItem<ChatEntity>>> getUserChats(
    GetChatsParams params
  );

  Future<Either<Failure, List<ChatEntity>>> getCategoryChats (
    GetCategoryChatsParams params
  );

  List<ChatEntity> currentChats;

  StreamController<List<ChatEntity>> chatsController;

  Future<File> getLocalWallpaper ();

  Future<void> setLocalWallpaper(File file); 

  Stream<ChatEntity> message(id);
}
