import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chat/domain/repositories/chat_repository.dart';

class LeaveChat implements UseCase<NoParams, int> {
  final ChatRepository repository;

  LeaveChat({
    @required this.repository
  });

  @override
  Future<Either<Failure, NoParams>> call(int id) async {
    return repository.leaveChat(id);
  } 
}
