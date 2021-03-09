import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_group_repository.dart';
import 'params.dart';

class CreateChatGruopUseCase extends UseCase<bool, CreateChatGroupParams>  {

  final ChatGroupRepository repository;

  CreateChatGruopUseCase({
    @required this.repository,
  });

  @override
  Future<Either<Failure, bool>> call(CreateChatGroupParams params) async {
    return await repository.createGroupChat(params);
  }
}