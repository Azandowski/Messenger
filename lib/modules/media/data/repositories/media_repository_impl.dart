import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/modules/media/data/datasources/local_media_datasource.dart';
import 'package:messenger_mobile/modules/media/domain/repositories/media_repository.dart';

class MediaRepositoryImpl implements MediaRepository {
  final MediaLocalDataSource mediaLocalDataSource;

  MediaRepositoryImpl({@required this.mediaLocalDataSource});

  @override
  Future<Either<Failure, File>> getImage(ImageSource source) async {
    try {
      var image = await mediaLocalDataSource.getImage(source);
      return Right(image);
    } on StorageFailure {}
  }
}
