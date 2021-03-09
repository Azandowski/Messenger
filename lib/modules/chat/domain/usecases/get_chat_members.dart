import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';

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
