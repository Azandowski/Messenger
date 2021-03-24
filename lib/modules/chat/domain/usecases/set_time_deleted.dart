import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../category/domain/entities/chat_permissions.dart';
import '../repositories/chat_repository.dart';
import 'params.dart';

class SetTimeDeleted implements UseCase<ChatPermissions, SetTimeDeletedParams> {
  final ChatRepository repository;

  SetTimeDeleted({
    @required this.repository
  });

  @override
  Future<Either<Failure, ChatPermissions>> call(SetTimeDeletedParams params) {
    return repository.setTimeDeleted(id: params.id, isOn: params.isOn);
  }
}