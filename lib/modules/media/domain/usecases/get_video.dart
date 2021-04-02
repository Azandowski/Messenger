import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/media_repository.dart';

class GetVideo implements UseCase<File, NoParams> {
  final MediaRepository repository;

  GetVideo(this.repository);

  @override
  Future<Either<Failure, File>> call(NoParams noParams) async {
    return await repository.getVideo();
  }
}
