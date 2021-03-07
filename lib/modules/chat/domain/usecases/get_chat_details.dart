import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';

class GetChatDetails implements UseCase<ChatDetailed, int> {
  final ChatRepository repository;

  GetChatDetails({
    @required this.repository
  });

  @override
  Future<Either<Failure, ChatDetailed>> call(int params) async {
    return repository.getChatDetails(params);
  } 
}
