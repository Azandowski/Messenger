import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chat/data/models/chat_message_response.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';

class GetMessagesContext implements UseCase<ChatMessageResponse, GetMessagesContextParams> {
  final ChatRepository repository;

  GetMessagesContext({
    @required this.repository
  });

  @override
  Future<Either<Failure, ChatMessageResponse>> call(GetMessagesContextParams params) {
    return repository.getChatMessageContext(params.chatID, params.messageID);
  }
}
