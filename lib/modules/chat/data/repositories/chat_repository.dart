import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';
import 'package:messenger_mobile/modules/chat/data/datasources/chat_datasource.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatDataSource chatDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl({
    @required this.chatDataSource, 
    @required this.networkInfo
  });
  
  @override
  Future<Either<Failure, ChatDetailed>> getChatDetails(int id) async {
    if (await networkInfo.isConnected) { 
      try {
        final response = await chatDataSource.getChatDetails(id);
        return Right(response);
      } catch (e) {
        return Left(e);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, PaginatedResult<ContactEntity>>> getChatMembers(
    int id, 
    Pagination pagination
  ) async {
    if (await networkInfo.isConnected) { 
      try {
        final response = await chatDataSource.getChatMembers(id, pagination);
        return Right(response);
      } catch (e) {
        return Left(e);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
  
  @override
  Stream<Message> get  message async*{
    yield* chatDataSource.messages;
  }

  @override
  Future<Either<Failure, bool>> sendMessage(SendMessageParams params) async {
    try{
      await chatDataSource.sendMessage(params);
      return Right(true);
    } catch (e) {
      return Left(e);
    }
  }
}