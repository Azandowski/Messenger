import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';

class AddMembers implements UseCase<ChatDetailed, AddMembersToChatParams> {
  final ChatRepository repository;

  AddMembers({
    @required this.repository
  });

  @override
  Future<Either<Failure, ChatDetailed>> call(AddMembersToChatParams params) async {
    return repository.addMembers(params.id, params.members);
  } 
}
