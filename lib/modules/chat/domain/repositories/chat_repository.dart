import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_permission_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import '../../../../core/error/failures.dart';


abstract class ChatRepository {
  Future<Either<Failure, ChatDetailed>> getChatDetails (int id);
  Future<Either<Failure, PaginatedResult<ContactEntity>>> getChatMembers (int id, Pagination pagination);
  Future<Either<Failure, Message>> sendMessage(SendMessageParams params);
  Future<Either<Failure, ChatDetailed>> addMembers (int id, List<int> members);
  Stream<Message> message;
  Future<Either<Failure, NoParams>> leaveChat (int id);
  Future<Either<Failure, ChatPermissions>> updateChatSettings({ ChatPermissionModel permissions, int id }); 
  Future<Either<Failure, PaginatedResultViaLastItem<Message>>> getChatMessages (int lastMessageId);
  Future<void> disposeChat();
}