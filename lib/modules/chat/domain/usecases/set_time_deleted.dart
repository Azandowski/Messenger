import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';

class SetTimeDeleted implements UseCase<NoParams, SetTimeDeletedParams> {
  final ChatRepository repository;

  SetTimeDeleted({
    @required this.repository
  });

  @override
  Future<Either<Failure, NoParams>> call(SetTimeDeletedParams params) {
    return repository.setTimeDeleted(id: params.id, timeInSeconds: params.seconds);
  }
}