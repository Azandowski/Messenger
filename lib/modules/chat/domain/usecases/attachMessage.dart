import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class AttachMessage implements UseCase<bool, Message> {
  final ChatRepository repository;

  AttachMessage({
    @required this.repository
  });

  @override
  Future<Either<Failure, bool>> call(Message message) {
    return repository.attachMessage(message);
  }
}
