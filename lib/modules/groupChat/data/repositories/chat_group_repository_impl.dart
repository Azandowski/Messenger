import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../category/domain/entities/chat_entity.dart';
import '../../domain/repositories/chat_group_repository.dart';
import '../../domain/usecases/params.dart';
import '../datasources/chat_group_remote_datasource.dart';

class ChatGroupRepositoryImpl implements ChatGroupRepository{
  final ChatGroupRemoteDataSource remoteDataSource;

  ChatGroupRepositoryImpl({
    @required this.remoteDataSource
  });
  

  @override
  Future<Either<Failure, ChatEntity>> createGroupChat(CreateChatGroupParams createChatGroupParams) async {
     try {
        final response = await remoteDataSource.createChatGroup(groupParams: createChatGroupParams);
        return Right(response);
      } catch (e) {
        return Left(e);
      }
  }
}