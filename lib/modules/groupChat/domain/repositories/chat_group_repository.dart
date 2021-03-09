import 'dart:async';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../usecases/params.dart';

abstract class ChatGroupRepository {

  Future<Either<Failure, bool>> createGroupChat(
    CreateChatGroupParams createChatGroupParams
  );

}