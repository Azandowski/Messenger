import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/config/language.dart';
import 'package:messenger_mobile/modules/chat/data/models/translation_response.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/delete_messages.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/network/paginatedResult.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/pagination.dart';
import '../../../category/data/models/chat_permission_model.dart';
import '../../../category/domain/entities/chat_permissions.dart';
import '../../../creation_module/domain/entities/contact.dart';
import '../../../social_media/domain/entities/social_media.dart';
import '../../data/datasources/chat_datasource.dart';
import '../../data/models/chat_message_response.dart';
import '../../presentation/chat_details/page/chat_detail_screen.dart';
import '../entities/chat_detailed.dart';
import '../entities/message.dart';
import '../usecases/params.dart';

abstract class ChatRepository {
  Future<Either<Failure, ChatDetailed>> getChatDetails(
      int id, ProfileMode mode);
  Future<Either<Failure, PaginatedResult<ContactEntity>>> getChatMembers(
      int id, Pagination pagination);
  Future<Either<Failure, Message>> sendMessage(SendMessageParams params);
  Future<Either<Failure, bool>> deleteMessage(DeleteMessageParams params);
  Future<Either<Failure, ChatDetailed>> addMembers(int id, List<int> members);
  Future<Either<Failure, ChatDetailed>> kickMember(int id, int userID);
  Stream<Message> message;
  Stream<DeleteMessageEntity> deleteIds;
  Future<Either<Failure, NoParams>> leaveChat(int id);
  Future<Either<Failure, ChatPermissions>> updateChatSettings(
      {ChatPermissionModel permissions, int id});
  Future<Either<Failure, ChatMessageResponse>> getChatMessages(
      int lastMessageId, RequestDirection direction);

  Future<Either<Failure, ChatPermissions>> setTimeDeleted({int id, bool isOn});

  // Future<Either<Failure, ChatPermissions>> setSocialMedia(
  //     {int id, SocialMedia socialMedia});

  Future<Either<Failure, ChatPermissions>> setSocialMedia(
      {int id, SocialMedia socialMedia});

  Future<Either<Failure, bool>> blockUser(int id);
  Future<Either<Failure, bool>> unblockUser(int id);

  Future<void> disposeChat();
  Future<Either<Failure, bool>> attachMessage(Message message);
  Future<Either<Failure, bool>> disAttachMessage(NoParams noParams);
  Future<Either<Failure, bool>> replyMore(ReplyMoreParams params);
  Future<Either<Failure, ChatMessageResponse>> getChatMessageContext(
      int chatID, int messageID);
  Future<void> markMessageAsRead(MarkAsReadParams params);

  // MARK: - Translation
  Future<Either<Failure, TranslationResponse>> translateMessage(
      int messageID, String message, ApplicationLanguage language);

  Future<Either<Failure, TranslationResponse>> getOldTranslation(
      int messageID, ApplicationLanguage language);
}
