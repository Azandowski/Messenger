import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'params.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class BlockUser implements UseCase<bool, BlockUserParams> {
  final ChatRepository repository;

  BlockUser({
    @required this.repository
  });

  @override
  Future<Either<Failure, bool>> call(BlockUserParams params) {
    if (params.isBloc) {
      return repository.blockUser(params.userID);
    } else {
      return repository.unblockUser(params.userID);
    }
  }
}
