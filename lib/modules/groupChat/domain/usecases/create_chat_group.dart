import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../category/domain/entities/chat_entity.dart';
import '../repositories/chat_group_repository.dart';
import 'params.dart';

class CreateChatGruopUseCase extends UseCase<ChatEntity, CreateChatGroupParams>  {

  final ChatGroupRepository repository;

  CreateChatGruopUseCase({
    @required this.repository,
  });

  @override
  Future<Either<Failure, ChatEntity>> call(CreateChatGroupParams params) async {
    return await repository.createGroupChat(params);
  }
}