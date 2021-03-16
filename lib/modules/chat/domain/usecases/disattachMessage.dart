import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class DisAttachMessage implements UseCase<bool, NoParams> {
  final ChatRepository repository;

  DisAttachMessage({
    @required this.repository
  });

  @override
  Future<Either<Failure, bool>> call(NoParams noParams) {
    return repository.disAttachMessage(noParams);
  }
}
