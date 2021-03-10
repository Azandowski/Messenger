import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';

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
