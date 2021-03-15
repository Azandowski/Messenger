import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';
import 'params.dart';

class SendMessage implements UseCase<Message, SendMessageParams> {
  final ChatRepository repository;

  SendMessage({
    @required this.repository
  });

  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) {
    return repository.sendMessage(params);
  }
}
