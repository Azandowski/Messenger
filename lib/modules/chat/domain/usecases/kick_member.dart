import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';

class KickMembers implements UseCase<ChatDetailed, KickMemberParams> {
  final ChatRepository repository;

  KickMembers({
    @required this.repository
  });

  @override
  Future<Either<Failure, ChatDetailed>> call(KickMemberParams params) async {
    return repository.kickMember(params.id, params.userID);
  } 
}
