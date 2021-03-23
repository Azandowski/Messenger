import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat_detailed.dart';
import '../repositories/chat_repository.dart';
import 'params.dart';

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
