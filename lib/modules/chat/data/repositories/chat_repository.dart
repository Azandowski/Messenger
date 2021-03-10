import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_permission_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';
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
        if (e is Failure) {
          return Left(e);
        } else {
          return Left(ServerFailure(message: e.toString()));
        }
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
  Future<Either<Failure, Message>> sendMessage(SendMessageParams params) async {
    try {
      final message = await chatDataSource.sendMessage(params);
      return Right(message);
    } on SocketException catch(e){
      return Left(ServerFailure(message: 'no_internet'));
    } catch (e){
      return Left(e);
    }
  }
  
  @override
  Future<Either<Failure, ChatDetailed>> addMembers(int id, List<int> members) async {
    if (await networkInfo.isConnected) { 
      try {
        final response = await chatDataSource.addMembers(id, members);
        return Right(response);
      } catch (e) {
        return Left(e);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }


  @override
  Future<Either<Failure, NoParams>> leaveChat(int id) async {
    if (await networkInfo.isConnected) { 
      try {
        final response = await chatDataSource.leaveChat(id);
        return Right(NoParams());
      } catch (e) {
        return Left(e);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ChatPermissions>> updateChatSettings({
    @required ChatPermissionModel permissions, 
    @required int id
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await chatDataSource.updateChatSettings(
          chatUpdates: permissions.toJson(),
          id: id
        );
        
        return Right(response);
      } catch (e) {
        return Left(e);
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}