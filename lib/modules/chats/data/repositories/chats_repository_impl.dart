import 'dart:async';

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../category/domain/entities/chat_entity.dart';
import '../../domain/repositories/chats_repository.dart';
import '../../domain/usecase/params.dart';
import '../datasource/chats_datasource.dart';

class ChatsRepositoryImpl extends ChatsRepository {
  final ChatsDataSource chatsDataSource;
  final NetworkInfo networkInfo;

  ChatsRepositoryImpl({
    @required this.chatsDataSource, 
    @required this.networkInfo
  });

  @override
  StreamController<List<ChatEntity>> chatsController = StreamController<List<ChatEntity>>.broadcast();

  @override
  List<ChatEntity> currentChats = [];

  // * * Methods

  @override
  Future<Either<Failure, PaginatedResultViaLastItem<ChatEntity>>> getUserChats(GetChatsParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await chatsDataSource.getUserChats(
          token: params.token, 
          lastChatId: params.lastChatID
        );

        if (params.lastChatID != null) {
          // Adding not first page
          currentChats.addAll(response.data);
          chatsController.add(currentChats);
        } else {
          // First page

          currentChats = response.data;
          chatsController.add(currentChats);
        }

        return Right(response);
      } catch (e) {
        return Left(e);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<ChatEntity>>> getCategoryChats(GetCategoryChatsParams params) async {
    if (await networkInfo.isConnected) { 
      try {
        final response = await chatsDataSource.getCategoryChat(
          token: params.token, 
          categoryID: params.categoryID
        );

        return Right(response);
      } catch (e) {
        return Left(e);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<File> getLocalWallpaper() {
    return chatsDataSource.getLocalWallpaper();
  }

  @override
  Future<void> setLocalWallpaper(File file) {
    return chatsDataSource.setLocalWallpaper(file);
  }

  @override
  Stream<ChatEntity> message(id) async*{
     yield* chatsDataSource.messages(id);
  }
}
