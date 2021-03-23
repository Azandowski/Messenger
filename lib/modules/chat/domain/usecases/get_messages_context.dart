import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/chat_message_response.dart';
import '../repositories/chat_repository.dart';
import 'params.dart';

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
