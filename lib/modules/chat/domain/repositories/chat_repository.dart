import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import '../../../../core/error/failures.dart';


abstract class ChatRepository {
  Future<Either<Failure, ChatDetailed>> getChatDetails (int id);
}