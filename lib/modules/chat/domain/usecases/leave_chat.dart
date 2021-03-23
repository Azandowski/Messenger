import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

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
