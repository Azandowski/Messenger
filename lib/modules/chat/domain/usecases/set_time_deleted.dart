import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';
import 'params.dart';

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