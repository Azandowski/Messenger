import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../category/domain/entities/chat_entity.dart';
import '../usecases/params.dart';

abstract class ChatGroupRepository {

  Future<Either<Failure, ChatEntity>> createGroupChat(
    CreateChatGroupParams createChatGroupParams
  );
}