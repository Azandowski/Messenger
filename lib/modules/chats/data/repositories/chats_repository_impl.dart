import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chats/domain/usecase/params.dart';
import '../../../../core/services/network/network_info.dart';
import '../../domain/repositories/chats_repository.dart';
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
  Future<Either<Failure, PaginatedResult<ChatEntity>>> getUserChats(GetChatsParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await chatsDataSource.getUserChats(
          token: params.token, 
          paginationData: params.paginationData
        );

        if (params.paginationData.isFirstPage) {
          currentChats = response.data;
          chatsController.add(currentChats);
        } else {
          currentChats.addAll(response.data);
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
}
