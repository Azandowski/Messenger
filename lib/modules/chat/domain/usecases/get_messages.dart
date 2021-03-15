import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetMessages implements UseCase<PaginatedResultViaLastItem<Message>, GetMessagesParams> {
  final ChatRepository repository;

  GetMessages({
    @required this.repository
  });

  @override
  Future<Either<Failure, PaginatedResultViaLastItem<Message>>> call(GetMessagesParams params) async {
    return repository.getChatMessages(params.lastMessageId, params.direction);
  } 
}
