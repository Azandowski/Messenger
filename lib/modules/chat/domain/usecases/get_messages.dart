import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetMessages implements UseCase<PaginatedResultViaLastItem<Message>, int> {
  final ChatRepository repository;

  GetMessages({
    @required this.repository
  });

  @override
  Future<Either<Failure, PaginatedResultViaLastItem<Message>>> call(int lastMessageId) async {
    return repository.getChatMessages(lastMessageId);
  } 
}
