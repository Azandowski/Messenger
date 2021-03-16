import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chat/data/models/chat_message_response.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class GetMessages implements UseCase<ChatMessageResponse, GetMessagesParams> {
  final ChatRepository repository;

  GetMessages({
    @required this.repository
  });

  @override
  Future<Either<Failure, ChatMessageResponse>> call(GetMessagesParams params) async {
    return repository.getChatMessages(params.lastMessageId, params.direction);
  } 
}
