import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat_detailed.dart';
import '../repositories/chat_repository.dart';

class GetChatDetails implements UseCase<ChatDetailed, GetChatDetailsParams> {
  final ChatRepository repository;

  GetChatDetails({
    @required this.repository
  });

  @override
  Future<Either<Failure, ChatDetailed>> call(GetChatDetailsParams params) async {
    return repository.getChatDetails(params.id, params.mode);
  } 
}
