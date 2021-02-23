import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/modules/media/domain/repositories/media_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetImage implements UseCase<File, ImageSource> {
  final MediaRepository repository;

  GetImage(this.repository);

  @override
  Future<Either<Failure, File>> call(ImageSource imageSource) async {
    return await repository.getImage(imageSource);
  }
}
