import 'dart:io';

import 'package:messenger_mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';

class SetWallpaper implements UseCase<NoParams, File> {
  final ChatsRepository repository;

  SetWallpaper(this.repository);

  @override
  Future<Either<Failure, NoParams>> call(File file) async {
    await repository.setLocalWallpaper(file);
    return Right(NoParams());
  }
}
