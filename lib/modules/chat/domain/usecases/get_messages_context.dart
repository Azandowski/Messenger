import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';


class GetMessagesContext implements UseCase<PaginatedResultViaLastItem<Message>, GetMessagesContextParams> {
  final ChatRepository repository;

  GetMessagesContext({
    @required this.repository
  });

  @override
  Future<Either<Failure, PaginatedResultViaLastItem<Message>>> call(GetMessagesContextParams params) {
    return repository.getChatMessageContext(params.chatID, params.messageID);
  }
}
