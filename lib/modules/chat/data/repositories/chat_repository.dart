import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/modules/chat/data/datasources/chat_datasource.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';

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
  Stream<Message> get  message async*{
     yield* chatDataSource.messages;
  }
}