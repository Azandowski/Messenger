import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';

class SendMessage implements UseCase<bool, SendMessageParams> {
  final ChatRepository repository;

  SendMessage({
    @required this.repository
  });

  @override
  Future<Either<Failure, bool>> call(SendMessageParams params) {
    return repository.sendMessage(params);
  }
}
