import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/network_info.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/pagination.dart';
import '../../../category/data/models/chat_permission_model.dart';
import '../../../category/domain/entities/chat_permissions.dart';
import '../../../creation_module/domain/entities/contact.dart';
import '../../domain/entities/chat_detailed.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/params.dart';
import '../datasources/chat_datasource.dart';

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
  Stream<Message> get message async* {
    yield* chatDataSource.messages;
  }

  @override
  Stream<List<int>> get deleteIds async* {
    yield* chatDataSource.deleteIds;
  }

  @override
  Future<Either<Failure, Message>> sendMessage(SendMessageParams params) async {
    try {
      final message = await chatDataSource.sendMessage(params);
      return Right(message);
    } on SocketException catch(e){
      return Left(ServerFailure(message: 'no_internet'));
    } catch (e){
      if (e is Failure) {
        return Left(e);
      } else {
        return Left(ServerFailure(message: e.toString()));
      }
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
  Future<Either<Failure, ChatDetailed>> kickMember(int id, int userID) async {
    if (await networkInfo.isConnected) {
      try {
        final reponse = await chatDataSource.kickMember(id, userID);
        return Right(reponse);
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
  Future<Either<Failure, NoParams>> leaveChat(int id) async {
    if (await networkInfo.isConnected) { 
      try {
        final response = await chatDataSource.leaveChat(id);
        return Right(NoParams());
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
  Future<Either<Failure, PaginatedResultViaLastItem<Message>>> getChatMessages(int lastMessageId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await chatDataSource.getChatMessages(lastMessageId);
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
  Future<Either<Failure, NoParams>> setTimeDeleted({int id, int timeInSeconds}) async {
    if (await networkInfo.isConnected) { 
      try {
        final response = await chatDataSource.setTimeDeleted(id: id, timeInSeconds: timeInSeconds);
        return Right(NoParams());
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
  Future<void> disposeChat() {
    return chatDataSource.disposeChat();
  }

  @override
  Future<Either<Failure, bool>> deleteMessage(DeleteMessageParams params) async {
    try {
        await chatDataSource.deleteMessage(params);
        return Right(true);
      } catch (e) {
        if (e is Failure) {
          return Left(e);
        } else {
          return Left(ServerFailure(message: e.toString()));
      }
    }
  }
}