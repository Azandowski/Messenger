import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../creation_module/domain/entities/contact.dart';
import '../repositories/chat_repository.dart';
import 'params.dart';

class GetChatMembers implements UseCase<PaginatedResult<ContactEntity>, GetChatMembersParams> {
  final ChatRepository repository;

  GetChatMembers({
    @required this.repository
  });

  @override
  Future<Either<Failure, PaginatedResult<ContactEntity>>> call(GetChatMembersParams params) {
    return repository.getChatMembers(params.id, params.pagination);
  }
}
