import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/media_repository.dart';

class GetAudios implements UseCase<List<File>, NoParams> {
  final MediaRepository repository;

  GetAudios(this.repository);

  @override
  Future<Either<Failure, List<File>>> call(NoParams params) async {
    return await repository.getAudio();
  }
}
