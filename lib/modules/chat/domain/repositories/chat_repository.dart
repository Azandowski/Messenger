import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import '../../../../core/error/failures.dart';


abstract class ChatRepository {
  Future<Either<Failure, ChatDetailed>> getChatDetails (int id);
  Future<Either<Failure, PaginatedResult<ContactEntity>>> getChatMembers (int id, Pagination pagination);
  Future<Either<Failure, bool>> sendMessage(SendMessageParams params);
  Stream<Message> message;
}