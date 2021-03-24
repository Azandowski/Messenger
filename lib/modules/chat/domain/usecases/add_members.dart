import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat_detailed.dart';
import '../repositories/chat_repository.dart';
import 'params.dart';

class AddMembers implements UseCase<ChatDetailed, AddMembersToChatParams> {
  final ChatRepository repository;

  AddMembers({@required this.repository});

  @override
  Future<Either<Failure, ChatDetailed>> call(
      AddMembersToChatParams params) async {
    return repository.addMembers(params.id, params.members);
  }
}
