import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/params.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class ReplyMore implements UseCase<bool, ReplyMoreParams> {
  final ChatRepository repository;

  ReplyMore({
    @required this.repository
  });

  @override
  Future<Either<Failure, bool>> call(ReplyMoreParams params) {
    return repository.replyMore(params);
  }
}
