import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'params.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class DeleteMessage implements UseCase<bool, DeleteMessageParams> {
  final ChatRepository repository;

  DeleteMessage({
    @required this.repository
  });

  @override
  Future<Either<Failure, bool>> call(DeleteMessageParams ids) {
    return repository.deleteMessage(ids);
  }
}
