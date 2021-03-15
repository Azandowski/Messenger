import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/pagination.dart';
import '../../../category/data/models/chat_permission_model.dart';
import '../../../category/domain/entities/chat_permissions.dart';
import '../../../creation_module/domain/entities/contact.dart';
import '../entities/chat_detailed.dart';
import '../entities/message.dart';
import '../usecases/params.dart';


abstract class ChatRepository {
  Future<Either<Failure, ChatDetailed>> getChatDetails (int id);
  Future<Either<Failure, PaginatedResult<ContactEntity>>> getChatMembers (int id, Pagination pagination);
  Future<Either<Failure, Message>> sendMessage(SendMessageParams params);
  Future<Either<Failure, bool>> deleteMessage(DeleteMessageParams params);
  Future<Either<Failure, ChatDetailed>> addMembers (int id, List<int> members);
  Stream<Message> message;
  Future<Either<Failure, NoParams>> leaveChat (int id);
  Future<Either<Failure, ChatPermissions>> updateChatSettings({ ChatPermissionModel permissions, int id }); 
  Future<Either<Failure, PaginatedResultViaLastItem<Message>>> getChatMessages (int lastMessageId);
  Future<Either<Failure, NoParams>> setTimeDeleted ({
    int id, int timeInSeconds
  });
  Future<void> disposeChat();
}