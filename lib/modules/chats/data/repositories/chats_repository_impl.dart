import 'dart:async';

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chats/data/datasource/local_chats_datasource.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../category/domain/entities/chat_entity.dart';
import '../../domain/repositories/chats_repository.dart';
import '../../domain/usecase/params.dart';
import '../datasource/chats_datasource.dart';

class ChatsRepositoryImpl extends ChatsRepository {
  final ChatsDataSource chatsDataSource;
  final LocalChatsDataSource localChatsDataSource;
  final NetworkInfo networkInfo;

  bool hasInitialized = false;

  ChatsRepositoryImpl({
    @required this.chatsDataSource, 
    @required this.localChatsDataSource,
    @required this.networkInfo
  }) {
    initRepository();
  }


  void initRepository () async {
    if (await networkInfo.isConnected) {
      localChatsDataSource.resetAll();
    }
  }

  @override
  StreamController<List<ChatEntity>> chatsController = StreamController<List<ChatEntity>>.broadcast();

  @override
  List<ChatEntity> currentChats = [];

  // * * Methods

  @override
  Future<Either<Failure, PaginatedResultViaLastItem<ChatEntity>>> getUserChats(GetChatsParams params) async {
    List<ChatEntity> chatsFromLocal = await localChatsDataSource.getCategoryChats(null);
    
    if (chatsFromLocal.length != 0 && params.lastChatID == null) {
      return Right(PaginatedResultViaLastItem<ChatEntity>(
        data: chatsFromLocal,
        hasReachMax: false
      ));
    } else if (await networkInfo.isConnected) {
      try {
        final response = await chatsDataSource.getUserChats(
          token: params.token, 
          lastChatId: params.lastChatID
        );

        await localChatsDataSource.setCategoryChats(response.data);

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
      return Right(PaginatedResultViaLastItem<ChatEntity>(
        data: chatsFromLocal,
        hasReachMax: false
      ));
    }
  }


  @override
  Future<Either<Failure, PaginatedResultViaLastItem<ChatEntity>>> getCategoryChats(GetCategoryChatsParams params) async {
    List<ChatEntity> chatsFromLocal = await localChatsDataSource.getCategoryChats(params.categoryID);
    
    if (chatsFromLocal.length != 0 && params.lastChatID == null) {
      return Right(PaginatedResultViaLastItem<ChatEntity>(
        data: chatsFromLocal,
        hasReachMax: false
      ));
    } else if (await networkInfo.isConnected) { 
      try {
        final response = await chatsDataSource.getCategoryChat(
          token: params.token, 
          categoryID: params.categoryID,
          lastChatId: params.lastChatID
        );

        // Save chats in local storage
        await localChatsDataSource.setCategoryChats(response.data);

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
      return Right(PaginatedResultViaLastItem<ChatEntity>(
        data: chatsFromLocal,
        hasReachMax: false
      ));
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