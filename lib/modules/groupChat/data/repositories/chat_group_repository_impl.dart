import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../datasources/chat_group_remote_datasource.dart';
import '../../domain/repositories/chat_group_repository.dart';
import '../../domain/usecases/params.dart';

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